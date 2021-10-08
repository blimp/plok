Rails.application.routes.draw do
  get 'plok/version' => 'plok/version#show', defaults: { format: 'txt' }
  match '*path' => 'catch_all#resolve', via: :all
end
