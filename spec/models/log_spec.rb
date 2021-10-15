require 'rails_helper'

describe Log do
  let(:klass) { described_class.to_s.underscore.to_sym }

  # TODO: See Log
  xdescribe '#loggable_path' do
    it 'returns nil by default' do
      expect(subject.loggable_path).to be nil
    end

    it 'returns the loggable path, where applicable' do
      order = create(:order)
      subject = create('log', loggable: order)
      expect(subject.loggable_path).to eq "http://localhost:3000/backend/orders/#{order.id}"
    end
  end

  describe '.latest' do
    it 'returns nothing by default' do
      expect(described_class.latest).to be nil
    end

    it 'returns the latest log' do
      a = create('log')
      b = create('log')
      c = create('log')

      expect(described_class.latest).to eq c
    end
  end

  describe 'validations' do
    describe '#some_content_present?' do
      describe 'valid' do
        it 'with content' do
          subject = build(klass, content: 'foo')
          expect(subject).to be_valid
        end

        it 'with file' do
          subject = build(klass, file: 'foo.pdf')
          expect(subject).to be_valid
        end

        it 'with image' do
          subject = build(klass, file: 'foo.jpg')
          expect(subject).to be_valid
        end
      end

      it 'invalid' do
        subject = build(klass, content: nil, file: nil)
        expect(subject).to_not be_valid
      end
    end
  end

  describe 'scopes' do
    it :default_scope do
      a = create(klass, loggable_id: 1, created_at: 2.days.ago)
      b = create(klass, loggable_id: 2, created_at: 1.day.ago)
      c = create(klass, loggable_id: 3, created_at: 3.days.ago)

      expect(described_class.all).to eq [b, a, c]
    end

    it '.status' do
      a = create(klass, category: 'status', created_at: 2.days.ago)
      b = create(klass, category: 'foo', created_at: 1.day.ago)
      c = create(klass, category: 'bar', created_at: 3.days.ago)

      expect(described_class.status).to eq [a]
    end
  end

  it '#respond_to?' do
    expect(described_class.new).to respond_to(:loggable)
  end

  it '.respond_to?' do
    expect(described_class).to respond_to(:status)
  end
end
