require 'spec_helper'

require 'active_record'
require 'pg_random_id/migrations/active_record'

describe PgRandomId::Migrations::ActiveRecord do
  include_context 'active_record'
  describe '#create_random_id_functions' do
    it "installs the pri_scramble function" do
      migration.create_random_id_functions
      ActiveRecord::Base.connection.select_one("SELECT 1 FROM pg_proc WHERE proname = 'pri_scramble'").should be
    end
  end
end
