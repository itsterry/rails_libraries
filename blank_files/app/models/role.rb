class Role < ActiveRecord::Base

  include Terrys_validations

  has_and_belongs_to_many :rights
  has_and_belongs_to_many :users

  validates_presence_of :title

  alias :role_id :id

  public

  private

  def validate
    validate_boolean('admin')
    validate_boolean('god')
  end

end
