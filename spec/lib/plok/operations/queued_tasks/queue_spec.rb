require 'rails_helper'

describe Plok::Operations::QueuedTasks::Queue do
  describe '#execute!' do
    # returns the queued object
  end
end

# describe '.queue' do
#   context 'when adding a new task' do
#     setup do
#       described_class.queue(Object, foo: 'bar')
#     end
#
#     subject { described_class.last }
#
#     it 'changes the task count by 1' do
#       expect(described_class.count).to eq 1
#     end
#
#     it 'stores the correct klass' do
#       expect(subject.klass).to eq 'Object'
#     end
#
#     it 'stores the correct data' do
#       expect(subject.data).to eq({ foo: 'bar' })
#     end
#
#     it 'stores the default priority weight' do
#       expect(subject.weight).to eq(0)
#     end
#
#     it 'stores a custom priority weight' do
#       described_class.queue(Object, { foo: 'bar' }, 7)
#       expect(subject.weight).to eq(7)
#     end
#   end
#
#   it 'takes a given perform_at datetime into account' do
#     date = DateTime.new(2021, 6, 1, 16)
#     described_class.queue(Object, foo: 'bar', perform_at: date)
#     expect(described_class.first.perform_at).to eq date
#   end
# end
#
# describe '.queue_unless_already_queued' do
#   context 'when adding a new task' do
#     setup do
#       described_class.queue_unless_already_queued Object, foo: 'bar'
#     end
#
#     it 'changes the task count by 1' do
#       expect(described_class.count).to eq 1
#     end
#
#     it 'stores the correct klass' do
#       expect(described_class.first.klass).to eq 'Object'
#     end
#
#     it 'stores the correct data' do
#       expect(described_class.first.data).to eq({ foo: 'bar' })
#     end
#   end
# end
#
