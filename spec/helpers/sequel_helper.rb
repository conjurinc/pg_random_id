shared_context 'sequel' do
  require 'sequel'
  
  let(:dburl) { ENV['TEST_DATABASE_URL'] || 'postgres:///pg_random_id_test' }
  let(:db) { Sequel::connect dburl }
  
  around do |example|
    db.transaction rollback: :always do
      example.run
    end
  end
  
  let(:migration) { db }

  def execute code
    db[code].first
  end
  
  def create_table *a
    db.create_table *a do
      primary_key :id
    end
  end
end
