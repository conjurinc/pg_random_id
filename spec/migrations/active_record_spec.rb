require 'spec_helper'

require 'active_record'
require 'pg_random_id/migrations/active_record'

describe PgRandomId::Migrations::ActiveRecord do
  include_context 'active_record'
  include_context 'test_migration'
end
