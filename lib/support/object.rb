class Object

  # OPTIMIZE: Probably there's a better way to verify if a model responds
  # to an STI pattern.
  def self.is_sti?
    (name != base_class.name) && base_class.descends_from_active_record?
  end

end
