# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
require 'spec/autorun'
require 'spec/rails'
require RAILS_ROOT+'/lib/rails_libraries/terrys_tests'


include Terrys_tests

# Uncomment the next line to use webrat's matchers
#require 'webrat/integrations/rspec-rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  config.global_fixtures =  :rights,
                            :roles,
                            :users

  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses its own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  #
  # For more information take a look at Spec::Runner::Configuration and Spec::Runner
end

def login_badly
  setup_user_bad
end

def login_well
  setup_user_normal
end

def login_admin
  setup_user_admin
end

def mock_request
  request=mock('request') unless request
  request.stub!(:env_table).and_return({'HTTP_HOST'=>'http://localhost'})
  request.stub!(:remote_host).and_return({'HTTP_HOST'=>'http://localhost'})
end

def setups
  ActionView::Base.stub!(:spec_mocks_mock_path).and_return('/')
  @i=1
  @s='test'
  @b=nil
  @f=0.0
  @a=[]
  @t=Time.now

  mock_request
  @mock_errors=mock('errors')
  @mock_errors.stub!(:count).and_return(0)
  @mock_errors.stub!(:[]).and_return('')

  @right=mock('right', :to_param=>'1')
  @role=mock('role', :to_param=>'1')
  @user=mock('user', :to_param=>'1')

  [
    [@right,Right],
    [@role,Role],
    [@user,User]
  ].each do |o,c|
    c.stub!(:find).and_return(o)
    c.stub!(:find).with(1).and_return(o)
    c.stub!(:find).with(:all).and_return(o)
    c.stub!(:save).and_return(o)
    o.stub!(:class).and_return(c)
    o.stub!(:empty?).and_return(false)
    o.stub!(:errors).and_return(@mock_errors)
    o.stub!(:new_record?).and_return(false)
    o.stub!(:sort_by).and_return(o)
    o.stub!(:destroy).and_return(o)
    o.stub!(:size).and_return(@i)
    o.stub!(:save).and_return(o)
    o.stub!(:update_attributes).and_return(o)
    o.stub!(:created_at).and_return(@t)
    o.stub!(:updated_at).and_return(@t)
    o.stub!(:id).and_return(@i)
    o.stub!(:title).and_return(@s)
    o.stub!(:long_title).and_return(@s)
    o.stub!(:paginate).and_return([o])
    o.stub!(:map).and_return([o])
    o.stub!((o.class.to_s.downcase+'_id').to_sym).and_return(@i)
    o.stub!(:parent_id).and_return(@i)
    o.stub!(:ancestors).and_return([])
    o.stub!(:children).and_return([])
    o.stub!(:descendants).and_return([])
    o.stub!(:self_and_descendants).and_return([])
    o.stub!(:position).and_return(@i)

    #Activerecord Associations
    o.stub!(:right_id).and_return(@i)
    o.stub!(:role_id).and_return(@i)
    o.stub!(:user_id).and_return(@i)

    o.stub!(:right).and_return(@right)
    o.stub!(:role).and_return(@role)
    o.stub!(:user).and_return(@user)

    o.stub!(:rights).and_return([@right])
    o.stub!(:roles).and_return([@role])
    o.stub!(:users).and_return([@user])
  end


  %w{
      right
      role
      user
    }.each do |c|
      self.send('setup_'+c)
  end

end

def setup_x
  unless @x
    setups
  end
  o=@x
  c=X

  #generic functions
  #o.stub!(:users).and_return([@user])

  #From the database

  #ActiveRecord Associations

  #Class Methods

  #Instance Methods

end

def setup_asset
  unless @asset
    setups
  end
  o=@asset
  c=Asset

  #Generic
  o.stub!(:content_type).and_return(@s)
  o.stub!(:filename).and_return(@s)
  o.stub!(:full_filename).and_return(@s)
  o.stub!(:authenticated_s3_url).and_return(@s)
  o.stub!(:size).and_return(@i)
  o.stub!(:thumbnail).and_return(@s)
  o.stub!(:width).and_return(@i)
  o.stub!(:height).and_return(@i)
  o.stub!(:is_image?).and_return(@i)
  o.stub!(:is_video?).and_return(@i)

  #From the database

  #ActiveRecord Associations
  #
  #Class Methods

  #Instance Methods

end

def setup_right
  unless @right
    setups
  end
  o=@right
  c=Right

  #generic functions
  o.stub!(:action).and_return(@s)
  o.stub!(:admin).and_return(nil)
  o.stub!(:controller).and_return(@s)
  o.stub!(:fundamental).and_return(nil)
  o.stub!(:god).and_return(nil)
  o.stub!(:roles).and_return([@role])

  #From the database

  #ActiveRecord Associations

  #Class Methods

  #Instance Methods

end

def setup_role
  unless @role
    setups
  end
  o=@role
  c=Role

  #generic functions
  o.stub!(:admin).and_return(nil)
  o.stub!(:god).and_return(nil)

  #From the database

  #ActiveRecord Associations

  #Class Methods

  #Instance Methods

end

def setup_user
  unless @user
    setups
  end
  o=@user
  c=User

  #generic functions
  o.stub!(:current_login).and_return(@t)
  o.stub!(:email).and_return(@s)
  o.stub!(:firstname).and_return(@s)
  o.stub!(:last_login).and_return(@t)
  o.stub!(:lastname).and_return(@s)
  o.stub!(:new_password).and_return(@s)
  o.stub!(:confirm_new_password).and_return(@s)
  o.stub!(:password_hash).and_return(@s)
  o.stub!(:password_salt).and_return(@s)
  o.stub!(:full_name).and_return(@s)
  o.stub!(:fullname).and_return(@s)
  o.stub!(:is_admin?).and_return(false)
  o.stub!(:is_authorized?).and_return(false)
  o.stub!(:is_terry?).and_return(false)
  o.stub!(:login!).and_return(@t)
  o.stub!(:refresh_password).and_return(@s)


  #From the database

  #ActiveRecord Associations

  #Class Methods

  #Instance Methods

end

def setup_user_admin
  session[:user]=1
  unless @user
    setups
  end
  User.stub!(:authenticate).and_return(@user)
  @user.stub!(:is_admin?).and_return(true)
  @loggeduser=@user
end

def setup_user_bad
  unless @user
    setups
  end
 @user.stub!(:is_authorized?).and_return(false)
end

def setup_user_normal
  session[:user]=1
  unless @user
    setups
  end
  @loggeduser=@user
end

  #From the database

  #ActiveRecord Associations

  #class methods

  #instance methods
