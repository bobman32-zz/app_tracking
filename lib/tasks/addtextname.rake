namespace :addtextname do
  desc "refresh app lists"
  task add_name: :environment do
    App.each do |app|
      if app.textname.nil?
        app.textname = app.versions.last.app_name
        puts app.textname
        app.save
      end
    end
  end
end

