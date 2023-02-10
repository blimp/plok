require 'rails_helper'

shared_examples_for :searchable do
  let(:klass) { described_class.to_s.underscore.to_sym }

  describe 'relations' do
    context 'when destroying a searchable model' do
      it 'deletes all linked SearchIndex records' do
        subject = create(klass)
        index = create(:search_index, searchable: subject)
        expect { subject.destroy }.to change(SearchIndex, :count)
      end
    end
  end

  describe 'after_save' do
    context 'non-translatable model' do
      before do
        # Because this is a spec/support included through it_behaves_like,
        # we have to mock the entry points of the data used in
        # Plok::Searchable.
        allow(described_class).to receive(:searchable_fields_list) do
          {
            backend: [
              { name: :foo, conditions: [] }
            ]
          }
        end

        if described_class.respond_to?(:translatable_fields_list)
          allow(described_class).to receive(:translatable_fields_list) { [] }
        end

        described_class.define_method(:foo) { 'bar' }
      end

      it 'default' do
        subject = build(klass)
        allow(subject).to receive(:foo) { 'bar' }
        expect(subject.search_indices).to eq []
      end

      # NOTE: See if you can dynamically test the creation of indices on save.
    end

    if described_class.respond_to?(:translatable_fields)
      before do
        allow(described_class).to receive(:searchable_fields_list) do
          {
            backend: [
              { name: :foo, conditions: [] }
            ]
          }
        end
      end

      context 'translatable model' do
        before do
          described_class.translatable_fields :foo, :bar
        end

        let(:create_subject!) do
          subject = build(klass)
          %w(nl fr).each do |l|
            t = subject.translation(l.to_sym)
            t.foo = "baz #{l}"
            t.bar = 'bak'
          end
          subject.save
          subject
        end

        it 'does not copy translatable fields that are not in searchable fields' do
          subject = create_subject!
          expect(subject.search_indices.find_by(locale: :nl, name: 'bar')).to be nil
        end
      end
    end

    if described_class.respond_to?(:content_rows)
      context 'model with flexible_content' do
        let(:subject) { create(klass) }
        let(:content) { create(:content_text, content: 'Lorem ipsum') }

        before do
          # Because this is a spec/support included through it_behaves_like,
          # we have to mock the entry points of the data used in
          # Plok::Searchable.
          allow(described_class).to receive(:searchable_fields_list) do
            {
              backend: [
                { name: :foo, conditions: [] }
              ]
            }
          end

          allow_any_subject_of(described_class).to receive(:foo) { 'bar' }
          allow_any_subject_of(Concerns::Storable::Collection).to receive(:foo) { 'bar' }

          row = create(:content_row, locale: 'nl', rowable: subject)
          row.columns << create(:content_column, content: content)
          subject.content_rows << row
        end

        it 'saves index when updating searchable subject' do
          subject.save!
          key = "flexible_content:#{content.id}"
          expect(subject.search_indices.find_by(locale: :nl, name: key).value).to eq 'Lorem ipsum'
        end

        it 'saves index when updating flexible content' do
          subject.save!
          content.content = 'Dolor sit amet'
          content.save!
          key = "flexible_content:#{content.id}"
          expect(subject.search_indices.find_by(locale: :nl, name: key).value).to eq 'Dolor sit amet'
        end
      end
    end
  end

  it '.respond_to?' do
    expect(described_class).to respond_to(
      :plok_searchable, :searchable_field, :searchable_fields_list
    )
  end

  it '#respond_to?' do
    expect(subject).to respond_to(:search_indices)
  end
end
