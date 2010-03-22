module Terrys_acts_as_tree                                                                                                                                                                                                                                                                                                                                          

  #############################################################################
  #                                                                           #
  # Begin Terry's version of acts as tree v1.2.1                              #
  #                                                                           #
  # v1.2.1                                                                    #
  # v1.2.1 - Added order to Children                                          #
  # v1.2.1 - Added self_and_descendants                                          #
  #                                                                           #
  # v1.2                                                                      #
  # v1.2 - Added descendants                                                  #
  # v1.2 - Added parent=                                                      #
  #                                                                           #
  # Changelog began v1.2                                                      #
  #                                                                           #
  #############################################################################

  def ancestors(ancestorlist=[])
    unless self.parent.nil?
      ancestorlist << self.parent
      self.parent.ancestors(ancestorlist)
    end
    return ancestorlist
  end

  def full_name(separator=' | ',output="")
    unless self.parent_id.nil?
      return self.class.find(self.parent_id).full_name(separator,output)+separator+self.title
    end
    if title
      return self.title+output
    else
      return output
    end
  end

  def children(specs={})
    if specs[:order]
      self.class.find :all, :conditions=>['parent_id=?',self.id], :order=>specs[:order]    
    else
      self.class.find :all, :conditions=>['parent_id=?',self.id]
    end
  end

  def descendants
    results=[]
    unless self.children.empty?
      self.children.each do |c|
        results << c
        unless c.descendants.empty?
          c.descendants.each do |d|
            results << d
          end
        end
      end
    end
    results=results.uniq
    results
  end
  
  def descendants_tree(field='title')
    if self.respond_to?(field)
      tree={}
      self.descendants.each do |d|
        tree[d.full_name]=d
      end
      tree=tree.sort_by{|key| key}
      results=[]
      tree.each do |key, value|
        results << value
      end
      return results
    end
    self.descendants
  end
  
  
  def inherit_attributes(attributes=['country'])
    attributes.each do |attribute|
      unless self.parent.nil?
        self.send(attribute, self.parent.send(attribute))
      end
    end
  end
  
  
  def parent
    unless self.parent_id.nil?
      return self.class.find(self.parent_id)
    end
    nil
  end

  def parent=(dad)
    if dad.class==self.class
      if (dad.class).exists?(dad.id)
        self.parent_id=dad.id
        return true
      end
    end
    false
  end
  
  def place_in_tree
    if parent.nil?
      return 0
    else
      return (1+parent.place_in_tree)
    end
  end
  
  def self_and_ancestors
    result=[self]
    result+=ancestors
    result
  end
  
  def self_and_children
    results=[]
    results << [self.full_name, self]
    unless self.children.empty?
      self.children.each do |d|
        results << [d.full_name, d]
      end
    end
    returnthis=[]
    results=results.sort_by{|key| key}
    results.each do |key, value|
      returnthis << value
    end
    returnthis  
  end
  
  def self_and_descendants
    results=[]
    results << self
    unless self.descendants.empty?
      self.descendants.each do |d|
        results << d
      end
    end
    results
  end
  
  def sensible_top_level(cs=[])
    cs=cs.select{|c| c.is_a?(self.class)}
    if cs.empty?
      return []
    end
    result=[]
    cs.each do |c|
      as=c.self_and_ancestors.sort_by{|a| a.place_in_tree}.reverse
      unless as.empty?
        as.each do |a|
          ds=a.self_and_descendants
          if (ds+cs).uniq==ds
            result << a
            break 
          end
        end
      end
    end
    result.uniq
  end

  def siblings
    unless self.parent.nil?
      return self.class.find(:all, :conditions=>['parent_id=? and id!=?',self.parent.id, self.id])
    end
    []
  end
  
  def tree(specs={})
    unless specs[:field]
      specs[:field]='title'
    end
    unless self.respond_to?(specs[:field])
      return nil
    end
    unless specs[:group]
      specs[:group]=self.class.find(:all, :conditions=>['parent_id is null'], :order=>specs[:field])
    end
    tree=[]
    specs[:group].each do |s|
      unless s.nil?
        tree << s
        t=s.descendants_tree
        unless t.empty?
          t.each do |tt|
            unless tt.nil?
              tree << tt
            end
          end
        end
      end
    end
    tree=tree.uniq
    tree
  end
  
  def ultimate_parent
    if self.parent.nil?
      return self
    else
      return self.parent.ultimate_parent
    end
  end
  
  def validate_parent
    if parent_id and self.class.exists?(parent_id)
      p=self.class.find(parent_id)
      unless self_and_descendants.include?(p)
        return
      end
    end
    self.parent_id=nil
  end
  #############################################################################
  #                                                                           #
  #   End Terry's version of acts as tree                                     #
  #                                                                           #
  #############################################################################
end