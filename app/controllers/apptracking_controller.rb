require 'open-uri'
require 'json'
require 'net/http'
require 'rubygems'
require 'market_bot'
require 'date'

class ApptrackingController < ApplicationController

  def add_app
    @new_app = App.new
    @new_user_app_join=Join.new
    @new_user_app_join2=Join.new

  end

  def app_details
    @app = App.find(params[:app_id])
    @app_versions = @app.versions


  end


  def refresh_list

#refresh Android apps

    a=App.where({:user_id => current_user.id}).where({:os=> 'android'})
      a.each do |app|


        package_name = app.app_name

        app_bot = MarketBot::Android::App.new(package_name)
        app_bot.update

        #checks for updated date. Version numbers are often 'varies by device'

        if app.versions.last.updated_date != app_bot.updated
          app_id=app.id
          n=Version.new
          n.app_name = app_bot.title
          n.app_icon_url = app_bot.banner_icon_url
          n.market = app_bot.category
          n.publisher_name = app_bot.developer
          n.current_version = app_bot.current_version
          n.description = app_bot.description
          n.updated_date = app_bot.updated
          n.whats_new = app_bot.whats_new
          n.rating = app_bot.rating
          n.app_id = app_id
          n.save

          else
        end
    end

    #refresh ios apps

    b=App.where({:user_id => current_user.id}).where({:os=> 'ios'})
      b.each do |app|
        ios_id =app.app_name
        parsed_data = JSON.parse(open("https://itunes.apple.com/lookup?id="+ios_id).read)

        #checks for current_version since updated date is not available in Apple API

        if app.versions.last.current_version != parsed_data["results"][0]["version"]
        app_id=app.id
        n=Version.new
        n.app_name = parsed_data["results"][0]["trackName"]
        n.app_icon_url = parsed_data["results"][0]["artworkUrl60"]
        n.market = parsed_data["results"][0]["primaryGenreName"]
        n.publisher_name = parsed_data["results"][0]["sellerName"]
        n.current_version = parsed_data["results"][0]["version"]
        n.description = parsed_data["results"][0]["description"]
        n.updated_date = Date.today.strftime('%B %e, %Y ')
        #search API currently doesn't provide updated date, so this just uses todays date assuming this action in run daily
        n.whats_new = parsed_data["results"][0]["releaseNotes"]
        n.rating = parsed_data["results"][0]["averageUserRating"]
        n.app_id = app_id
        n.save
          else
        end
      end
    redirect_to "/apps_tracked"
  end



  def delete_app
    app_id = params["app_id"].to_i
    user_id=current_user.id
    app = Join.find_by(:app_id => app_id, :user_id => user_id)
    app.destroy
    redirect_to "/apps_tracked", :notice => "App Deleted"

  end

  def apps_tracked
    @all_android_apps = current_user.apps.all
    @all_ios_apps = 0


  end

  def add_android

    #My attempt to validate on whether package name is valid
    #url = URI.parse("http://www.googsdfsdfsle.com/")
    #req = Net::HTTP.new(url.host, url.port)
    #res = req.request_head(url.path)
    #if res.code =="200"

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

# app = App.find_by(:app_name => app_name)
# if app == nil
#   app = App.new
#   app.app_name = app_name
#   app.os = "android"
#   app.save
# end

# @user_app = UserApp.new
# @user_app.app_id = app.id
# @user_app.user_id = current_user.id

# if @user_app.save


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

    redirect_to "/apps_tracked"

  end

 def add_ios
  app_name = params["iosid"]

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
      n.updated_date = Date.today.strftime('%B %e, %Y ')
      #search API currently doesn't provide updated date, so this just uses todays date assuming this action in run daily
      n.whats_new = parsed_data["results"][0]["releaseNotes"]
      n.rating = parsed_data["results"][0]["averageUserRating"]
      n.app_id = app_id
      n.save

    redirect_to "/apps_tracked"
  end
  def week

    @today = Date.today
    @yesterday =Date.today-1.day
    @twodaysago=Date.today-2.day
    @threedaysago=Date.today-3.day
    @fourdaysago= Date.today-4.day
    @fivedaysago= Date.today-5.day
    @sixdaysago= Date.today-6.day
    @sevendaysago= Date.today-7.day

    @android_apps= current_user.apps.where({:os => 'android'})
    @ios_apps= current_user.apps.where({:os => 'ios'})



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

