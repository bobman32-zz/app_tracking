require 'open-uri'
require 'json'
require 'net/http'
require 'rubygems'
require 'market_bot'
require 'date'
require "uri"
require 'rubygems'


class ApptrackingController < ApplicationController


  def add_app
    @new_app = App.new
    @new_user_app_join=Join.new
    @new_user_app_join2=Join.new


  end
  def add_travel_apps

      a=[1,2,3,4,5,7,8,9,10,32,28,29,38,37,51,52,53,54,32,40,21,41,55,56,57,12,11,18,14,15,13,36,16,17,19,27,30,26,31,58,59,60,61,44,34,42,43,62,63,64,50,35]

      a.each do |app|
        b=Join.new
        b.app_id = app
        b.user_id = current_user.id
        b.save
      end
      redirect_to "/apps_tracked", :notice => "Travel Apps Added Sucessfully"
  end

  def app_details
    @app = App.find(params[:app_id])
    @app_versions = @app.versions


  end

  def delete_app
    app_id = params["app_id"].to_i
    user_id=current_user.id
    app = Join.find_by(:app_id => app_id, :user_id => user_id)
    app.destroy
    redirect_to "/apps_tracked", :notice => "App Deleted"

  end

  def apps_tracked
    @all_user_apps = current_user.apps.order(:textname).all


  end

  def add_android

    app_name = params["androidid"].gsub(" ","")

    package_url= "https://play.google.com/store/apps/details?id="+app_name+"&hl=en"

    uri = URI.parse(package_url)
    req = Net::HTTP.new(uri.host, uri.port)
    req.use_ssl = true
    req.verify_mode = OpenSSL::SSL::VERIFY_NONE
    res = req.get(uri.request_uri)
     if res.code =="200"
        redirect_to "/add_android_valid/"+app_name
      else
        redirect_to "/add_app", :alert => "Invalid Android Package Name"

      end
  end


  def add_android_valid

    app_name = params["androidid"]
    @new_app = App.new

    @new_user_app_join=Join.new

    if App.find_by(app_name: app_name).nil?
      @new_user_app_join=Join.new
      @new_app.app_name = app_name
      @new_app.os = "android"
      if @new_app.save
          @new_user_app_join.user_id=current_user.id
          @new_user_app_join.app_id=@new_app.id
          if @new_user_app_join.save
            redirect_to "/process_new_android/"+app_name, :notice => "App Added Successfully!" and return
            else
          end
        else
      end
        else
          @a=App.find_by(app_name: app_name)
          @new_user_app_join2=Join.new
          @new_user_app_join2.user_id=current_user.id
          @new_user_app_join2.app_id=@a.id
          if @new_user_app_join2.save
            redirect_to "/apps_tracked", :notice => "App Added Successfully!" and return
            else
          end
      end
      render 'add_app'
    end

