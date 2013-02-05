require 'active_record/migration'
require 'pg_random_id/sql'

module PgRandomId
  module Migrations
    module ActiveRecord
      def create_random_id_functions
        execute PgRandomId::Sql::install
      end
      
      def random_id table, column = :id, key = nil
        execute PgRandomId::Sql::apply(table, column, key)
      end
    end
  end
end

ActiveRecord::Migration.send :include, PgRandomId::Migrations::ActiveRecord
