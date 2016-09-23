Rails.application.routes.draw do
  root :to => 'jewels#index'
  post "/" => 'jewels#index'
  # get 'jewels/index'
  # post 'jewels/index'

  # get 'jewels/show'

  get 'jewels/create'
  get 'jewels/restore' => "jewels#restore"
  get 'jewels/delete' => "jewels#delete"
  get 'jewels/count' => "jewels#count"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
