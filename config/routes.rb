Rails.application.routes.draw do
  root :to => 'jewels#index'
  # get 'jewels/index'

  # get 'jewels/show'

  get 'jewels/create'
  get 'jewels/restore' => "jewels#restore"
  get 'jewels/delete' => "jewels#delete"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
