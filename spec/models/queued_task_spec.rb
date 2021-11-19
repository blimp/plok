require 'rails_helper'

describe QueuedTask do
  let(:klass) { described_class.to_s.underscore.to_sym }
  subject { create(klass) }

  it_behaves_like :loggable

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

    describe '.in_past' do
      it 'defaults to an empty list' do
        expect(described_class.in_past).to eq []
      end

      it 'also returns nothing when QueuedTask#perform_at is blank!' do
        a = create(klass)
        b = create(klass)
        expect(described_class.in_past).to eq [a, b]
      end

      it 'returns nothing when all QueuedTask#perform_at is in the past' do
        a = create(klass, perform_at: 1.day.ago)
        b = create(klass, perform_at: 2.days.ago)
        expect(described_class.in_past).to eq [a, b]
      end

      it 'returns select records when QueuedTask#perform_at is in the future' do
        a = create(klass, perform_at: 1.day.from_now)
        b = create(klass, perform_at: 2.days.ago)
        c = create(klass, perform_at: 2.days.from_now)
        expect(described_class.in_past).to eq [b]
      end
    end

    describe '.in_future' do
      it 'defaults to an empty list' do
        expect(described_class.in_future).to eq []
      end

      it 'returns nothing when all QueuedTask#perform_at is in the past' do
        create(klass, perform_at: 1.day.ago)
        create(klass, perform_at: 2.days.ago)
        expect(described_class.in_future).to eq []
      end

      it 'returns select records when QueuedTask#perform_at is in the future' do
        a = create(klass, perform_at: 1.day.from_now)
        b = create(klass, perform_at: 2.days.ago)
        c = create(klass, perform_at: 2.days.from_now)
        expect(described_class.in_future).to eq [a, c]
      end
    end
  end

  it '#lock!' do
    task = create(klass, locked: false)
    task.lock!
    expect(task).to be_locked
  end

  it '#unlock!' do
    task = create(klass, locked: true)
    task.unlock!
    expect(task).not_to be_locked
  end

  describe '.queue' do
    context 'when adding a new task' do
      setup do
        described_class.queue(Object, foo: 'bar')
      end

      subject { described_class.last }

      it 'changes the task count by 1' do
        expect(described_class.count).to eq 1
      end

      it 'stores the correct klass' do
        expect(subject.klass).to eq 'Object'
      end

      it 'stores the correct data' do
        expect(subject.data).to eq({ foo: 'bar' })
      end

      it 'stores the default priority weight' do
        expect(subject.weight).to eq(0)
      end

      it 'stores a custom priority weight' do
        described_class.queue(Object, { foo: 'bar' }, 7)
        expect(subject.weight).to eq(7)
      end
    end

    it 'takes a given perform_at datetime into account' do
      date = DateTime.new(2021, 6, 1, 16)
      described_class.queue(Object, foo: 'bar', perform_at: date)
      expect(described_class.first.perform_at).to eq date
    end
  end

  describe '.queue_unless_already_queued' do
    context 'when adding a new task' do
      setup do
        described_class.queue_unless_already_queued Object, foo: 'bar'
      end

      it 'changes the task count by 1' do
        expect(described_class.count).to eq 1
      end

      it 'stores the correct klass' do
        expect(described_class.first.klass).to eq 'Object'
      end

      it 'stores the correct data' do
        expect(described_class.first.data).to eq({ foo: 'bar' })
      end
    end
  end

  it '#dequeue!' do
    task = described_class.queue Object, foo: 'bar'
    task.dequeue!
    expect(described_class.count).to eq 0
  end

  it '#process!' do
    task = create(klass, klass: Object, locked: false)
    expect { task.process! }.to raise_exception(ArgumentError)
    expect(task).not_to be_locked
  end

  it '#respond_to?' do
    expect(build(klass)).to respond_to(
      :lock!, :unlock!, :execute!, :dequeue!, :process!
    )
  end

  describe '#unlocked?' do
    it 'true' do
      subject.locked = false
      expect(subject.unlocked?).to be true
    end

    it 'false' do
      subject.locked = true
      expect(subject.unlocked?).to be false
    end
  end

  describe '#stuck?' do
    context 'true' do
      it 'task is over an hour old' do
        subject.locked = false
        subject.created_at = 31.minutes.ago
        expect(subject.stuck?).to be true
      end
    end

    context 'false' do
      it 'task is locked' do
        subject.locked = true
        subject.created_at = 31.minutes.ago
        expect(subject.stuck?).to be false
      end

      it 'task is less than 1 hour old' do
        subject.locked = false
        subject.created_at = 25.minutes.ago
        expect(subject.stuck?).to be false
      end
    end

    context 'when perform_at was set' do
      setup do
        # Normal true conditions apply
        subject.locked = false
        subject.created_at = 31.minutes.ago
      end

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
end
