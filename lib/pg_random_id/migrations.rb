require 'pg_random_id/sql'

module PgRandomId
  module Migrations
    # Create in the database the functions
    # necessary for this gem to work.
    def create_random_id_functions
      execute PgRandomId::Sql::install
    end
    
    # Drop the functions installed by #create_random_id_functions
    def drop_random_id_functions
      execute PgRandomId::Sql::uninstall
    end
    
    # Apply a random id to a table.
    # If you don't give a key, a random one will be generated.
    # The ids will be based on sequence "#{table}_#{column}_seq".
    # You need to make sure the table is empty; migrating existing records is not implemented.
    def random_id table, column = :id, key = nil
      execute PgRandomId::Sql::apply(table, column, key)
    end

    # Apply a random string id to a table. 
    # Also changes the type of the id column to char(6).
    # If you don't give a key, a random one will be generated.
    # The ids will be based on sequence "#{table}_#{column}_seq", 
    # scrambled and base32-encoded.
    # You need to make sure the table is empty; migrating existing records is not implemented.
    def random_str_id table, column = :id, key = nil
      execute PgRandomId::Sql::apply_str(table, column, key)
    end
    
    # Install the migration functions for ActiveRecord
    def self.install_active_record
      require 'active_record/migration'
      ActiveRecord::Migration.send :include, self
    end

    # Install the migration functions for Sequel
    def self.install_sequel
      Sequel::Database.send :include, self
    end
  end
end

PgRandomId::Migrations::install_active_record if defined? ActiveRecord
PgRandomId::Migrations::install_sequel if defined? Sequel
