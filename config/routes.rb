Rails.application.routes.draw do
  get '/' => 'site#root'

  get '/exchange/:currency' => 'exchange#index',
    constraints: {currency: /(btc|eth|ark|lisk|shift|oxy|zcoin|pivx|reddcoin|raiblocks)/}

  scope '/:locale' do
    root 'site#index'

    devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout'},
      controllers: { registrations: "registrations" }

    post '/newsletter' => 'site#newsletter', as: :newsletter
    post '/contacts' => 'site#contacts', as: :contacts
    match '/refund' => 'site#refund', via: [:get, :post], as: :refund

    get '/profile' => 'profile#index', as: :profile
    put '/profile' => 'profile#update'

    get '/profile/donations/history' => 'profile#donation_history', as: :donation_history

    get '/early-donations/:currency' => 'early_donations#new',
      constraints: {currency: /(btc|eth|oxy|ark|lisk|shift|zcoin|pivx|reddcoin|raiblocks)/}, as: :new_early_donation

    post '/early-donations/:currency' => 'early_donations#create',
      constraints: {currency: /(btc|eth|oxy|ark|lisk|shift|zcoin|pivx|reddcoin|raiblocks)/}, as: :early_donations
  end

  namespace :admin do
    resources :users, only: [:index, :edit, :update] do
      post '/suspend' => 'users#suspend', on: :member, as: :suspend
    end

    resources :contributions

    resources :btc_addresses, except: [:edit, :update]
    resources :eth_addresses, except: [:edit, :update]
    resources :zcoin_addresses, except: [:edit, :update]
    resources :pivx_addresses, except: [:edit, :update]
    resources :reddcoin_addresses, except: [:edit, :update]
  end
end