# Refactor with this code below

 # @new_app = App.find_by(:app_name => app_name)
 # if @app == nil
 #   @app = App.new
 #   @app.app_name = app_name
 #   @app.os = "android"
 #   @app.save
 # end

 # @new_user_app_join = Join.new
 # @new_user_app_join.app_id = @app.id
 # @new_user_app_join.user_id = current_user.id

 # if @new_user_app_joine.save


  def new_android


    #OLD APP ANNIE API - has too many limitations
    # market = "google-play"
    # key = "477b1c9d58118eb7e59f82406f793f2d7998f955"
    # base_url= "https://api.appannie.com/v1.1/apps/"
    # full_url = base_url+market+"/app/"+app_id+"/details"
    # parsed_data = JSON.parse(open(full_url,
    #   "Authorization" => "bearer 477b1c9d58118eb7e59f82406f793f2d7998f955").read)
    # app_name= parsed_data["app"]["app_name"]
    # market= parsed_data["app"]["market"]
    # publisher_name= parsed_data["app"]["publisher_name"]
    # icon= parsed_data["app"]["icon"]
    # description= parsed_data["app"]["description"]
    # current_version= parsed_data["app"]["current_version"]
    # last_update= parsed_data["app"]["last_updates"]
    # category= parsed_data["app"]["main_category"]

    #Market_bot gem which is a Google Play scraper

    package_name = params["androidid"]
    app_bot = MarketBot::Android::App.new(package_name)
    app_bot.update

    a=App.find_by app_name: package_name
    app_id = a.id

    n=Version.new
      n.app_name = app_bot.title
      n.app_icon_url = app_bot.banner_icon_url
      n.market = app_bot.category
      n.publisher_name = app_bot.developer
      n.current_version = app_bot.current_version
      n.description = app_bot.description
      n.updated_date = DateTime.parse(app_bot.updated).strftime('%B %e, %Y ')
      n.whats_new = app_bot.whats_new
      n.rating = app_bot.rating
      n.app_id = app_id
    n.save

    a.textname=n.app_name
    a.save


    redirect_to "/apps_tracked"

  end

  def add_ios

    app_name = params["iosid"].gsub(" ","")

    id_url= "https://itunes.apple.com/us/app/orbitz-flights-hotels-cars/id"+app_name+"?mt=8"

    uri = URI.parse(id_url)
    req = Net::HTTP.new(uri.host, uri.port)
    req.use_ssl = true
    req.verify_mode = OpenSSL::SSL::VERIFY_NONE
    res = req.get(uri.request_uri)
     if res.code =="200"
        redirect_to "/add_ios_valid/"+app_name
      else
        redirect_to "/add_app", :alert => "Invalid ITunes App ID"

      end
  end

 def add_ios_valid
  app_name = params["iosid"]
    @new_app = App.new
    @new_user_app_join=Join.new

      if App.find_by(app_name: app_name).nil?
      @new_app= App.new
      @new_app.app_name = app_name
      @new_app.os = "ios"
      if @new_app.save
          @new_user_app_join=Join.new
          @new_user_app_join.user_id=current_user.id
          @new_user_app_join.app_id=@new_app.id
          if @new_user_app_join.save
            redirect_to "/process_new_ios/"+app_name, :notice => "App Added Successfully!" and return
            else
          end
        else
      end
        else
          @a=App.find_by(app_name: app_name)
          @new_user_app_join2=Join.new
          @new_user_app_join2.user_id=current_user.id
          @new_user_app_join2.app_id=@a.id
          if @new_user_app_join2.save
            redirect_to "/apps_tracked", :notice => "App Added Successfully!" and return
            else
          end
      end
      render 'add_app'
  end


  def new_ios
    ios_id = params["iosid"]

    a=App.find_by app_name: ios_id
    app_id = a.id


    parsed_data = JSON.parse(open("https://itunes.apple.com/lookup?id="+ios_id).read)

      n=Version.new
      n.app_name = parsed_data["results"][0]["trackName"]
      n.app_icon_url = parsed_data["results"][0]["artworkUrl60"]
      n.market = parsed_data["results"][0]["primaryGenreName"]
      n.publisher_name = parsed_data["results"][0]["sellerName"]
      n.current_version = parsed_data["results"][0]["version"]
      n.description = parsed_data["results"][0]["description"]
      n.updated_date = Time.zone.now.to_date.strftime('%B %e, %Y ')
      #search API currently doesn't provide updated date, so this just uses todays date assuming this action in run daily
      n.whats_new = parsed_data["results"][0]["releaseNotes"]
      n.rating = parsed_data["results"][0]["averageUserRating"]
      n.app_id = app_id
      n.save
    a.textname=n.app_name
    a.save

    redirect_to "/apps_tracked"
  end
  def history

    @today = Time.zone.now.to_date
    @yesterday =Time.zone.now.to_date-1.day
    @twodaysago=Time.zone.now.to_date-2.day
    @threedaysago=Time.zone.now.to_date-3.day
    @fourdaysago= Time.zone.now.to_date-4.day
    @fivedaysago= Time.zone.now.to_date-5.day
    @sixdaysago= Time.zone.now.to_date-6.day
    @sevendaysago= Time.zone.now.to_date-7.day
    @eightdaysago= Time.zone.now.to_date-8.day
    @ninedaysago= Time.zone.now.to_date-9.day
    @tendaysago= Time.zone.now.to_date-10.day


    @android_apps= current_user.apps.where({:os => 'android'})
    @ios_apps= current_user.apps.where({:os => 'ios'})

  def travel_apps
  end




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

