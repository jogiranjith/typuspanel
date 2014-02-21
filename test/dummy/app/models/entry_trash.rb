class EntryTrash < Entry
  include Rails::Trash
  default_scope -> { where(arel_table[:deleted_at].eq(nil)) } if arel_table[:deleted_at]
end
