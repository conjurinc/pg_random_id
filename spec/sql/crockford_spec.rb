require 'spec_helper'

require 'active_record'

describe 'crockford(bigint)' do
  include_context 'active_record'
  before do
    migration.create_random_id_functions
  end
  
  def crockford argument
    execute("SELECT crockford(#{argument})")['crockford']
  end

  it "returns correct encodings for a few chosen values" do
    {
      0 => '0',
      1 => '1',
      31 => 'z',
      32 => '10',
      1712969022158652754 => '1fhdg7zyg7haj',
      9223372036854775807 => '7zzzzzzzzzzzz'
    }.each {|k, v| crockford(k).should == v}
  end
  
  it "errors out on negative numbers" do
    expect{crockford(-1)}.to raise_error
  end
end
