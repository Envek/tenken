Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :sites do
    post :check, on: :member
    resources :checks, only: [:index, :show]
  end

  root to: redirect('/sites')
end
