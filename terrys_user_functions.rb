module Terrys_user_functions

  attr_accessor :new_password
  attr_accessor :confirm_new_password

  def full_name
    firstname+' '+lastname
  end

  def is_admin?
    if is_terry?
      return true
    end
    unless roles.empty?
      unless roles.select{|r| r.admin or r.god}.empty?
        return true
      end
    end
    false
  end

  def is_authorized?(controller,action)
    right=Right.find_by_controller_and_action(controller,action)
    if right and right.fundamental
      return true
    end
    #result=self.roles.detect{|role| role.rights.detect{|right| (right.action == action) && (right.controller == controller)}}
    if rights.include?(right)
      result=true
    else
      result=nil
    end
    if not result and is_admin?
      unless right
        right=Right.new(:controller=>controller, :action=>action)
        right.save
      end
      self.rights << right
      save
      result=true
    end
    result
  end

  def is_god?
    if is_terry?
      return true
    end
    unless roles.empty?
      unless roles.select{|r| r.god}.empty?
        return true
      end
    end
    false
  end

  def is_terry?
    if email and ['itsterry@gmail.com','terry@shuttleworths.net','terry@tttinternational.com'].include?(email)
      true
    else
      false
    end
  end

  def login!
    self.last_login=current_login||Time.now
    self.current_login=Time.now
  end

  def password=(pass=nil)
    set_password(pass)
  end

  def refresh_password(size = 8)
    chars = (('a'..'z').collect{|n| n} + ('0'..'9').collect{|n| n}) - %w(i o 0 1 l 0)
    password=(1..size).collect{|a| chars[rand(chars.size)] }.join
    set_password!(password)
    return password
  end

  def rights
    if roles.empty?
      []
    else
      roles.collect{|r| r.rights}.flatten.uniq
    end
  end

  def set_password(pass=nil)
    if pass.nil? or pass.blank? or pass.length<1
      return nil
    end
    pass=pass.downcase
    salt = [Array.new(6){rand(256).chr}.join].pack("m" ).chomp
    self.password_salt, self.password_hash =
      salt, Digest::SHA256.hexdigest(pass + salt)
    return true
  end

  def set_password!(pass=nil)
    set_password(pass)
    #self.last_password_reset=Time.now
    save
  end

  def title
    firstname+' '+lastname
  end

  def validate_new_password
    unless new_password.blank? and confirm_new_password.blank?
      if new_password==confirm_new_password
        self.password=new_password
      else
        errors.add_to_base('new password does not match confirmation')
        return false
      end
    end
  end

  def viewable_roles
    if roles.empty?
      []
    else
      roles.collect{|ro| ro.self_and_descendants}.flatten.uniq.sort_by{|ro| ro.title}
    end
  end


end