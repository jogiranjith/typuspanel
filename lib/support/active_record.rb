class ActiveRecord::Base

  #--
  # On a model:
  #
  #     class Post < ActiveRecord::Base
  #       def self.statuses
  #         { t("Published") => "published",
  #           t("Pending") => "pending",
  #           t("Draft") => "draft" }
  #       end
  #     end
  #
  #     >> Post.first.status
  #     => "published"
  #     >> Post.first.mapping(:status)
  #     => "Published"
  #     >> I18n.locale = :es
  #     => :es
  #     >> Post.first.mapping(:status)
  #     => "Publicado"
  #++
  def mapping(attribute)
    values = self.class.send(attribute.to_s.pluralize)
    array = values.first.is_a?(Array) ? values : values.map { |i| [i, i] }
    value = array.to_a.rassoc(send(attribute))
    value ? value.first : send(attribute)
  end

  def to_label
    if respond_to?(:name) && name.present?
      name
    else
      [self.class, id].join("#")
    end
  end

  def identifier
    "##{id}"
  end

end
