FactoryBot.define do
  factory :queued_task do
    klass { 'SomeClass' }
    attempts { 0 }
  end
end
