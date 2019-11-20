Rails.application.routes.draw do
  get 'plok/version' => 'plok/version#show', defaults: { format: 'txt' }
end
