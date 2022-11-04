require 'rails_helper'

describe SearchModule do
  let(:klass) { described_class.to_s.underscore.to_sym }

  describe 'validations' do
    describe 'presence' do
      it(:klass) { expect(build(klass, klass: nil)).to_not be_valid }
    end
  end

  describe 'scopes' do
    it '.weighted' do
      a = create(klass, klass: 'Foo', weight: 5)
      b = create(klass, klass: 'Bar', weight: 10)
      c = create(klass, klass: 'Baz', weight: 1)
      expect(described_class.weighted).to eq [b, a, c]
    end

    it '.searchable' do
      a = create(klass, klass: 'Foo', searchable: true)
      b = create(klass, klass: 'Bar', searchable: false)
      c = create(klass, klass: 'Baz', searchable: true)
      d = create(klass, klass: 'Baz', searchable: nil)
      expect(described_class.searchable).to eq [a, c]
    end
  end

  describe '#search_indices' do
    it 'default' do
      expect(subject.search_indices).to eq []
    end

    it 'filters from other modules' do
      subject = create(klass, klass: 'Foo')
      a = create(:search_index, searchable_type: 'Foo', searchable_id: 1)
      b = create(:search_index, searchable_type: 'Bar', searchable_id: 1)
      c = create(:search_index, searchable_type: 'Foo', searchable_id: 2)
      expect(subject.search_indices).to eq [a, c]
    end
  end

  it '#responds_to?' do
    expect(subject).to respond_to(:search_indices)
  end
end
