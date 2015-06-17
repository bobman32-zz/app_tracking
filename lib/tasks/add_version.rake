namespace :add_version do
  desc "TODO"
  task add_version: :environment do

    App.all.each do |app|
      a= app.versions.last
      if a.current_version == 'Varies with device'
          package_name = app.app_name
          doc = Nokogiri::HTML(open("http://downloader-apk.com/?id="+package_name))
            versions = doc.css('.baseinfo').text
            input_string = versions.delete(' ').delete("\n")
            str1_markerstring = "lastversionofthisappis"
            str2_markerstring = "thatrelease"
            version= input_string[/#{str1_markerstring}(.*?)#{str2_markerstring}/m, 1]
            unless version.nil?
              a.current_version = version
              a.save
            end
      end
    end
  end

end
