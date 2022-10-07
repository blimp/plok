require 'rails_helper'

describe Plok::FakeArModel do
  it 'makes arguments available as value methods' do
    expect(described_class.new(gaga: 'booboo').gaga).to eq 'booboo'
  end

  describe '#find' do
    it 'returns nil by default' do
      expect(described_class.find(1)).to be nil
    end

    it 'returns a match from the internal collection' do
      described_class.collection([
        { id: 2, name: 'Foo' },
        { id: 3, name: 'Bar' },
        { id: 4, name: 'Baz' }
      ])

      expect(described_class.find(3).name).to eq 'Bar'
    end
  end

  describe '#find_by' do
    before do
      # You need to reset the collection because it persists on the class.
      described_class.collection(nil)
    end

    it 'defaults to nil' do
      expect(described_class.find_by(name: 'Baz')).to be nil
    end

    it 'returns the item we request' do
      described_class.collection([
        { id: 2, name: 'Foo' },
        { id: 3, name: 'Bar' },
        { id: 4, name: 'Baz' }
      ])

      expect(described_class.find_by(name: 'Baz').id).to eq 4
    end
  end

  describe '#where' do
    it 'defaults to an empty array' do
      described_class.collection([
        { id: 2, name: 'Foo' },
        { id: 3, name: 'Bar' },
        { id: 4, name: 'Baz' }
      ])

      expect(described_class.where(name: 'Bar').first.id).to eq 3
    end
  end
end
