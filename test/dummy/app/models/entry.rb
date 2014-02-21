=begin

  This model is not enabled in typus but is used to test things things like:

    - Single Table Inheritance

=end

class Entry < ActiveRecord::Base

  ##
  # Validations
  #

  validates :title, :presence => true
  validates :content, :presence => true

  ##
  # Associations
  #

  has_and_belongs_to_many :categories

  ##
  # Scopes
  #

  scope :published, -> { where(:published => true) }

  ##
  # Instance Methods
  #

  def to_label
    title
  end

end
