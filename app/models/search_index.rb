class SearchIndex < ActiveRecord::Base
  belongs_to :searchable, polymorphic: true

  validates :locale, :name, presence: true
end
