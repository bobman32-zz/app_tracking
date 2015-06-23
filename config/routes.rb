Rails.application.routes.draw do

  devise_for :users

   get("/add_app", { :controller => "apptracking", :action => "add_app" })



 get("/travel_apps", { :controller => "apptracking", :action => "travel_apps" })

  get("/apps_tracked", { :controller => "apptracking", :action => "apps_tracked" })

  get("/delete_app/:app_id", { :controller => "apptracking", :action => "delete_app" })

  get("/refresh_list", { :controller => "apptracking", :action => "refresh_list" })

  get("/history", { :controller => "apptracking", :action => "history" })

#android routes

  get("/add_android", { :controller => "apptracking", :action => "add_android" })

  get("/add_android_valid/:androidid" => 'apptracking#add_android_valid', :constraints => {:androidid => /[\w+\.]+/})

  get("/process_new_android/:androidid" => 'apptracking#new_android', :constraints => {:androidid => /[\w+\.]+/})
  #contraints allows me to pass a dot in the param since android package names have one.

#ios routes

  get("/add_ios", { :controller => "apptracking", :action => "add_ios" })

  get("/add_ios_valid/:iosid", { :controller => "apptracking", :action =>"add_ios_valid"})

  get("/process_new_ios/:iosid", { :controller => "apptracking", :action => "new_ios" })

   get("/add_travel_apps", { :controller => "apptracking", :action => "add_travel_apps" })




  get("/app_details/:app_id", { :controller => "apptracking", :action => "app_details" })

root 'apptracking#history'

end
