module Terrys_tests

  def bounce_unauthenticated_to_signin(m,a)
    describe 'for unauthenticated users' do
      describe m+' '+a do
        it 'should warn and bounce to signin' do
          self.send(m,a)
          response.should redirect_to(signin_path)
        end
      end
    end
  end

  def bounce_non_admin_to_home(m,a)
    describe 'for authenticated non-admin users' do
      describe m+' '+a do
        it 'should warn and bounce to home' do
          login_well
          self.send(m,a)
          response.should redirect_to(home_path)
        end
      end
    end
  end



  def has_class_id(thing)
    it 'should have a '+thing.to_s.downcase+'_id' do
      @thing.respond_to?(thing.to_s.downcase+'_id').should be_true
    end
  end

  def first_one_gets_to_be_boolean(thing)
    it 'if it is the first created, it should have boolean '+thing do
      @thing.class.find(:all).each{|l| l.delete}
      o=@thing.class.new(@valid_attributes)
      o.save.should be_true
      o.send(thing).should==1
    end
  end

  def last_one_must_survive
    it 'should not be destroyable if it is the last of its kind' do
      @thing.class.find(:all).each{|l| l.delete}
      @thing.class.find(:first).should be_nil
      o=@thing.class.new(@valid_attributes)
      o.save.should be_true
      o.destroy
      @thing.class.find(:first).should_not be_nil
    end
  end

  def mandatory_collection(thing)
    it 'should have '+thing do
      o=@thing
      f=thing
      o.respond_to?(f).should be_true
      o.send(f).class.should==Array
    end
  end

  def mandatory_date(thing)
    it 'should always have a '+thing do
      o=@thing
      f=thing
      fp=f+'='
      o.respond_to?(f).should be_true
      o.send(fp,nil)
      o.should_not be_valid
    end
  end

  def mandatory_float(thing)
    it 'should always have a '+thing do
      o=@thing
      f=thing
      fp=f+'='
      o.respond_to?(f).should be_true
      o.send(fp,nil)
      o.should_not be_valid
    end
  end

  def mandatory_float_or_default(thing,default)
    it 'should have a '+thing+' defaulting to '+default.to_s do
      o=@thing
      f=thing
      fp=f+'='
      o.respond_to?(f).should be_true
      o.send(fp,nil)
      o.save.should be_true
      o.send(f).should==default
    end
  end

  def mandatory_integer(thing)
    it 'should always have a '+thing do
      o=@thing
      f=thing
      fp=f+'='
      o.respond_to?(f).should be_true
      o.send(fp,nil)
      o.should_not be_valid
    end
  end

  def mandatory_integer_or_default(thing,default)
    it 'should have a '+thing+' defaulting to '+default.to_s do
      o=@thing
      f=thing
      fp=f+'='
      o.respond_to?(f).should be_true
      o.send(fp,nil)
      o.save.should be_true
      o.send(f).should==default
    end
  end

  def mandatory_float_or_zero(thing,default)
      it 'should have a '+thing+', defaulting to 0.0' do
        o=@thing
        f=thing
        fp=f+'='
        t=1.0
        o.respond_to?(f).should be_true
        o.send(fp,t)
        o.save
        o.send(f).should==t
        o.send(fp,nil)
        o.save
        o.send(f).should==0.0
      end
  end

  def mandatory_polymorphic(thing)
    it 'should have a valid '+thing do
      pending
    end
  end

  def mandatory_string(thing)
    it 'should always have a '+thing do
      o=@thing
      f=thing
      fp=f+'='
      o.respond_to?(f).should be_true
      o.send(fp,'')
      o.should_not be_valid
    end
  end

  def mandatory_thing(thing,klass=nil)
    it 'should always have a '+thing.to_s.downcase.to_s do
      o=@thing
      f=thing.to_s.downcase.to_s
      fid=f+'_id'
      fidp=fid+'='
      o.respond_to?(f).should be_true
      if klass
        o.send(f).class.should==klass
      else
        o.send(f).class.should==thing
      end
      o.send(fidp,1)
      o.should be_valid
      o.send(fidp,nil)
      o.should_not be_valid
      o.send(fidp,1)
      o.should be_valid
      o.send(fidp,999999)
      o.should_not be_valid
    end
  end

  def mandatory_valid_thing_id(thing)
    valid_thing_id(thing)
  end

  def optional_boolean(thing)
    it 'should be '+thing+' or not' do
      o=@thing
      f=thing
      fp=f+'='
      t=1
      o.respond_to?(f).should be_true
      o.send(fp,t)
      o.save
      o.send(f).should==t
      o.send(fp,0)
      o.save
      o.send(f).should be_nil
      o.send(fp,999999)
      o.save
      o.send(f).should==t
    end
  end

  def optional_date(thing)
    it 'should have a '+thing+' or not' do
      o=@thing
      f=thing
      fp=f+'='
      t=Date.today
      o.respond_to?(f).should be_true
      o.send(fp,t)
      o.save
      o.send(f).should==t
      o.send(fp,nil)
      o.save
      o.send(f).should be_nil
    end
  end

  def optional_time(thing)
    it 'should have a '+thing+' or not' do
      o=@thing
      f=thing
      fp=f+'='
      t=Time.now
      o.respond_to?(f).should be_true
      o.send(fp,t)
      o.save
      o.send(f).should==t
      o.send(fp,nil)
      o.save
      o.send(f).should be_nil
    end
  end

  def optional_float(thing)
    it 'should have a '+thing+' or not' do
      o=@thing
      f=thing
      fp=f+'='
      t=1.0
      o.respond_to?(f).should be_true
      o.send(fp,t)
      o.save
      o.send(f).should==t
      o.send(fp,nil)
      o.save
      o.send(f).should be_nil
    end
  end

  def optional_integer(thing)
    it 'should have a '+thing+' or not' do
      o=@thing
      f=thing
      fp=f+'='
      t=1
      o.respond_to?(f).should be_true
      o.send(fp,t)
      o.save
      o.send(f).should==t
      o.send(fp,nil)
      o.save
      o.send(f).should be_nil
    end
  end

  def optional_string(thing)
    it 'should have a '+thing+' or not' do
      o=@thing
      f=thing
      fp=f+'='
      t='test'
      o.respond_to?(f).should be_true
      o.send(fp,t)
      o.save
      o.send(f).should==t
      o.send(fp,'')
      o.save
      o.send(f).should be_nil
    end
  end

  def optional_thing(thing,klass)
    o=@thing
    f=thing
    setter=f+'_id'
    t=1
    o.respond_to?(f).should be_true
    o.send(f).should be_nil
    o.send(setter,t)
    o.send(f).class.should==klass
  end

  def optional_valid_thing_id(thing)
    it 'should have a valid '+thing+' or not' do
        o=@thing
        f=thing
        fp=f+'='
        t=1
        o.respond_to?(f).should be_true
        o.send(fp,t)
        o.save
        o.send(f).should==t
        o.send(fp,0)
        o.save
        o.send(f).should be_nil
        o.send(fp,t)
        o.save
        o.send(f).should==t
        o.send(fp,999999)
        o.save
        o.send(f).should be_nil
      end
  end

  def unique_boolean(thing, scope_thing=nil)
    str='should have a unique '+thing
    if scope_thing
      str+=' for its scope_thing'
    end
    it str do
      o=@thing
      f=thing
      fp=f+'='
      scope_thing=scope_thing
      o.send(fp,1)
      o.save
      o.send(f).should==1
      t=o.send(f)
      c=o.clone
      c.send(f).should==t
      c.title='test2'
      c.save.should be_true
      c.send(f).should==1
      o.reload
      o.send(f).should be_nil
    end
  end
  
  def unique_string(thing)
    it 'should have a unique '+thing do
      o=@thing
      f=thing
      fp=f+'='
      o.send(f).should_not be_nil
      t=o.send(f)
      c=o.clone
      c.send(f).should==t
      c.should_not be_valid
      c.send(fp,t+t)
      c.should be_valid
    end
  end

  def acts_as_generic_list
    adds_self_to_list
  end

  def adds_self_to_list
    it 'should add itself to a list correctly' do
      o=@thing
      f='position'
      fp=f+'='
      o.respond_to?(f).should be_true
      o.send(f).should_not be_nil
      o.send(fp,nil)
      o.save
      o.send(f).should_not be_nil
    end

  end

  def has_terrys_user_functions

    has_class_id(User)
    mandatory_string('firstname')
    mandatory_string('lastname')
    mandatory_string('email')
    optional_time('current_login')
    optional_time('last_login')
    mandatory_collection('roles')
    mandatory_collection('rights')

    it 'should authenticate in a case-INsensitive fashion' do
      o=@thing
      o.email='test@test.com'
      o.password='test'
      o.save.should be_true
      User.authenticate('test@test.com','').should be_false
      User.authenticate('test@test.com','test').should==o
      User.authenticate('test@test.com','TEST').should==o
      User.authenticate('test@TEST.com','test').should==o
    end

    it 'should know which user is terry' do
      o=@thing
      User.respond_to?('terry').should be_true
      User.terry.should be_nil
      o.email='itsterry@gmail.com'
      o.save
      User.terry.should==o
    end

    it 'should know its full_name' do
      o=@thing
      f='full_name'
      o.respond_to?(f).should be_true
      o.firstname='test'
      o.lastname='again'
      o.send(f).should=='test again'
    end

    it 'should know if it is an admin' do
      o=@thing
      f='is_admin?'
      o.respond_to?(f).should be_true
      o.roles=[]
      o.save
      o.roles.should be_empty
      o.send(f).should be_false
      ro=Role.new(:title=>'test admin',:admin=>1)
      ro.save.should be_true
      o.roles<<ro
      o.save
      o.send(f).should be_true
    end

    it 'should know if it is a god' do
      o=@thing
      f='is_god?'
      o.respond_to?(f).should be_true
      o.roles=[]
      o.save
      o.roles.should be_empty
      o.send(f).should be_false
      ro=Role.new(:title=>'test god',:god=>1)
      ro.save.should be_true
      o.roles<<ro
      o.save
      o.send(f).should be_true
    end

    it 'should know if it is authorized for a controller and an action' do
     o=@thing
      f='is_authorized?'
      c='testcontroller'
      a='testaction'
      o.respond_to?(f).should be_true
      o.roles=[]
      o.save
      o.roles.should be_empty
      o.is_authorized?(c,a).should be_false
      ro=Role.new(:title=>'test')
      ro.save.should be_true
      o.roles<<ro
      o.save
      o.is_authorized?(c,a).should be_false
      ri=Right.new(:controller=>c,:action=>a)
      ri.save.should be_true
      o.is_authorized?(c,a).should be_false
      ro.rights<<ri
      ro.save
      o.is_authorized?(c,a).should be_true
     end

    it 'should know if it is terry' do
      o=@thing
      f='is_terry?'
      o.email='test@test.com'
      o.send(f).should be_false
      o.email='itsterry@gmail.com'
      o.send(f).should be_true
      o.email='test@test.com'
      o.send(f).should be_false
      o.email='terry@tttinternational.com'
      o.send(f).should be_true
      o.email='test@test.com'
      o.send(f).should be_false
      o.email='terry@shuttleworths.net'
      o.send(f).should be_true
    end

    it 'should login nicely' do
      pending
    end

    it 'should refresh its password' do
      o=@thing
      o.email='test@test.com'
      o.set_password('test')
      o.save
      User.authenticate('test@test.com','test').should==o
      o.refresh_password
      o.save
      User.authenticate('test@test.com','test').should be_false
    end

    it 'should set its password' do
      o=@thing
      f='password='
      o.respond_to?(f).should be_true
      o.email='test@test.com'
      o.set_password('test')
      o.save
      User.authenticate('test@test.com','test').should==o
      o.password='testagain'
      o.save
      User.authenticate('test@test.com','test').should be_false
      User.authenticate('test@test.com','testagain').should==o
    end

    it 'should have viewable roles' do
      pending
    end

    it 'should respond to a new_password' do
      o=@thing
      f='new_password'
      o.respond_to?(f).should be_true
    end

    it 'should respond to a confirm_new_password' do
      o=@thing
      f='confirm_new_password'
      o.respond_to?(f).should be_true
    end

    it 'should be invalid if given a new_password and confirm_new_password which do not match' do
      o=@thing
      o.new_password='a'
      o.confirm_new_password='b'
      o.should_not be_valid
    end

    it 'should set its new_password if given a new_password and confirm_new_password which match' do
      o=@thing
      User.authenticate(o.email,'a').should be_false
      o.new_password='a'
      o.confirm_new_password='a'
      o.save
      User.authenticate(o.email,'a').should==o
    end

    it 'should ignore a blank new_password with a blank new_password confirm' do
      o=@thing
      o.new_password=nil
      o.confirm_new_password=''
      o.should be_valid
    end


  end

  def valid_integer(thing)
    it 'should always have a valid '+thing do
      o=@thing
      f=thing
      fp=f+'='
      t=1
      o.respond_to?(f).should be_true
      o.send(fp,t)
      o.should be_valid
      o.send(fp,0)
      o.should_not be_valid
      o.send(fp,t)
      o.should be_valid
      o.send(fp,999999)
      o.should_not be_valid
    end
  end

  def valid_thing_id(thing)
    valid_integer(thing)
  end

  def optional_thing(thing,klass=nil)
    if thing and not klass
      klass=thing
      thing=thing.to_s.downcase
    end
    it 'should have a valid '+thing+' or not' do
      o=@thing
      f=thing
      setter=f+'_id='
      t=1
      o.respond_to?(f).should be_true
      o.send(setter,0)
      o.save
      o.send(f).should be_nil
      o.send(setter,t)
      o.save
      o.send(f).class.should==klass
    end
  end

  def optional_valid_thing_id(thing)
    it 'should have a valid '+thing+'_id or not' do
        o=@thing
        f=thing
        fp=f+'='
        t=1
        o.respond_to?(f).should be_true
        o.send(fp,t)
        o.save
        o.send(f).should==t
        o.send(fp,0)
        o.save
        o.send(f).should be_nil
        o.send(fp,t)
        o.save
        o.send(f).should==t
        o.send(fp,999999)
        o.save
        o.send(f).should be_nil
      end
  end

  def adds_self_to_list
    it 'should add itself to a list correctly' do
      o=@thing
      f='position'
      fp=f+'='
      o.respond_to?(f).should be_true
      o.send(f).should_not be_nil
      o.send(fp,nil)
      o.save
      o.send(f).should_not be_nil
    end

  end

  def has_terrys_attachment_functions

    it 'should know if it is an asf' do
      o=@thing
      f='is_asf?'
      o.respond_to?(f).should be_true
      o.send(f).should be_false
      o.content_type='asf'
      o.send(f).should be_true
      o.content_type='xxx'
      o.send(f).should be_false
      o.content_type='x-ms-asf'
      o.send(f).should be_true
      o.content_type='xxx'
      o.send(f).should be_false
      o.content_type='octet-stream'
      o.filename='xxx.asf'
      o.send(f).should be_true
    end

    it 'should know if it is an flv' do
      o=@thing
      f='is_flv?'
      o.respond_to?(f).should be_true
      o.send(f).should be_false
      o.content_type='x-flv'
      o.send(f).should be_true
      o.content_type='xxx'
      o.send(f).should be_false
      o.content_type='x-flash-video'
    end

    it 'should know if it is an image' do
      o=@thing
      f='is_image?'
      o.respond_to?(f).should be_true
      o.send(f).should be_false
      o.content_type='jpg'
      o.send(f).should be_true
      o.content_type='xxx'
      o.send(f).should be_false
      o.content_type='jpeg'
      o.send(f).should be_true
      o.content_type='xxx'
      o.send(f).should be_false
      o.content_type='gif'
      o.send(f).should be_true
      o.content_type='xxx'
      o.send(f).should be_false
      o.content_type='tif'
      o.send(f).should be_true
      o.content_type='xxx'
      o.send(f).should be_false
      o.content_type='tiff'
      o.send(f).should be_true
      o.content_type='xxx'
      o.send(f).should be_false
      o.content_type='png'
      o.send(f).should be_true
      o.content_type='xxx'
      o.send(f).should be_false
      o.content_type='pjpeg'
      o.send(f).should be_true
      o.content_type='xxx'
      o.send(f).should be_false
      o.content_type='png'
      o.send(f).should be_true
      o.content_type='xxx'
      o.send(f).should be_false
      o.content_type='bmp'
      o.send(f).should be_true
      o.content_type='xxx'
      o.send(f).should be_false
    end

    it 'should know if it is an mp3' do
      o=@thing
      f='is_mp3?'
      o.respond_to?(f).should be_true
      o.send(f).should be_false
      o.content_type='audio/mpeg'
      o.send(f).should be_true
    end

    it 'should know if it is an mp4' do
      o=@thing
      f='is_mp4?'
      o.respond_to?(f).should be_true
      o.send(f).should be_false
      o.content_type='whatever/mp4'
      o.send(f).should be_true
    end

    it 'should know if it is an mpeg' do
      o=@thing
      f='is_mpeg?'
      o.respond_to?(f).should be_true
      o.send(f).should be_false
      o.content_type='whatever/mpg'
      o.send(f).should be_true
      o.content_type='whatever/xxx'
      o.send(f).should be_false
      o.content_type='whatever/mpeg'
      o.send(f).should be_true
    end

    it 'should know if it is an quicktime' do
      o=@thing
      f='is_quicktime?'
      o.respond_to?(f).should be_true
      o.send(f).should be_false
      o.content_type='whatever/quicktime'
      o.send(f).should be_true
      o.content_type='whatever/xxx'
      o.send(f).should be_false
      o.content_type='whatever/mov'
      o.send(f).should be_true
    end

    it 'should know if it is a video' do
      pending
    end

    it 'should know if it is a wmv' do
      o=@thing
      f='is_wmv?'
      o.respond_to?(f).should be_true
      o.send(f).should be_false
      o.content_type='whatever/x-ms-wmv'
      o.send(f).should be_true
    end

    it 'should know its baseurl' do
      pending
      o=@thing
      f='baseurl'
      o.respond_to?(f).should be_true
      o.filename='a/b/c/d/whatever.abc'
      o.send(f).should=='a/b/c/d/'
    end

    it 'should know its extension' do
      o=@thing
      f='extension'
      o.respond_to?(f).should be_true
      o.filename='whatever.abc'
      o.send(f).should=='abc'
    end

    it 'should know about source_uri' do
      o=@thing
      f='source_uri='
      o.respond_to?(f).should be_true
    end

  end

  def acts_as_a_tree
    it 'should know about parents' do
      o=@thing
      f='parent'
      o.respond_to?(f).should be_true
    end
    it 'should know about children' do
      o=@thing
      f='children'
      o.respond_to?(f).should be_true
      o.send(f).class.should==Array
    end
    it 'should know about descendants' do
      o=@thing
      f='descendants'
      o.respond_to?(f).should be_true
      o.send(f).class.should==Array
    end
    it 'should know about ancestors' do
      o=@thing
      f='ancestors'
      o.respond_to?(f).should be_true
      o.send(f).class.should==Array
    end
  end

  def acts_as_generic_asset
    has_class_id(Asset)
    mandatory_string('content_type')
    mandatory_string('filename')
    mandatory_integer('size')
    optional_integer('width')
    optional_integer('height')
    has_terrys_attachment_functions
  end

  def acts_as_generic_right
    has_class_id(Right)
    mandatory_string('controller')
    mandatory_string('action')
    optional_boolean('god')
    optional_boolean('admin')
    optional_boolean('fundamental')
    mandatory_collection('roles')
  end

  def acts_as_generic_role
    has_class_id(Role)
    mandatory_string('title')
    optional_boolean('god')
    optional_boolean('admin')
    mandatory_collection('rights')
    mandatory_collection('users')
  end
end