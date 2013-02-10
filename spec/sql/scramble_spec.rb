require 'spec_helper'

require 'active_record'

describe "pri_scramble(bigint, bigint)" do
  include_context 'active_record'
  before do
    migration.create_random_id_functions
  end
  
  it "seems to have no collisions" do
    COUNT = 10000
    KEY = rand(2**32)
    CODE = "SELECT COUNT(DISTINCT pri_scramble(#{KEY}, seq)) FROM generate_series(1, #{COUNT}) AS s(seq)"
    execute(CODE)['count'].to_i.should == COUNT
  end
end
