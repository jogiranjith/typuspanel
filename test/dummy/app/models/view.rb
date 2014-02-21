=begin

  This model is used to test:

    - View.typus_application when no application is set.
    - Scoped stuff by domain.

=end

class View < ActiveRecord::Base

  ##
  # Validations
  #

  validates :post, :presence => true

  ##
  # Associations
  #

  belongs_to :post
  belongs_to :site

end
