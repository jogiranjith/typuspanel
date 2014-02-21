module Admin::Resources::DataTypes::HasManyHelper

  def has_many_filter(filter)
    att_assoc = @resource.reflect_on_association(filter.to_sym)
    class_name = att_assoc.options[:class_name] || filter.classify
    resource = class_name.constantize

    items = [[Typus::I18n.t("View all %{attribute}", :attribute => @resource.human_attribute_name(filter).downcase.pluralize), ""]]
    items += resource.order(resource.typus_order_by).map { |v| [v.to_label, v.id] }
  end

  alias_method :has_and_belongs_to_many_filter, :has_many_filter

  def typus_form_has_many(field)
    setup_relationship(field)

    options = { "resource[#{@reflection.foreign_key}]" => @item.id }

    if @reflection.options && (as = @reflection.options[:as])
      klass = @resource.is_sti? ? @resource.superclass : @resource
      options.merge!("#{as}_type" => klass)
    end

    build_pagination
    set_has_many_resource_actions

    locals = { :association_name => @association_name,
               :add_new => build_add_new_for_has_many(@model_to_relate, field, options),
               :table => build_relationship_table }

    render "admin/templates/has_many", locals
  end

  def build_add_new_for_has_many(klass, field, options = {})
    if admin_user.can?("create", klass)

      html_options = set_modal_options_for(klass)
      html_options["url"] = "/admin/#{klass.to_resource}/new?_popup=true"

      link_to Typus::I18n.t("Add"), "##{html_options['data-controls-modal']}", html_options
    end
  end

  def set_has_many_resource_actions
    klass = @model_to_relate
    @resource_actions = [set_has_many_resource_edit_action(klass),
                         set_has_many_resource_show_action(klass),
                         set_has_many_resource_destroy_action(klass)]
  end

  def set_has_many_resource_edit_action(klass)
    html_options = set_modal_options_for(klass)
    [ "Edit", { :action => 'edit', :anchor => html_options['data-controls-modal'] }, html_options ]
  end

  def set_has_many_resource_show_action(klass)
    html_options = set_modal_options_for(klass)
    [ "Show", { :action => 'show', :anchor => html_options['data-controls-modal'] }, html_options ]
  end

  def set_has_many_resource_destroy_action(klass)
    [ "Trash", { :action => 'destroy' }, { :confirm => "Trash?" } ]
  end

end
