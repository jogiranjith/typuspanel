if defined?(ActiveRecord)
  require 'typus/orm/active_record/class_methods'
  ActiveRecord::Base.extend Typus::Orm::ActiveRecord::ClassMethods

  require 'typus/orm/active_record/search'
  ActiveRecord::Base.extend Typus::Orm::ActiveRecord::Search

  require 'typus/orm/active_record/admin_user'
  ActiveRecord::Base.extend Typus::Orm::ActiveRecord::AdminUser::ClassMethods
end
