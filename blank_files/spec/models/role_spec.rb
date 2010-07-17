require 'spec_helper'

describe Role do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :parent_id => 1,
      :admin => 1,
      :god => 1
    }
    @thingclass=Role
    @thing=@thingclass.find(roles(:one).id)
  end

  it "should create a new instance given valid attributes" do
    @thingclass.create!(@valid_attributes)
    @thing.should be_valid
  end

  acts_as_generic_role
end