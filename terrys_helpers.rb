module Terrys_helpers

  def admin_nav
      render :partial=>'layouts/admin_nav'
  end

  def body(admin=nil)
    if admin
      render :partial=>'layouts/body_for_admin'
    else
      render :partial=>'layouts/body'
    end
  end

  def boilerplate
    render :partial=>'layouts/boilerplate'
  end

  def button(text='Doh! You forgot to add text')
    '<button>'+text+'</button>'
  end

  def check_or_cross(v=nil)
    cross_or_check(v)
  end

  def check_or_blank(v=nil)
    if v==true or (v and v>0)
      image_tag('check.gif', :alt=>'Yes')
    else
      ''
    end
  end

  def comment_tag_selector(thing=nil)
    if thing and not thing.comment_tag_list.empty?
      @tag_object_id=thing.rails_id
      @tags=thing.comment_tag_list.sort
      @tag_controller=thing.class.to_s.downcase.pluralize
      @update=thing.class.to_s.downcase+'_table'
      render :partial=>'layouts/tag_selector'
    end
  end

  def cross_or_check(v=nil)
    if v
      image_tag('check.gif', :alt=>'Yes')
    else
      image_tag('cross.gif', :alt=>'No')
    end
  end

  # takes a number and options hash and outputs a string in any currency format
  def currencify(number, options={})
    if number
      # :currency_before => false puts the currency symbol after the number
      # default format: &pound;12,345,678.90
      options = {:currency_symbol => "&pound;", :delimiter => ",", :decimal_symbol => ".", :currency_before => true}.merge(options)

      # split integer and fractional parts
      int, frac = ("%.2f" % number).split('.')
      # insert the delimiters
      int.gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{options[:delimiter]}")

      if options[:currency_before]
        options[:currency_symbol] + int + options[:decimal_symbol] + frac
      else
        int + options[:decimal_symbol] + frac + options[:currency_symbol]
      end
    end
  end

  def cycle_rowcolors
    cycle('#ffffff','#dddddd')
  end

  def default_javascript
    if @default_javascript
      #javascript_include_tag(:defaults)+javascript_include_tag('control.tabs.2.1.1.js')
      #javascript_include_tag(:defaults)+calendar_date_select_includes+javascript_include_tag('control.tabs.2.1.1.js')
      javascript_include_tag(:defaults)+javascript_include_tag('calendar_date_select/calendar_date_select')+javascript_include_tag('control.tabs.2.1.1.js')
    end
  end

  def description
    @description||'Set Description'
  end

  def editable_tag_list(subject,specs={})
    specs={:spinner=>'tag_editor', :url=>{:controller=>'home',:action=>nil, :id=>nil}}.merge(specs)
    if subject
      if @loggeduser.is_authorized?(specs[:url][:controller],specs[:url][:action])
        tags=subject.tag_list.uniq.sort
        t='<form action="post", method="home">'
        t+='Tags:'
        t+=token_tag
        t+=hidden_field_tag 'comment_id', subject.rails_id
        t+=text_area_tag 'tag_list', tags, :rows=>1, :style=>'width: 80%'
        t+=submit_to_remote 'tag_list_submit_'+subject.rails_id.to_s, 'update', :url=>specs[:url], :update=>specs[:update], :before => "Element.show('spinner_"+specs[:spinner]+"')", :success => "Element.hide('spinner_"+specs[:spinner]+"')"
        t+=spinner(specs[:spinner])
        t+='</form>'
        t
      else
        if subject.tag_list.empty?
          'No tags for this '+subject.class.to_s
        else
          'Tags: '+subject.tag_list.uniq.sort.join(', ')
        end
      end
    end
  end

  def flash_show
    if flash[:error]
      render :partial=>'layouts/flash_error'
    elsif flash[:warning]
      render :partial=>'layouts/flash_warning'
    elsif flash[:notice]
      render :partial=>'layouts/flash_notice'
    end
  end

  def form_row(a=[],rowoptions={:bgcolor=>cycle_rowcolors})
    @rowoptions=rowoptions
    if a.empty?
      a=['&nbsp;']
    else
      a.each_with_index do |element,index|
        if element.blank?
          a[index]='&nbsp;'
        end
      end
    end
    return render(:partial=>'layouts/form_row', :collection=>[a])
  end

  def function_toggler(subject,action,specs={})
    specs.symbolize_keys!
    if subject and action
      span_id=subject.class.to_s.downcase+'_'+subject.rails_id.to_s
      specs={ :on_text=>'on',
              :off_text=>'off',
              :update=>span_id}.merge(specs)
    end
    '<span id="'+specs[:update]+'">'+function_toggler_guts(subject,action,specs)+'</span>'
  end

  def function_toggler_guts(subject,action,specs={})
    specs.symbolize_keys!
    specs={ :on_text=>'on',
            :off_text=>'off'}.merge(specs)
    image=on_off_image(subject,action,specs)
    link_to_remote(image,:update=>specs[:update],:url=>{:controller=>subject.class.to_s.downcase.pluralize,:action=>'toggle_function',:id=>subject,:class=>subject.class.to_s,:function=>action, :specs=>specs})
  end

  def generic_link(asset,thumbnail,specs={})
    link_to generic_show(asset,thumbnail,specs), asset.public_filename
  end

  def generic_show(asset,thumbnail,specs={})
    if asset
      if asset.is_image?
        image_tag(asset.public_filename(thumbnail),specs)
      elsif asset.is_video?
        image_tag('video_icon.gif', specs)
      end
    else
      if specs[:alt]
        specs[:alt]
      else
        asset.full_filename
      end
    end
  end

  #shows a block of coloured text based on value of given attribute
  #assumes that good is >0 and bad is <0
  #:invert=>true inverts the assumption
  def good_or_bad(v=nil,specs={})
    specs={ :good_text=>'GOOD',
          :bad_text=>'BAD',
          :good_color=>'#ffffff',
          :good_background=>'#00ff00',
          :bad_color=>'#ffffff',
          :bad_background=>'#ff0000',
          :zero_good=>nil,
          :zero_bad=>nil,
          :nil_good=>nil,
          :nil_bad=>nil,
          :invert=>nil
        }.merge(specs)
    if v
      if specs[:invert]
        v=v*-1
      end
      if v>0
        background=specs[:good_background]
        color=specs[:good_color]
        text=specs[:good_text]
      elsif v<0
        background=specs[:bad_background]
        color=specs[:bad_color]
        text=specs[:bad_text]
      elsif specs[:zero_good]
        background=specs[:good_background]
        color=specs[:good_color]
        text=specs[:good_text]
      elsif specs[:zero_bad]
        background=specs[:bad_background]
        color=specs[:bad_color]
        text=specs[:bad_text]
      else
        return
      end
      '<span style="background: '+background+'; color: '+color+'; padding: 2px; font-weight: 600;">'+text+'</span>'
    else
      if specs[:nil_good]
        background=specs[:good_background]
        color=specs[:good_color]
        text=specs[:good_text]
        return '<span style="background: '+background+'; color: '+color+'; padding: 2px; font-weight: 600;">'+text+'</span>'
      elsif specs[:nil_bad]
        background=specs[:bad_background]
        color=specs[:bad_color]
        text=specs[:bad_text]
        return '<span style="background: '+background+'; color: '+color+'; padding: 2px; font-weight: 600;">'+text+'</span>'
      end
    end
  end

  def head_show
    render :partial=>'layouts/head'
  end

  def job_finder
    if @loggeduser.is_client?
      @jobs=@loggeduser.client_jobs.paginate(:order=>'title', :limit=>20, :per_page => 20, :page=>params[:page])
    else
      @jobs=Job.find(:all,:limit=>0).paginate(:order=>'title', :limit=>20, :per_page => 20, :page=>params[:page])
    end
    render :partial=>'jobs/finder'
  end

  def job_results
    if @loggeduser.is_client?
      render :partial=>'jobs/clientproperty', :collection=>@properties
    else
      render :partial=>'jobs/property', :collection=>@properties
    end
  end

  def job_scheduled_status(job=nil)
    if job
      if job.scheduled?
        nicedate(job.start_time)
      else
        'NOT SCHEDULED'
      end
    else
      ''
    end
  end

  def keywords
    @keywords||'Set Keywords'
  end

  #decides if the user sees an admin nav or a client nav
  def main_nav
    if @loggeduser
      render :partial=>'layouts/main_nav'
    end
  end

  def nav
    if @loggeduser
      render :partial=>'layouts/nav'
    end
  end

  def nicedateandtime(t,separator=' - ')
    nicedate(t)+separator+nicetime(t)
  end

  def nicestate_pickup(p)
    if p
      case(p.state)
      when 'scheduled'
        'Scheduled'
      when 'scheduled_on_trip'
        'Scheduled'
      when 'no_access'
        'No Access'
      when 'postponed'
        'Postponed'
      when 'late'
        'LATE'
      when 'refused'
        'REFUSED'
      when 'cancelled'
        'Cancelled'
      when 'complete'
        'Complete'
      end
    end
  end

  def nicetime(t=nil)
    if t
      t.strftime('%H:%M:%S')
    end
  end

  def on_off_image(subject,action,specs={})
    specs.symbolize_keys!
    specs={ :on_text=>'on',
            :off_text=>'off'}.merge(specs)
    if subject.send(action)
      if specs[:on_image]
        image=image_tag(specs[:on_image], :alt=>specs[:on_text])
      else
        image=specs[:on_text]
      end
    else
      if specs[:off_image]
        image=image_tag(specs[:off_image], :alt=>specs[:off_text])
      else
        image=specs[:off_text]
      end
    end
    image
  end

  def pencil(alt='edit')
    image_tag 'pencil.gif', :alt=>alt
  end

  def ready_for_work
    @ready_for_work=User.workers.select{|u| u.ready_for_work?}
    render :partial=>'users/ready_for_work'
  end

  def refresh_bar(specs={})
    specs={:spinner=>'refresh'}.merge(specs)
    t='<div class="refresh">'
    t+=link_to_remote 'Refresh', :url=>specs[:url], :update=>specs[:update], :before => "Element.show('spinner_"+specs[:spinner]+"')", :success => "Element.hide('spinner_"+specs[:spinner]+"')"
    t+=spinner(specs[:spinner])
    t+='</div>'
  end

  def site_title
    @site_title||'Set Site Title in Application Controller'
  end

  def spinner(id='no_id')
    image_tag("spinner.gif", :alt=>'spinner here', :align => 'absmiddle', :border=> 0, :id => "spinner_"+id, :style=>"display: none;" )
  end

  def time_select_from_commercial_weeks(specs={})
    if specs[:finish]
      iv=specs[:initial_value]||Time.end_of_this_commercial_week
    else
      iv=specs[:initial_value].start_of_the_commercial_week||Time.start_of_this_commercial_week
    end
    name=specs[:name]
    id=specs[:id]
    unless name
      return
    end
    lower_limit=specs[:lower_limit]||20
    upper_limit=specs[:upper_limit]||20
    times=[iv]
    count=iv
    lower_limit.times do
      count-=7.days
      times<<count
    end
    count=iv
    upper_limit.times do
      count+=7.days
      times<<count
    end
    times.sort!
    select_tag name, options_for_select(times.collect{|t| ['Week '+(t.to_date.cweek).to_s+' '+t.year.to_s+' ('+nicedate(t)+')',t]}, iv), :id=>id
  end

  def tiny_mce
    if @tiny_mce
      render :partial=>'layouts/tiny_mce'
    end
  end

  def title_show(title='You forgot to set a title')
    if @title
      title=@title
    elsif @loggeduser and @loggeduser.circuit
      title=@loggeduser.circuit.title
    end
    if RAILS_ENV!='production'
      title+=' ['+RAILS_ENV+']'
    end
    title
  end

  def top
    render :partial=>'layouts/top'
  end

  def trashcan
    image_tag('trash.gif',:alt=>'Delete')
  end

  def user_photo_50(user)
    if user.photo
      image_tag(user.photo.public_filename(:thumb50),:alt=>'Photo of '+user.full_name)
    else
      image_tag('anonymous_user_50.jpg', :alt=>'no photo')
    end
  end

  def user_photo_100(user)
    if user.photo
      image_tag(user.photo.public_filename(:thumb100),:alt=>'Photo of '+user.full_name)
    else
      image_tag('anonymous_user_100.jpg', :alt=>'no photo')
    end
  end

  def vehicle_photo_50(vehicle)
    if vehicle.photo
      image_tag(vehicle.photo.public_filename(:thumb50),:alt=>'Photo of '+vehicle.registration)
    else
      image_tag('anonymous_vehicle_50.gif', :alt=>'no photo')
    end
  end

  def vehicle_photo_100(vehicle)
    if vehicle.photo
      image_tag(vehicle.photo.public_filename(:thumb100),:alt=>'Photo of '+vehicle.registration)
    else
      image_tag('anonymous_vehicle_100.gif', :alt=>'no photo')
    end
  end

  def check_box_table(subject,potentials,variabletoshow, params={})
    unless (subject.nil? || potentials.nil? || potentials.empty?)
      contentarray=[]
      potentials.each do |p|
        itemarray=[]
        pv=p.class.to_s.gsub(/^([A-Z].*)([A-Z])/,'\1_\2').gsub(/^_/,'').downcase
        itemarray << check_box_tag(subject.class.to_s.downcase+"["+pv+"_ids][]",p.id,subject.send(pv.pluralize).include?(p))
        itemarray << p.send(variabletoshow)+"\n"
        contentarray << itemarray
      end
      return print_in_table_columns(:content=>contentarray, :cols=>params[:cols], :bunches=>params[:bunches], :cell=>params[:cell])
    end
  end

  def nicedate(dateortime, time=nil)
    if dateortime
      if time
        return dateortime.strftime("%b %d, %Y - %H:%M:%S")
      else
        return dateortime.strftime("%b %d, %Y")
      end
    end
  end

  def nl2br(s)
    s.gsub(/\n/,'<br/>')
  end

  def pad_with_leading_zeros(string, length)
    if string.size< length
      (length-string.size).times do
        string="0"+string
      end
    end
    return string
  end

  def print_in_table_columns(specs)
    content = specs[:content]||0
    cols    = specs[:cols]||0
    bunches = specs[:bunches]||0
    tableoptions  = specs[:table]
    rowoptions    = specs[:row]
    celloptions   = specs[:cell]

    colcount=0
    bunchcount=0
    contentcount=0

    if content.nil? || content.empty?
      return nil
    end

    table_tag="<table"
    if tableoptions
      tableoptions.each do |key,value|
        table_tag+=' '+key.to_s+'="'+value.to_s+'"'
      end
    end
    table_tag+=">"

    row_tag="<tr"
    if rowoptions
      rowoptions.each do |key,value|
        row_tag+=' '+key.to_s+'="'+value.to_s+'"'
      end
    end
    row_tag+=">"

    cell_tag="<td"
    if celloptions
      celloptions.each do |key,value|
        cell_tag+=' '+key.to_s+'="'+value.to_s+'"'
      end
    end
    cell_tag+=">"

    if cols>0
      itemspercol=content.size/cols
    end

    tablecount=0

    output=""
    output+=table_tag
    tablecount+=1

    if bunches>0 && cols>1
      output+=row_tag
      output+=cell_tag
      output+=table_tag
      tablecount+=1
    end
    content.each do |c|

      output+=row_tag
      c.each do |item|
        output+=cell_tag
        output+=item
        output+="</td>"
      end
      output+="</tr>"

      contentcount+=1
      bunchcount+=1

      if bunches>0 && cols<2 && bunchcount==bunches
        output+=row_tag
        output+=cell_tag
        output+="&nbsp;"
        output+="</td>"
        output+="</tr>"
        bunchcount=0
      elsif bunches>0 && cols>1 && bunchcount==bunches
        output+="</table>"
        tablecount-=1

        output+="</td>"
        bunchcount=0
        colcount+=1
        if colcount==cols
          output+="</tr>"
          output+=row_tag
          output+="<td colspan="+cols.to_s+">"
          output+="&nbsp;"
          output+="</td>"
          output+="</tr>"
          output+=row_tag
          colcount=0
        end
        output+=cell_tag
        output+=table_tag
        tablecount+=1
      end

    end
    output+="</table>"
    tablecount-=1
    if tablecount>0
      output+="</td>"
      output+="</tr>"
      output+="</table>"
    end
    output
  end

end