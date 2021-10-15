require 'rails_helper'

shared_examples_for :loggable do
  let(:klass) { described_class.to_s.underscore.to_sym }

  it :logs do
    a = create(klass)
    a.log 'foo'
    expect(a.logs.count).to be >= 1
    expect(a.logs.unscoped.last.content).to eq 'foo'
  end

  it '#html_identifier' do
    expect(subject.html_identifier).to eq "logs-#{subject.class.to_s.underscore}-#{subject.id}"
  end

  it '#respond_to?' do
    expect(subject).to respond_to(:logs, :log)
  end
end
