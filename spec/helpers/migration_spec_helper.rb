shared_context 'test_migration' do
  describe '#create_random_id_functions' do
    it "installs the functions" do
      migration.create_random_id_functions
      
      execute("SELECT 1 FROM pg_proc WHERE proname = 'crockford'").should be
      execute("SELECT 1 FROM pg_proc WHERE proname = 'pri_scramble'").should be
    end

    context "with a key table already in place" do
      before do
        execute """
          CREATE TABLE pri_keys (
            sequence regclass PRIMARY KEY,
            key integer NOT NULL);
        """
      end

      it "does not panic" do
        expect { migration.create_random_id_functions }.to_not raise_error
      end
    end
  end
  
  describe '#drop_random_id_functions' do
    it "removes the functions" do
      migration.create_random_id_functions
      migration.drop_random_id_functions
      
      execute("SELECT 1 FROM pg_proc WHERE proname = 'crockford'").should_not be
      execute("SELECT 1 FROM pg_proc WHERE proname = 'pri_scramble'").should_not be
    end
  end
  
  describe '#random_id' do
    it "changes the default value" do
      migration.create_random_id_functions
      create_table :foo
      migration.random_id :foo
      execute("SELECT 1 FROM pg_attrdef WHERE adrelid = 'foo'::regclass AND adsrc LIKE '%pri_%'").should be
    end

    it "creates a few values without error" do
      migration.create_random_id_functions
      create_table :foo
      migration.random_id :foo
      10.times do
        expect {
          execute('INSERT INTO foo VALUES(default)')
        }.to_not raise_error
      end
      execute("SELECT COUNT(*) FROM foo").first[1].to_i.should == 10
      execute("SELECT id FROM foo LIMIT 1").first[1].to_i.should_not == 1
    end
  end
  
  describe '#remove_random_id' do
    it "restores the default value" do
      migration.create_random_id_functions
      create_table :foo
      migration.random_id :foo
      migration.remove_random_id :foo
      execute("SELECT 1 FROM pg_attrdef WHERE adrelid = 'foo'::regclass AND adsrc LIKE '%pri_%'").should_not be
      execute("INSERT INTO foo VALUES (DEFAULT) RETURNING id;").first[1].to_i.should == 1
    end
    
    it "also works with str id" do
      migration.create_random_id_functions
      create_table :foo
      migration.random_str_id :foo
      migration.remove_random_id :foo
      execute("SELECT 1 FROM pg_attrdef WHERE adrelid = 'foo'::regclass AND adsrc LIKE '%pri_%'").should_not be
      execute("INSERT INTO foo VALUES (DEFAULT) RETURNING id;").first[1].to_i.should == 1
    end
  end

  describe '#random_str_id' do
    it "changes the default value" do
      migration.create_random_id_functions
      create_table :foo
      migration.random_str_id :foo
      execute("SELECT 1 FROM pg_attrdef WHERE adrelid = 'foo'::regclass AND adsrc LIKE '%pri_%'").should be
      execute("INSERT INTO foo VALUES (DEFAULT) RETURNING id;").first[1].should_not == '1'
    end

    it "changes the type" do
      migration.create_random_id_functions
      create_table :foo
      migration.random_str_id :foo
      execute("""
        SELECT typname FROM pg_attribute, pg_type 
          WHERE attrelid = 'foo'::regclass 
            AND attname = 'id' 
            AND atttypid = typelem 
            AND typname LIKE '%int%'
      """).should_not be
    end

    it "creates a few values without error" do
      migration.create_random_id_functions
      create_table :foo
      migration.random_str_id :foo
      10.times do
        expect {
          execute('INSERT INTO foo VALUES(default)')
        }.to_not raise_error
      end
      execute("SELECT COUNT(*) FROM foo").first[1].to_i.should == 10
    end
  end
end
