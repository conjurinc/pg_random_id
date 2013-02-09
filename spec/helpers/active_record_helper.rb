shared_context 'active_record' do
  require 'active_record'
  
  before do
    dburl = ENV['TEST_DATABASE_URL'] || 'postgres:///pg_random_id_test'
    ActiveRecord::Base.establish_connection dburl
    ActiveRecord::Base.connection.execute 'BEGIN;'
  end
  
  before do
    ActiveRecord::Migration.verbose = false
  end

  after do
    ActiveRecord::Base.connection.execute 'ROLLBACK;'
  end
  
  let(:migration) {
    Class.new(ActiveRecord::Migration)
  }

  def execute code
    ActiveRecord::Base.connection.select_one(code)
  end
  
  def create_table *a
    migration.create_table *a
  end
end
