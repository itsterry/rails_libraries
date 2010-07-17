require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {
      :firstname => "value for firstname",
      :lastname => "value for lastname",
      :email => "value for email"
    }
    @thingclass=User
    @thing=@thingclass.find(users(:one).id)
  end

  it "should create a new instance given valid attributes" do
    @thingclass.create!(@valid_attributes)
    @thing.should be_valid
  end

  has_terrys_user_functions

end
