require 'rails_helper'

describe Plok::Search::Term do
  describe '#locale' do
    subject { described_class.new('foobar') }

    it 'defaults to Plok.config.i18n.app.default_locale without controller input' do
      subject = described_class.new('foobar', controller: double(:controller, locale: 'jp'))
      expect(subject.locale).to eq 'jp'
    end

    it 'value passed from controller' do
      controller = OpenStruct.new(locale: :en)
      subject = described_class.new('foobar', controller: controller)
      expect(subject.locale).to eq :en
    end
  end

  describe '#valid?' do
    it 'returns false when the term is nil' do
      subject = described_class.new(nil)
      expect(subject.valid?).to be false
    end

    it 'returns false when the term is an empty string' do
      subject = described_class.new('')
      expect(subject.valid?).to be false
    end

    it 'returns true when the term has a value' do
      subject = described_class.new('foo')
      expect(subject.valid?).to be true
    end
  end

  it '#responds_to?' do
    expect(described_class.new('')).to respond_to(
      :locale, :value
    )
  end
end
