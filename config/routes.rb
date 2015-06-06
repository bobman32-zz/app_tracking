Rails.application.routes.draw do

  devise_for :users

   get("/add_app", { :controller => "apptracking", :action => "add_app" })

   get("/add_android", { :controller => "apptracking", :action => "add_android" })

   get("/add_ios", { :controller => "apptracking", :action => "add_ios" })

   get("/apps_tracked", { :controller => "apptracking", :action => "apps_tracked" })

  get("/delete_app/:app_id", { :controller => "apptracking", :action => "delete_app" })

  get("/refresh_list", { :controller => "apptracking", :action => "refresh_list" })

  get("/week", { :controller => "apptracking", :action => "week" })

  get "/process_new_android/:androidid" => 'apptracking#new_android', :constraints => {:androidid => /[\w+\.]+/ }

root 'apptracking#apps_tracked'

end
