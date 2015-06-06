class App < ActiveRecord::Base
  #validates :app_name, :presence => true, :uniqueness => true
  #validates :os, :presence => true,

  has_many :versions

end
