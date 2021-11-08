class CitiesController < ApplicationController
  before_action :authenticate_user
  
  def show
    puts "#" * 60
    puts params[:id]
    puts "#" * 60

    @city = City.find(params[:id])
    @gossips = []
    Gossip.all.each do |gossip|
      if gossip.user.city_id == params[:id].to_i
        @gossips << gossip
      end
    end
  end

end
