module Admin
  module Ancestry

    def index
      @items = []

      @resource.roots.each do |item|
        @items << item
        if item.has_children?
          item.children.each do |child|
            @items << child
            if child.has_children?
              child.children.each do |child|
                @items << child
              end
            end
          end
        end
      end

      set_default_action
      add_resource_action("Trash", {:action => "destroy"}, {:confirm => "#{Typus::I18n.t("Trash")}?", :method => 'delete'})
    end

  end
end
