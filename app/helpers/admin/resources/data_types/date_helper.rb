module Admin::Resources::DataTypes::DateHelper

  def date_filter(filter)
    values = { :all_day => "Today",
               :all_week => "This week",
               :all_month => "This month",
               :all_year => "This year" }

    items = [[@resource.human_attribute_name(filter).capitalize, ""]]
    items += values.map { |k, v| [Typus::I18n.t(v), k] }
  end

  alias_method :datetime_filter, :date_filter
  alias_method :timestamp_filter, :date_filter

end
