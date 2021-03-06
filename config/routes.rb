Twitfollowers::Application.routes.draw do
  resources :purchases

  get "login/index"

  resources :members

  resources :tweets

  resources :deals

  resources :orgs

  resources :categories

#  get "orgs/index"

#  get "list/index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
match 'getrealname' => 'list#getrealname'
match 'get_first_n_tweets' => 'list#get_first_n_tweets'
match 'get_search_results' => 'list#get_search_results'
match 'do_tweets_authcate' => 'tweets#authcate'
match 'tweets' => 'tweets#new'
match 'list_index' => 'list#index'
match 'login/authorized' => 'login#authorized'
match 'login' => 'login#new'
match 'logout' => 'login#logout'
match 'usetweet' => 'list#usetweet'
match 'get_latest_tweet' => 'list#get_latest_tweet'
match 'buy' => 'list#buy'
match 'done' => 'list#done'
match 'deal_mail' => 'dealmailer#deal_mail'
match 'update_email' => 'login#update_email'
match 'get_email' => 'login#get_email'
match 'register' => 'login#register'
match 'biz_around_me' => 'orgs#biz_around'

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
 root :to => "login#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
