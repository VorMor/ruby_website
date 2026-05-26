module Sluggable
  extend ActiveSupport::Concern

  included do
    class_attribute :slug_source_attribute, default: :name
    before_validation :assign_unique_slug
  end

  class_methods do
    def slug_from(attribute_name)
      self.slug_source_attribute = attribute_name
    end
  end

  private

  def assign_unique_slug
    return if slug.present? && !will_save_change_to_attribute?(slug_source_attribute)

    base_slug = RussianSlug.call(public_send(slug_source_attribute)).presence || "item"
    candidate = base_slug
    suffix = 2

    while self.class.where.not(id: id).exists?(slug: candidate)
      candidate = "#{base_slug}-#{suffix}"
      suffix += 1
    end

    self.slug = candidate
  end
end
