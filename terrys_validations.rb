module Terrys_validations

  private

  def validate_first_one_gets_to_have_boolean(f=nil)
    if f and self.respond_to?(f) and not self.class.find(:first)
      self.send(f+'=',1)
    end
  end

  def validate_last_one_must_survive
    if self.class.find(:all).size==1
      return false
    end
  end

  def validate_at_least_one_of(a=[])
    if a.empty?
      errors.add_to_base('You are missing something vital')
      return false
    else
      if a.reject{|aa| aa.nil?}.empty?
        errors.add_to_base('You are missing something vital')
        return false
      end
    end
  end

  def validate_boolean(f=nil)
    return if f.blank?
    if self.send(f) and self.send(f)>0
      self.send(f+'=',1)
    else
      self.send(f+'=',nil)
    end
  end

  def validate_date_or_nil(thing=nil)
    if thing
      if self.respond_to?(thing)
        unless self.send(thing) and self.send(thing).is_a?(Date)
          self.send(thing+'=',nil)
        end
      end
    end
  end

  def validate_date_not_in_future(d,message='Date cannot be in the future')
    if d and d>Date.today
      errors.add_to_base(message)
      return false
    end
  end
  
  def validate_start_date_not_after_finish_date(s,f,message='Start Date cannot be after Finish Date')
    if s and f and s>f
      errors.add_to_base(message)
      return false
    end
  end

  
  def validate_start_time_not_after_finish_time(s,f,message='Start Time cannot be after Finish Time')
    validate_start_date_not_after_finish_date(s,f,message)
  end
  def validate_email
    if email
      unless email.match(/[^ @]@.*/)
        self.email=nil
      end
    end
  end
  
  def validate_float(thing=nil)
    if thing
      if self.respond_to?(thing)
        unless self.send(thing) and self.send(thing).is_a?(Float)
          self.send(thing+'=',0.0)
        end
      end
    end
  end

  def validate_float_anything_but_zero(thing=nil)
    if self.send(thing) and self.send(thing).is_a?(Float) and self.send(thing)!=0.0
      true
    else
      errors.add_to_base(thing+' cannot be exactly zero')
      false
    end
  end

  def validate_float_or_default(thing=nil,d=nil)
    if thing
      if self.respond_to?(thing)
        unless self.send(thing) and self.send(thing).is_a?(Float)
          self.send(thing+'=',d)
        end
      end
    end
  end

  def validate_float_or_nil(thing=nil)
    if thing
      if self.respond_to?(thing)
        unless self.send(thing) and self.send(thing).is_a?(Float)
          self.send(thing+'=',nil)
        end
      end
    end
  end

  def validate_integer_or_default(f=nil,default=nil)
    return if f.blank?
    if self.send(f).nil?
      self.send(f+'=',default)
    end
  end

  def validate_integer_or_nil(f=nil,default=nil)
    validate_integer_or_default(f=nil,nil)
  end
  
  def validate_only_one_of(a=[])
    if a.empty?
      errors.add_to_base('You are missing something vital')
      return false
    else
      if a.select{|aa| aa.nil?}.empty?
        errors.add_to_base('You are missing something vital')
        return false
      elsif a.reject{|aa| aa.nil?}.size>1
        errors.add_to_base('You have too many of something')
        return false
      end
    end
  end

  def validate_position
    unless position
      self.position=1
      move_to_bottom
    end
  end

  def validate_positive_float_or_nil(thing=nil)
    if thing
      if self.respond_to?(thing)
        unless self.send(thing) and self.send(thing).is_a?(Float) and self.send(thing)>0.0
          self.send(thing+'=',nil)
        end
      end
    end
  end

  def validate_positive_integer(i)
    if self.send(i) and self.send(i)<0
      errors.add('cannot be less than zero')
      return false
    end
    true
  end
  
  def validate_positive_float_greater_than_zero(i,message="This number must be greated than zero")
    if self.send(i) and not self.send(i)>0
      errors.add_to_base(message)
      return false
    end
    true
  end

  def validate_positive_float_greater_than_zero_or_nil(i)
    if self.send(i) and self.send(i)<=0.0
      self.send(i+'=',nil)
    end
    true
  end

  def validate_positive_integer_greater_than_zero(i,message="There must be at least one of these")
    if self.send(i) and self.send(i)<1
      errors.add_to_base(message)
      return false
    end
    true
  end

  def validate_positive_integer_greater_than_zero_or_default(i,d=nil)
    return if i.blank?
    if self.respond_to?(i) and (not self.send(i).blank?) and self.send(i)>0
      return
    else
      self.send(i+"=",d)
    end
  end
  
  def validate_positive_integer_greater_than_zero_or_nil(i)
    unless validate_positive_integer_greater_than_zero(i)
      self.send(i+'=',nil)
    end
  end

  def validate_start_and_finish(s,f,d=nil)
    period=100.years
    if self.send(s)
      sv=self.send(s)
    else
      sv=nil
    end
    if self.send(f)
      fv=self.send(f)
    else
      fv=nil
    end
    if sv
      if fv
        if fv<sv
          self.send(f+'=',sv)
        end
      else
        if d
          if sv>Date.today
            self.send(f+'=',v+period)
          else
            self.send(f+'=',Date.today+period)
          end
        else
          if sv>Time.now
            self.send(f+'=',sv+period)
          else
            self.send(f+'=',Time.now+period)
          end
        end
      end
    else
      if fv
        if d
          if fv>Date.today
            self.send(s+'=',Date.today)
          else
            self.send(s+'=',fv)
          end
        else
          if fv>Time.now
            self.send(s+'=',Time.now)
          else
            self.send(s+'=',fv)
          end
        end
      else
        self.send(s+'=',Time.now)
        self.send(f+'=',Time.now+100.years)
      end
    end
  end

  def validate_string_or_default(f=nil,d=nil)
    return if f.blank?
    if self.respond_to?(f) and self.send(f).blank?
      self.send(f+'=',d)
    end
  end

  def validate_string_or_nil(f=nil)
    return if f.blank?
    if self.send(f) and self.send(f).blank?
      self.send(f+'=',nil)
    end
  end

  def validate_there_must_be_one(f=nil, scope_thing=nil)
    return if f.blank?
    unless self.send(f)
      conditions=['`'+f+'` is not null']
      if scope_thing and self.send(scope_thing)
        conditions[0]+=' and '+scope_thing+'=?'
        conditions<<self.send(scope_thing)
      end
      others=(self.class.find(:all,:conditions=>conditions))
      if others.empty?
        self.send(f+'=',1)
      end
    end
  end
  
  def validate_there_can_be_only_one(f=nil, scope_thing=nil)
    return if f.blank?
    if self.send(f)
      conditions=['`'+f+'` is not null']
      if scope_thing and self.send(scope_thing)
        conditions[0]+=' and '+scope_thing+'=?'
        conditions<<self.send(scope_thing)
      end
      others=(self.class.find(:all,:conditions=>conditions))-[self]
      unless others.empty?
        others.each do |o|
          o.send(f+'=',nil)
          o.save
        end
      end
    end
  end

  def validate_thing(thing_class,thing_name,thing_id,fatal=1)
    if self.respond_to?(thing_name)
      if self.send(thing_name)
        if thing_class.exists?(thing_id)
          return true
        else
          if fatal
            errors.add_to_base(thing_class.to_s+' '+thing_id.to_s+' cannot be found')
          else
            self.send(thing_name+'=',nil)
            return true
          end
        end
      else
        if fatal
          errors.add_to_base(thing_class.to_s+' cannot be blank')
        else
          return true
        end
      end
    else
      errors.add_to_base('No such method: '+thing_name)
    end
    return false
  end

  def validate_time_or_nil(thing=nil)
    if thing
      if self.respond_to?(thing)
        unless self.send(thing) and (self.send(thing).is_a?(Time) or self.send(thing).is_a?(DateTime))
          self.send(thing+'=',nil)
        end
      end
    end
  end

  def validate_timestamp(f=nil)
    return if f.blank?
    unless self.send(f) 
      self.send(f+'=',Time.now)
    end
  end
  
  def validate_uploaded_data(ud)
    unless self.send(ud).blank?
      a=Asset.new(:uploaded_data=>self.send(ud))
      if a.save
        self.send(ud+'=',nil)
        var_name=ud.gsub(/_uploaded_data/,'')
        self.send(var_name+'_id=',a.asset_id)
      end
    end
  end

  def validate_value_or_nil(f=nil)
    return if f.blank?
    if self.send(f) and self.send(f)<1
      self.send(f+'=',nil)
    end
  end

  def validate_value_within_permitted(i,low,high,inclusive=nil)
    unless self.respond_to?(i)
      errors.add_to_base('No such function: '+i.to_s)
      return false
    end
    unless self.send(i)
      errors.add_to_base(i+' cannot be nil')
      return false
    end
    if inclusive
      if self.send(i)>=low and self.send(i)<=high
        return true
      else
        errors.add_to_base('Value of '+i+' not between '+low.to_s+' and '+high.to_s+' inclusive')
        return false
      end
    else
      if self.send(i)>low and self.send(i)<high
        return true
      else
        errors.add_to_base('Value of '+i+' not between '+low.to_s+' and '+high.to_s+' NOT inclusive')
        return false
      end
    end
  end
end