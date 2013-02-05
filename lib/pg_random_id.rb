require "pg_random_id/sql"
require "pg_random_id/version"

if defined? ActiveRecord
  require "pg_random_id/migrations/active_record"
end

module PgRandomId
end
