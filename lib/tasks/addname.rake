namespace :addname do
  desc "TODO"
  task addname: :environment do
    App.all.each do |app|
      if app.textname.nil?
        app.textname = app.versions.last.app_name
        puts app.textname
        app.save
      end
    end

  end

end
