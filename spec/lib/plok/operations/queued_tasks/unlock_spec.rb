require 'rails_helper'

describe Plok::Operations::QueuedTasks::Unlock do
  it '#execute!' do
    queued_task = create(:queued_task, locked: true)
    queued_task.unlock!

    expect(queued_task).not_to be_locked
  end
end
