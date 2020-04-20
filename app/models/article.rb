# frozen_string_literal: true

class Article < ApplicationRecord
  has_many :comments
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings, dependent: :destroy
  has_one_attached :main_image
  validate :valid_image

  def valid_image
    return unless main_image.attached?

    unless main_image.byte_size <= 3.megabyte
      errors.add(:main_image, 'Image file is larger than 3MB')
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(main_image.content_type)
      errors.add(:main_image, "Must be a JPG or PNG file")
    end
  end

  def tag_list
    tags.collect(&:name).join(', ')
  end

  def tag_list=(tags_string)
    tag_names = tags_string.split(',').collect { |s| s.strip.downcase }.uniq
    new_or_found_tags = tag_names.collect { |name| Tag.find_or_create_by(name: name) }
    self.tags = new_or_found_tags
  end
end
