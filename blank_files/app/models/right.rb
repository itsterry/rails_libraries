class Right < ActiveRecord::Base

  include Terrys_validations

  has_and_belongs_to_many :roles

  validates_presence_of :controller, :action

  alias :right_id :id

  public

  private

  def validate
    validate_boolean('admin')
    validate_boolean('fundamental')
    validate_boolean('god')
  end

end
