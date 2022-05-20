require 'rails_helper'

describe Plok::Operations::QueuedTasks::Process do
  describe '#execute!' do
    it 'raises an exception due to klass not having a valid #execute!' do
      task = create(:queued_task, klass: Object, locked: false)

      expect { task.execute! }.to raise_exception(ArgumentError)
      expect(task.locked?).to be false
    end

    it 'raises an exception when a destroyed record wants to process' do
      task = create(:queued_task, klass: Object, locked: false)
      task.destroy

      expect { task.execute! }.to raise_exception(FrozenError)
    end
  end
end
