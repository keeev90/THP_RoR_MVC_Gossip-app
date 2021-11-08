class WelcomeController < ApplicationController
  before_action :authenticate_user

  def show
    puts "#" * 60
    puts "Welcome controller required to GET show.html.erb from welcome view, with dynamic URL variable" #récupérer la valeur contenue dans l'URL - à l'endroit où on a initialisé la variable dans un GET (i.e fichier routes/rb >>> gossip/:gossip_id) - et stockée dans un hash temporaire "params",
    puts  params[:user_first_name]
    puts "#" * 60
  end
  
end
