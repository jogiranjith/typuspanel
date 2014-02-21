module Typus
  module Orm
    module Base
      module Search

        def build_search_conditions(key, value)
          raise "Not implemented!"
        end

        def build_boolean_conditions(key, value)
          { key => (value == 'true') ? true : false }
        end

        def build_date_conditions(key, value)
          if %w(all_day all_week all_month all_year).include?(value)
            interval = Time.zone.now.send(value)
            build_filter_interval(interval, key)
          else
            raise "#{value} is not allowed!"
          end
        end

        alias_method :build_datetime_conditions, :build_date_conditions
        alias_method :build_timestamp_conditions, :build_date_conditions

        def build_filter_interval(interval, key)
          raise "Not implemented!"
        end

        def build_string_conditions(key, value)
          { key => value }
        end

        alias_method :build_integer_conditions, :build_string_conditions
        alias_method :build_belongs_to_conditions, :build_string_conditions

        # TODO: Detect the primary_key for this object.
        def build_has_many_conditions(key, value)
          ["#{key}.id = ?", value]
        end

        # To build conditions we accept only model fields and the search
        # param.
        def build_conditions(params)
          Array.new.tap do |conditions|
            query_params = params.dup

            query_params.reject! do |k, v|
              !model_fields.keys.include?(k.to_sym) &&
              !model_relationships.keys.include?(k.to_sym) &&
              !(k.to_sym == :search)
            end

            query_params.compact.each do |key, value|
              filter_type = model_fields[key.to_sym] || model_relationships[key.to_sym] || key
              conditions << send("build_#{filter_type}_conditions", key, value)
            end
          end
        end

        def build_my_joins(params)
          query_params = params.dup
          query_params.reject! { |k, v| !model_relationships.keys.include?(k.to_sym) }
          query_params.compact.map { |k, v| k.to_sym }
        end

      end
    end
  end
end
