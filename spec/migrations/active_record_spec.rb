require 'spec_helper'

require 'active_record'
require 'pg_random_id/migrations/active_record'

describe PgRandomId::Migrations::ActiveRecord do
  include_context 'active_record'
  describe '#create_random_id_functions' do
    it "installs the pri_scramble function" do
      migration.create_random_id_functions
      
      execute("SELECT 1 FROM pg_proc WHERE proname = 'crockford'").should be
      execute("SELECT 1 FROM pg_proc WHERE proname = 'pri_scramble'").should be
    end
  end
  
  describe '#random_id' do
    it "changes the default value" do
      migration.create_random_id_functions
      migration.create_table :foo
      migration.random_id :foo
      execute("SELECT 1 FROM pg_attrdef WHERE adrelid = 'foo'::regclass AND adsrc LIKE '%pri_scramble%'").should be
    end

    it "creates a few values without error" do
      migration.create_random_id_functions
      migration.create_table :foo
      migration.random_id :foo
      10.times do
        expect {
          ActiveRecord::Base.connection.execute('INSERT INTO foo VALUES(default)')
        }.to_not raise_error
      end
      execute("SELECT COUNT(*) FROM foo")['count'].to_i.should == 10
    end
  end
end
