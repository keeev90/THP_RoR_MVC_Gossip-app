module GossipsHelper
  
  def is_permitted_gossip?
    @gossip = Gossip.find(params[:id])
    @user = User.find(@gossip.user_id)
    unless current_user == @user
      flash[:danger] = "Vous n'êtes pas autorisé(e) à modifier ou supprimer ce gossip"
      redirect_to gossip_path(@gossip.id)
    end
  end

end
