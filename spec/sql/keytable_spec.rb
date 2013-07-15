require 'spec_helper'

require 'active_record'

describe "pri_nextval(regclass)" do
  include_context 'active_record'
  before do
    migration.create_random_id_functions
    migration.create_table :foo
    migration.random_id :foo
  end

  context "with removed key entry" do
    before do
      execute "DELETE FROM pri_keys"
    end

    it "doesn't quietly return null" do
      execute("SELECT pri_nextval('foo_id_seq'::regclass)").values[0].should_not be_nil
    end
  end
end
