class App < ActiveRecord::Base
  validates :app_name, :presence => true
  validates :os, :presence => true

  has_many :versions
  has_many :joins, :foreign_key => "app_id"
  has_many :users, :through => :joins



end
