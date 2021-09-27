Rails.application.routes.draw do
  get 'plok/version' => 'plok/version#show', defaults: { format: 'txt' }
  get '*path' => 'catch_all#resolve'
end
