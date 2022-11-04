class SearchModule < ActiveRecord::Base

  scope :searchable, -> { where('search_modules.searchable': true) }
  scope :weighted, -> { order('search_modules.weight DESC') }

  validates :klass, presence: true

  def search_indices
    SearchIndex.where(searchable_type: klass)
  end

end
