class Delayed::Task < ActiveRecord::Base

  self.table_name = "delayed_tasks"

end
