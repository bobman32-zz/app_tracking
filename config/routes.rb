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
  #contraints allows me to pass a dot in the param since android package names have one.

  get("/process_new_ios/:iosid", { :controller => "apptracking", :action => "new_ios" })

  get("/app_details/:app_id", { :controller => "apptracking", :action => "app_details" })

root 'apptracking#apps_tracked'

end
