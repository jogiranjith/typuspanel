Dummy::Application.routes.draw do

  devise_for :devise_users

  scope "admin", :module => :admin, :as => "admin" do
    get "settings" => "settings#index", :as => "settings"
    post "settings" => "settings#update"
  end

  root :to => redirect("/admin") unless Typus.subdomain

end
