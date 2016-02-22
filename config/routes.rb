Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    resources :users, only: [:index, :show, :create]

    resources :games, only: [:index, :show, :create], shallow: true do
      resources :ships, only: [:create, :update]
      resources :shots, only: [:create]
    end
    match '/games/:id/accept', to: 'games#accept', via: [:post], as: 'game_accept'
    match '/games/:id/start', to: 'games#start', via: [:post], as: 'game_start'
    match '/games/:id/surrender', to: 'games#surrender', via: [:post], as: 'game_surrender'

  end
end
