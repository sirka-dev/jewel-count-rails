Rails.application.routes.draw do
  root :to => 'jewels#index'
  post "/" => 'jewels#index'
  # get 'jewels/index'
  # post 'jewels/index'

  # get 'jewels/show'

  post 'jewels/create'
  post 'jewels/filter'
  get 'jewels/restore' => "jewels#restore"
  get 'jewels/delete' => "jewels#delete"
  get 'jewels/count' => "jewels#count"
  get 'jewels/clear' => 'jewels#clear'
  get 'events' => 'events#index'
  post 'events/create' => 'events#create'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
