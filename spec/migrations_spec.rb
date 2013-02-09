require 'spec_helper'

describe PgRandomId::Migrations do
  context "with ActiveRecord" do
    include_context 'active_record'
    PgRandomId::Migrations.install_active_record
    include_context 'test_migration'
  end

  context "with Sequel" do
    include_context 'sequel'
    PgRandomId::Migrations.install_sequel
    include_context 'test_migration'
  end
end
