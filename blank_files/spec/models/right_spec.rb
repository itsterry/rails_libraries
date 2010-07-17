require 'spec_helper'

describe Right do
  before(:each) do
    @valid_attributes = {
      :controller => "value for controller",
      :action => "value for action"
    }
    @thingclass=Right
    @thing=@thingclass.find(rights(:one).id)
  end

  it "should create a new instance given valid attributes" do
    @thingclass.create!(@valid_attributes)
    @thing.should be_valid
  end

  acts_as_generic_right
end
