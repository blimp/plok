class SearchModule < ActiveRecord::Base
  scope :weighted, -> { order('weight DESC') }

  validates :klass, presence: true

  def indices
    SearchIndex
      .joins('INNER JOIN search_modules ON search_indices.searchable_type = search_modules.klass')
      .where('search_modules.klass = ?', klass)
  end
end
