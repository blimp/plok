require 'rails_helper'

describe Plok::Operations::QueuedTasks::Lock do
  it '#execute!' do
    queued_task = create(:queued_task, locked: false)
    queued_task.lock!

    expect(queued_task).to be_locked
  end
end
