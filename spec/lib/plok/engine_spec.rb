require 'rails_helper'

describe Plok::Engine do
  describe '#class_exists?' do
    it 'returns false when a class does not exist' do
      expect(described_class.class_exists?('Foo')).to be false
    end

    it 'returns true if a class exists' do
      expect(described_class.class_exists?('Plok::Engine')).to be true
    end
  end

  describe '#module_exists?' do
    it 'returns false when a module does not exist' do
      expect(described_class.module_exists?('Foo')).to be false
    end

    it 'returns true if a module exists' do
      expect(described_class.module_exists?('Plok')).to be true
    end
  end
end
