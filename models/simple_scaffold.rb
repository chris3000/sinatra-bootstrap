module SimpleScaffold

  def self.included(base)
    base.extend(ClassMethods)
  end

  #something that ID's the model to a human
  def human_id
    SimpleScaffold.human_id
  end

  def scaffold_manage
    SimpleScaffold.scaffold :manage, self
  end

  def scaffold_manage_headings
    SimpleScaffold.scaffold :manage, self, :headings
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
        ids = []
        if macro == :has_many && !heading_titles
          ids |= parent.send("#{class_name.downcase}_ids")
        elsif macro == :belongs_to && !heading_titles
          ids << parent.send("#{class_name.downcase}_id")
        end
        value_obj = (name.to_sym if heading_titles)||({name.to_sym => {:class_name => class_name, :ids => ids }})
        #puts ids.inspect
        if associations[macro]
          associations[macro].merge!(value_obj)
        else
          associations[macro] = [value_obj]
        end
      end
    end
    associations
  end

  def self.scaffold scaffold_type, parent, heading=:none
    p_name = ("#{parent.name}" if parent.is_a? Class) || "#{parent.class.name}"
    heading_titles = (heading == :headings) || (parent.is_a? Class)
    ignore_fields = []
    ignore_fields = @manage_ignore_fields[p_name] if scaffold_type == :manage
    ignore_fields = @update_ignore_fields if scaffold_type == :update
    ignore_fields = @new_ignore_fields if scaffold_type == :new
    ignore_fields = @show_ignore_fields if scaffold_type == :show
    sc = {:heading_titles => heading_titles}
    sc[:human_id] = ("HEADINGS" if heading_titles) || (parent.human_id || parent._id)
    fields = {}
    parent.fields.each do |field|
      field_obj = field[1]
      unless ignore_fields.include? field_obj.name
        fields[field_obj.name] = (field_obj.type if heading_titles) || (parent.send field_obj.name)
      end
    end
    sc[:fields] = fields
    sc[:associations] = get_associations parent, @manage_ignore_fields, heading_titles
    sc
  end

  def self.manage_ignore parent, these_fields
    @manage_ignore_fields = {} unless @manage_ignore_fields
    @manage_ignore_fields.merge!({"#{parent.name}" => these_fields })
  end

  def self.new_ignore parent, these_fields
    @new_ignore_fields = {} unless @new_ignore_fields
    @new_ignore_fields.merge!({"#{parent.name}" => these_fields })
  end

  def self.update_ignore parent, these_fields
    @update_ignore_fields = {} unless @update_ignore_fields
    @update_ignore_fields.merge!({"#{parent.name}" => these_fields })
  end

  def self.show_ignore parent, these_fields
    @show_ignore_fields = {} unless @show_ignore_fields
    @show_ignore_fields.merge!({"#{parent.name}" => these_fields })
  end
  module ClassMethods
    def scaffold_manage_headings
      SimpleScaffold.scaffold :manage, self, :headings
    end
  end
end
