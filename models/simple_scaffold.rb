module SimpleScaffold

  def self.included(base)
    base.extend(ClassMethods)
    @manage_ignore_fields = {} unless @manage_ignore_fields
    @new_ignore_fields = {} unless @new_ignore_fields
    @show_ignore_fields = {} unless @show_ignore_fields
    @edit_ignore_fields = {} unless @edit_ignore_fields
    @manage_add_fields = {} unless @manage_add_fields
    @new_add_fields = {} unless @new_add_fields
    @show_add_fields = {} unless @show_add_fields
    @edit_add_fields = {} unless @edit_add_fields
  end

  def list_item
    {:id => id, :human_id => human_id}
  end

  #something that ID's the model to a human
  def human_id
    SimpleScaffold.human_id
  end

  def scaffold_manage
    SimpleScaffold.scaffold :manage, self
  end

  def scaffold_show
    SimpleScaffold.scaffold :show, self
  end

  def scaffold_edit
    SimpleScaffold.scaffold :edit, self
  end

  def scaffold_manage_headings
    SimpleScaffold.scaffold :manage, self, :headings
  end

  def self.association_classes parent
    all_associations = [:has_many, :has_one, :belongs_to, :embeds_many, :embeds_one, :embedded_in, :has_and_belongs_to_many]
    ass_obj_array = []
    all_associations.each do |ass|
      parent.reflect_on_all_associations(ass).each {|rr| ass_obj_array << rr}
    end
    associations = []
    ass_obj_array.each do |ass_object|
      associations << ass_object.class_name
    end
    associations
  end

  def self.get_associations parent, ignore_fields=[], heading_titles
    all_associations = [:has_many, :has_one, :belongs_to, :embeds_many, :embeds_one, :embedded_in, :has_and_belongs_to_many]
    ass_obj_array = []
    all_associations.each do |ass|
      parent.reflect_on_all_associations(ass).each {|rr| ass_obj_array << rr}
    end
    associations = {}
    ass_obj_array.each do |ass_object|
      unless ignore_fields.include? ass_object.name
        macro = ass_object.macro
        name = ass_object.name
        class_name = ass_object.class_name
        it_has_many = (macro == :has_many || macro == :has_and_belongs_to_many || macro == :embeds_many)
        if it_has_many && !heading_titles
         # puts "name = #{name}, parent = #{parent} "
          count = parent.send("#{name}").count
        else
          count = 1
        end
        ids = []
        max = 5
        id_amount = (max if count > max) || count
        unless heading_titles
          objs= (parent.send("#{name}").limit(id_amount) if it_has_many) || [parent.send("#{name}")]
          objs.each do |obj|
            if obj.nil?
              count = 0
            else
              ids << {:id => obj.id, :human_id => obj.human_id}
            end
          end
        end
        value_obj = (name.to_sym if heading_titles)||({name.to_sym => {:class_name => class_name, :count => count, :ids => ids }})
        #puts ids.inspect
        if associations[macro]
          associations[macro] << value_obj
        else
          associations[macro] = [value_obj]
        end
      end
    end
    associations
  end

  def self.get_added_fields scaffold_type, parent_name
    add_fields = @manage_add_fields[parent_name] if scaffold_type == :manage
    add_fields = @edit_add_fields[parent_name] if scaffold_type == :edit
    add_fields = @new_add_fields[parent_name] if scaffold_type == :new
    add_fields = @show_add_fields[parent_name] if scaffold_type == :show
    add_fields = [] if add_fields.nil?
    add_fields
  end

  def self.get_ignored_fields scaffold_type, parent_name
    ignore_fields = @manage_ignore_fields[parent_name] if scaffold_type == :manage
    ignore_fields = @edit_ignore_fields[parent_name] if scaffold_type == :edit
    ignore_fields = @new_ignore_fields[parent_name] if scaffold_type == :new
    ignore_fields = @show_ignore_fields[parent_name] if scaffold_type == :show
    ignore_fields = [] if ignore_fields.nil?
    ignore_fields
  end

  def self.scaffold scaffold_type, parent, heading=:none
    p_name = ("#{parent.name}" if parent.is_a? Class) || "#{parent.class.name}"
    heading_titles = (heading == :headings) || (parent.is_a? Class)
    ignore_fields = get_ignored_fields scaffold_type, p_name
    add_fields = get_added_fields scaffold_type, p_name
    sc = {:heading_titles => heading_titles, :model_name => p_name}
    sc[:human_id] = ("HEADINGS" if heading_titles) || (parent.human_id || parent._id)
    sc[:id] = ("HEADINGS" if heading_titles) || parent._id
    fields = {}
    parent.fields.each do |field|
      field_obj = field[1]
      unless ignore_fields.include? field_obj.name
        field_type = field_obj.type
        field_value = ("HEADING" if heading_titles) || (parent.send field_obj.name)
        fields[field_obj.name] = {:value => field_value, :type => field_type}
      end
    end
    add_fields.each do |field|
      unless ignore_fields.include? field[:field]
        field_type = (field[:type]) || String
        field_value = ("HEADING" if heading_titles) || nil
        fields[field[:field]] = {:value => field_value, :type => field_type}
      end
    end
    sc[:fields] = fields
    sc[:associations] = get_associations parent, @manage_ignore_fields, heading_titles
    sc
  end

  def self.manage_ignore parent, these_fields
    @manage_ignore_fields.merge!({"#{parent.name}" => these_fields })
  end

  def self.new_ignore parent, these_fields
    @new_ignore_fields.merge!({"#{parent.name}" => these_fields })
  end

  def self.edit_ignore parent, these_fields
    @edit_ignore_fields.merge!({"#{parent.name}" => these_fields })
  end

  def self.show_ignore parent, these_fields
    @show_ignore_fields.merge!({"#{parent.name}" => these_fields })
  end

  def self.manage_add parent, these_fields
    @manage_add_fields.merge!({"#{parent.name}" => these_fields })
  end

  def self.new_add parent, these_fields
    @new_add_fields.merge!({"#{parent.name}" => these_fields })
  end

  def self.edit_add parent, these_fields
    @edit_add_fields.merge!({"#{parent.name}" => these_fields })
  end

  def self.show_add parent, these_fields
    @show_add_fields.merge!({"#{parent.name}" => these_fields })
  end

  module ClassMethods
    def scaffold_manage_headings
      SimpleScaffold.scaffold :manage, self, :headings
    end

    def scaffold_association_classes
       SimpleScaffold.association_classes self
    end

    def scaffold_list_items
      items = []
      self.each do |item|
        items << item.list_item
      end
      {:class_name => self.name, :count => items.length, :ids => items}
    end
  end
end
