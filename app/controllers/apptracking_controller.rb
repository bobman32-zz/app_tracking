require 'open-uri'
require 'json'
require 'net/http'

class ApptrackingController < ApplicationController

  def add_app
  end

  def new_android

market = "google-play"
app_id = params["androidid"]
key = "477b1c9d58118eb7e59f82406f793f2d7998f955"
base_url= "https://api.appannie.com/v1.1/apps/"
full_url = base_url+market+"/app/"+app_id+"/details"
 parsed_data = JSON.parse(open(full_url,
"Authorization" => "bearer 477b1c9d58118eb7e59f82406f793f2d7998f955").read)

app_name= parsed_data["app"]["app_name"]
market= parsed_data["app"]["market"]
publisher_name= parsed_data["app"]["publisher_name"]
icon= parsed_data["app"]["icon"]
description= parsed_data["app"]["description"]
current_version= parsed_data["app"]["current_version"]
last_update= parsed_data["app"]["last_updates"]
category= parsed_data["app"]["main_category"]

a=App.find_by app_name: app_id
app_id = a.id

n=Version.new
n.app_name = app_name
n.app_icon_url = icon
n.market = market
n.publisher_name = publisher_name
n.current_version = current_version
n.description = description
n.updated_date = last_update
n.app_id = app_id
n.save

redirect_to "/apps_tracked"

  end

  def refresh_list


  a=App.where({:user_id => current_user.id})
  a.each do |app|
    market = "google-play"
    app_id = app.app_name
    key = "477b1c9d58118eb7e59f82406f793f2d7998f955"
    base_url= "https://api.appannie.com/v1.1/apps/"
    full_url = base_url+market+"/app/"+app_id+"/details"
     parsed_data = JSON.parse(open(full_url,
    "Authorization" => "bearer 477b1c9d58118eb7e59f82406f793f2d7998f955").read)
    app_name= parsed_data["app"]["app_name"]
    market= parsed_data["app"]["market"]
    publisher_name= parsed_data["app"]["publisher_name"]
    icon= parsed_data["app"]["icon"]
    description= parsed_data["app"]["description"]
    current_version= parsed_data["app"]["current_version"]
    last_update= parsed_data["app"]["last_updates"]
    category= parsed_data["app"]["main_category"]

     if app.versions.last != current_version
        b=Version.new
        b.app_name = app_name
        b.app_icon_url = icon
        b.market = market
        b.publisher_name = publisher_name
        b.current_version = current_version
        b.description = description
        b.updated_date = last_update
        b.app_id = app_id
        b.save
      else
      end
    end
    redirect_to "/apps_tracked"
  end



  def delete_app
  app = App.find(params[:app_id])
  app.destroy
  redirect_to "/apps_tracked", :notice => "App Deleted"

  end

  def apps_tracked
    @all_android_apps = App.where({:user_id => current_user.id})
    @all_ios_apps = 0
    current_version= Version.maximum('current_version')

  end

  def add_android

    #url = URI.parse("http://www.googsdfsdfsle.com/")
    #req = Net::HTTP.new(url.host, url.port)
    #res = req.request_head(url.path)
    #if res.code =="200"

      app_name = params["androidid"]

      n= App.new
      n.app_name = app_name
      n.os = "android"
      n.user_id = current_user.id

      if n.save
        redirect_to "/process_new_android/"+app_name, :notice => "App Added Successfully!"
        else
        render 'add_app'
      end

  end

  def week

  @today = Time.now
  @yesterday =Time.now-1.day
  @twodaysago=Time.now-2.day
  @threedaysago=Time.now-3.day
  @fourdaysago= Time.now-4.day
  @fivedaysago= Time.now-5.day
  @sixdaysago= Time.now-6.day
  @sevendaysago= Time.now-7.day

  end
end


#market = "google-play"
#app_id = params["androidid"]
#key = "477b1c9d58118eb7e59f82406f793f2d7998f955"
#base_url= "https://api.appannie.com/v1.1/apps/"
#full_url = base_url+market+"/app/"+app_id+"/details"

 #parsed_data = JSON.parse(open(full_url,
#{}"Authorization" => "bearer 477b1c9d58118eb7e59f82406f793f2d7998f955").read)

#@app_name= parsed_data["app"]["app_name"]
#@market= parsed_data["app"]["market"]
#@publisher_name= parsed_data["app"]["publisher_name"]
#@icon= parsed_data["app"]["icon"]
#@description= parsed_data["app"]["description"]
#@current_version= parsed_data["app"]["current_version"]
#@last_update= parsed_data["app"]["last_updates"]
#@category= parsed_data["app"]["main_category"]



#end

