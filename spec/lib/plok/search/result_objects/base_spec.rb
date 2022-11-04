require 'rails_helper'

describe Plok::Search::ResultObjects::Base do
  let(:index) do
    create(:search_index,
           searchable_type: 'Plok::FakeArModel',
           searchable_id: 1,
           name: 'name',
           value: 'foo')
  end

  let(:search_context) { Plok::Search::Base.new('foo', namespace: 'frontend') }
  subject { described_class.new(index, search_context: search_context) }

  describe '#label' do
    let(:fake_ar_model) { Plok::FakeArModel.new(id: 1, foo: 'foobar') }

    it 'default' do
      index = create(:search_index, searchable: fake_ar_model, name: 'foo', value: 'foobar')
      subject = described_class.new(index, search_context: search_context)

      expect(subject.label).to eq 'foobar'
    end

    it 'flexible_content' do
      # TODO: Remove this placeholder class when flexible content stuff (or
      # at least ContentText) gets added to Plok.
      class ContentText < Plok::FakeArModel; end
      ContentText.collection([
        { id: 1, content: 'This search is foobar.' }
      ])

      index = create(:search_index,
                     searchable: fake_ar_model,
                     name: "flexible_content:1",
                     value: 'foobar')
      subject = described_class.new(index, search_context: search_context)

      expect(subject.label).to eq 'This search is foobar.'
    end
  end

  it '#locals' do
    allow(index).to receive(:searchable) { 'bar' }
    expect(subject.locals).to eq({ 'plok/fake_ar_model': 'bar', index: index })
  end

  it '#partial' do
    expect(subject.partial).to eq 'frontend/search/plok/fake_ar_model'
  end

  it '#partial_path' do
    expect(subject.partial_path).to eq 'frontend/search'
  end

  it '#partial_target' do
    index = create(:search_index, searchable_type: 'FooBar')
    subject = described_class.new(index)
    expect(subject.partial_target).to eq 'foo_bar'
  end

  describe '#hidden?' do
    it 'false' do
      index = create(:search_index, searchable: Plok::FakeArModel.new(visible: true))
      subject = described_class.new(index, search_context: search_context)
      expect(subject.hidden?).to be false
    end
  end

  describe '#unpublished?' do
    it 'false' do
      index = create(:search_index, searchable: Plok::FakeArModel.new(published: true))
      subject = described_class.new(index, search_context: search_context)
      expect(subject.unpublished?).to be false
    end
  end

  it '#responds_to?' do
    expect(subject).to respond_to(:build_html, :url)
  end
end
