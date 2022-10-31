require 'rails_helper'

describe Plok::Search::Backend do
  subject { described_class.new('foo', namespace: 'Backend') }

  before do
    class FakePage < Plok::FakeArModel; end

    class Plok::Search::ResultObjects::Base
      def url
        search_context.controller.edit_backend_page_path
      end
    end

    create(:search_module, klass: 'FakePage', weight: 1)

    # So we can use "bogus" partials.
    ApplicationController.view_paths << 'spec/fixtures/files'
  end

  describe '#search' do
    it 'default' do
      expect(subject.search.to_a).to eq []
    end

    context 'results' do
      let(:controller) { OpenStruct.new(edit_backend_page_path: '/backend/pages/1/edit') }

      before do
        @page_a = FakePage.new(id: 1, title: 'Foo', description: 'foobar')
        @page_b = FakePage.new(id: 2, title: 'Bar', description: 'foobar too')
        @index_a = create(:search_index,
                          searchable: @page_a,
                          locale: 'nl',
                          name: 'description',
                          value: 'foobar')

        allow(File).to receive(:exists?) { true }
      end

      subject { described_class.new('foobar', controller: controller) }

      it 'single' do
        allow(subject).to receive(:search_indices) { [@index_a] }

        expect(subject.search).to eq [{ label: "Pagina — Foo<br />\n<small>\n  foobar\n</small>\n", value: '/backend/pages/1/edit' }]
      end

      it 'multiple' do
        index_b = create(:search_index, searchable: @page_b, locale: 'nl', name: 'description', value: 'foobar too')
        allow(subject).to receive(:search_indices) { [@index_a, index_b] }

        expect(subject.search).to eq [
          { label: "Pagina — Foo<br />\n<small>\n  foobar\n</small>\n", value: '/backend/pages/1/edit' },
          { label: "Pagina — Bar<br />\n<small>\n  foobar too\n</small>\n", value: '/backend/pages/1/edit' }
        ]
      end
    end
  end

  it '#responds_to?' do
    expect(subject).to respond_to(:search_indices, :result_object)
  end
end
