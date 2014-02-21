class TypusUser < ActiveRecord::Base

  ##
  # Mixins
  #

  include Typus::Orm::ActiveRecord::AdminUser

  ##
  # Associations
  #

  has_many :invoices

  ##
  # Instance Methods
  #

  def per_page
    (preferences && preferences[:per_page]) ? preferences[:per_page] : ::Typus::Resources.per_page
  end

  def per_page=(per_page)
    self.preferences ||= {}
    self.preferences[:per_page] = per_page
  end

end
