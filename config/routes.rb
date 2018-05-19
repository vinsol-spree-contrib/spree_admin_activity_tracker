Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :time_line, only: [:index, :show]
  end
end
