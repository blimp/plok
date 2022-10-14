class SearchIndex < ActiveRecord::Base
  belongs_to :searchable, polymorphic: true

  validates :name, presence: true
end
