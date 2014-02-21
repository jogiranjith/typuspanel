class Admin::EntryBulksController < Admin::ResourcesController

  include Admin::Bulk

  before_filter :set_bulk_action_to_publish, :only => [:index]
  before_filter :set_bulk_action_to_unpublish, :only => [:index]

  def bulk_publish(ids)
    EntryBulk.where(id: ids).update_all(published: true)
    redirect_to :back
  end

  def bulk_unpublish(ids)
    EntryBulk.where(id: ids).update_all(published: false)
    redirect_to :back
  end

  def set_bulk_action_to_publish
    add_bulk_action("Mark as published", "bulk_publish")
  end
  private :set_bulk_action_to_publish

  def set_bulk_action_to_unpublish
    add_bulk_action("Mark as unpublished", "bulk_unpublish")
  end
  private :set_bulk_action_to_unpublish

end
