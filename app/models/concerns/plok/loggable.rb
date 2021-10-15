module Plok::Loggable
  extend ActiveSupport::Concern

  included do
    has_many :logs, as: :loggable, dependent: :nullify
  end

  def html_identifier
    'logs-'.concat(self.class.to_s.underscore, '-', id.to_s)
  end

  def log(message, category = nil, data = {})
    data = data.permit!.to_h if data.is_a?(ActionController::Parameters)

    logs.create!(
      content: message,
      category: category,
      data: data
    )
  end
end
