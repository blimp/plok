require 'rails_helper'

describe Plok::Search::[namespace] do
  subject { described_class.new('John', namespace: '[snakecased_namespace]') }

  describe '#search' do
    it 'defaults to an empty list' do
      # Have to cast to an array because search lazy loads results.
      expect(subject.search.to_a).to eq []
    end

    it 'returns relevant indices' do
      # TODO:
    end
  end

  it '#respond_to?' do
    expect(subject).to respond_to(:format_search_results, :search_indices)
  end
end
