Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    resources :users, only: [:index, :show, :create]

    resources :games, only: [:index, :show, :create], shallow: true do
      resources :ships, only: [:create, :update]
    end
    match '/games/:id/accept', to: 'games#accept', via: [:put]

  end
end
