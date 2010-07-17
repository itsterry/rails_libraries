class User < ActiveRecord::Base

  include Terrys_user_functions
  include Terrys_validations


  has_and_belongs_to_many :roles

  validates_presence_of :firstname, :lastname, :email

  alias :user_id :id

  public

  def self.authenticate(email,password)
    user = User.find(:first, :conditions => ['email = ?' , email])
    password=password.downcase if password
    if user.blank? or password.blank?
      false
    elsif user and user.password_salt.blank?
      false
    elsif Digest::SHA256.hexdigest(password + user.password_salt) != user.password_hash
      false
    else
      user
    end
  end

  def self.terry
    User.find_by_email('itsterry@gmail.com')
  end


  private

  def validate
    validate_new_password
  end

end
