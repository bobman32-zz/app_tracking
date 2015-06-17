require 'open-uri'
require 'json'

namespace :refresh5 do
  desc "refresh app lists"
  task app_refresh: :environment do
    #refresh Android apps

    a=App.where({:os=> 'android'})
      a.each do |app|

        if app.id % 5 == 4

        package_name = app.app_name

          app_bot = MarketBot::Android::App.new(package_name)
          app_bot.update

          #checks for updated date. Version numbers are often 'varies by device'

          a=app_bot.updated
          a=a.to_date

          if app.versions.last.updated_date.to_date != a


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

              if n.current_version == 'Varies with device'
              app_id=n.app_id
              d = App.find(app_id)
              package_name = d.app_name
              doc = Nokogiri::HTML(open("http://downloader-apk.com/?id="+package_name))
                versions = doc.css('.baseinfo').text
                input_string = versions.delete(' ').delete("\n")
                str1_markerstring = "lastversionofthisappis"
                str2_markerstring = "thatrelease"
                version= input_string[/#{str1_markerstring}(.*?)#{str2_markerstring}/m, 1]
                puts version
                unless version.nil?
                  record.current_version = version
                  record.save
                end
              end

          end
        end
    end

    #refresh ios apps

    b=App.where({:os=> 'ios'})
      b.each do |app|
        if app.id % 5 == 4

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
          n.updated_date = Time.zone.now.to_date.strftime('%B %e, %Y ')
          #search API currently doesn't provide updated date, so this just uses todays date assuming this action in run daily
          n.whats_new = parsed_data["results"][0]["releaseNotes"]
          n.rating = parsed_data["results"][0]["averageUserRating"]
          n.app_id = app_id
          n.save
            else
          end
        else
      end
  end
end
end
