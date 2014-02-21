require 'csv'

module Admin
  module Format

    protected

    def get_paginated_data
      items_per_page = params[:per_page] || @resource.typus_options_for(:per_page)
      offset = params[:offset] || 0
      @items = @resource.limit(items_per_page).offset(offset)
    end

    def generate_csv
      fields = @resource.typus_fields_for(:csv)
      records = @resource.all

      data = ::CSV.generate do |csv|
        csv << fields.keys.map { |k| @resource.human_attribute_name(k) }
        records.each do |record|
          csv << fields.map do |key, value|
                   case value
                   when :transversal
                     a, b = key.split(".")
                     record.send(a).send(b)
                   when :belongs_to
                     record.send(key).try(:to_label)
                   else
                     record.send(key)
                   end
                 end
        end
      end

      send_data data, :filename => "export-#{@resource.to_resource}-#{Time.zone.now.to_s(:number)}.csv"
    end

    def export(format)
      fields = @resource.typus_fields_for(format).map(&:first)
      methods = fields - @resource.column_names
      except = @resource.column_names - fields

      get_paginated_data

      render format => @items.send("to_#{format}", :methods => methods, :except => except)
    end

  end
end
