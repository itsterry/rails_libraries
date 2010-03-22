module Terrys_attachment_functions

  def is_asf?
    if content_type
      ct=content_type.split('/').last
      if ct=='asf' or ct=='x-ms-asf' or (ct='octet-stream' and filename.downcase.match(/.asf$/))
        return true
      end
    end
    false
  end

  def baseurl
    public_filename.to(public_filename.length-filename.length-2)
  end

  def extension
    unless filename.blank?
      result=filename.split('.')
      if result.size<2
        return nil
      else
        return result.last
      end
    end
    nil
  end

  def is_flv?
    if content_type
      ct=content_type.split('/').last
      if ct=='x-flv' or ct=='x-flash-video'
        return true
      end
    end
    false
  end

  def is_image?
    images=['jpg', 'jpeg', 'gif','tif','tiff','png','pjpeg', 'x-png', 'bmp']
    if images.include?(content_type.split('/').last)
      return true
    end
    false
  end

  def is_mp3?
    if content_type
      ct=content_type.split('/')
      if ct[0]=='audio'
        if ct[1]=='mpeg'
          return true
        end
      end
    end
    false
  end

  def is_mp4?
    if content_type
      ct=content_type.split('/').last
      if ct=='mp4'
        return true
      end
    end
    false
  end

  def is_mpeg?
    if content_type
      ct=content_type.split('/').last
      if ct=='mpg' or ct=='mpeg'
        return true
      end
    end
    false
  end

  def is_quicktime?
    if content_type
      ct=content_type.split('/').last
      if ct=='quicktime' or ct=='mov'
        return true
      end
    end
    false
  end

  def is_video?
    if is_flv? or is_mpeg? or is_quicktime? or is_wmv? or is_mp4?
      return true
    end
    nil
  end

  def is_wmv?
    if content_type
      if content_type.split('/').last=='x-ms-wmv'
        return true
      end
    end
    false
  end

  def source_uri=(uri)
    io = open(URI.parse(uri))
    (class << io; self; end;).class_eval do
      define_method(:original_filename) { base_uri.path.split('/').last }
    end
    self.uploaded_data = io
  end

end