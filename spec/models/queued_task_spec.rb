require 'rails_helper'

describe QueuedTask do
  let(:klass) { described_class.to_s.underscore.to_sym }

  describe 'validations' do
    describe 'presence' do
      it(:klass) { expect(build(klass, klass: nil)).not_to be_valid }
    end
  end

  describe 'scopes' do
    describe '.locked' do
      it 'returns only locked tasks' do
        a = create(klass, locked: true)
        b = create(klass, locked: false)
        c = create(klass, locked: nil)
        expect(described_class.locked).to eq [a]
      end
    end

    describe '.unlocked' do
      it 'returns only unlocked tasks' do
        a = create(klass, locked: true)
        b = create(klass, locked: false)
        c = create(klass, locked: nil)
        expect(described_class.unlocked).to eq [b, c]
      end
    end

    describe '.past' do
      it 'defaults to an empty list' do
        expect(described_class.past).to eq []
      end

      it 'also returns nothing when QueuedTask#perform_at is blank!' do
        a = create(klass)
        b = create(klass)
        expect(described_class.past).to eq [a, b]
      end

      it 'returns nothing when all QueuedTask#perform_at is in the past' do
        a = create(klass, perform_at: 1.day.ago)
        b = create(klass, perform_at: 2.days.ago)
        expect(described_class.past).to eq [a, b]
      end

      it 'returns select records when QueuedTask#perform_at is in the future' do
        a = create(klass, perform_at: 1.day.from_now)
        b = create(klass, perform_at: 2.days.ago)
        c = create(klass, perform_at: 2.days.from_now)
        expect(described_class.past).to eq [b]
      end
    end

    describe '.future' do
      it 'defaults to an empty list' do
        expect(described_class.future).to eq []
      end

      it 'returns nothing when all QueuedTask#perform_at is in the past' do
        create(klass, perform_at: 1.day.ago)
        create(klass, perform_at: 2.days.ago)
        expect(described_class.future).to eq []
      end

      it 'returns select records when QueuedTask#perform_at is in the future' do
        a = create(klass, perform_at: 1.day.from_now)
        b = create(klass, perform_at: 2.days.ago)
        c = create(klass, perform_at: 2.days.from_now)
        expect(described_class.future).to eq [a, c]
      end
    end
  end

  describe '#unlocked?' do
    it :true do
      expect(build(klass, locked: false)).to be_unlocked
    end

    it :false do
      expect(build(klass, locked: true)).not_to be_unlocked
    end
  end

  describe '#stuck?' do
    context 'true' do
      it 'task is older than 30 minutes' do
        subject = create(klass, locked: false, created_at: 31.minutes.ago)
        expect(subject.stuck?).to be true
      end
    end

    context 'false' do
      it 'task is locked' do
        subject = create(klass, locked: true, created_at: 31.minutes.ago)
        expect(subject.stuck?).to be false
      end

      it 'task is less than 1 hour old' do
        subject = create(klass, locked: false, created_at: 25.minutes.ago)
        expect(subject.stuck?).to be false
      end
    end

    context 'when perform_at was set' do
      subject { create(klass, locked: false, created_at: 31.minutes.ago) }

      it 'returns false by default' do
        subject.perform_at = 1.hour.from_now
        expect(subject.stuck?).to be false
      end

      it 'returns true when perform_at is at least 30 minutes old' do
        subject.perform_at = 1.hour.ago
        expect(subject.stuck?).to be true
      end
    end
  end

  it '#respond_to?' do
    expect(subject).to respond_to(:lock!, :unlock!, :execute!)
  end
end
