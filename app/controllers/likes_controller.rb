class LikesController < ApplicationController
  before_action :authenticate_user

  def new
  end

  def create
    @user = User.find_by(id: session[:user_id])
    @gossip = Gossip.find(params[:gossip_id])
    @user_gossip_likes = Like.where(user_id: @user.id, gossip_id: @gossip.id)
  
    @like = Like.new(user_id: @user.id, gossip_id: @gossip.id)

    if current_user == @user && @user_gossip_likes.count == 0 #NB : pourrait faire l'objet d'un LikesHelper "is_permitted_like?"
      @like.save # essaie de sauvegarder en base @gossip
      # si ça marche, il redirige vers la page d'index du site
      redirect_to gossip_path(@gossip.id)
      flash[:success] = "Like ajouté !"
    else
      # sinon, il render la view new (qui est celle sur laquelle on est déjà)
      redirect_to gossip_path(@gossip.id)
      flash[:warning] = "Impossible, vous avez déjà liké ce gossip"
    end
  end

  def destroy
  end
end
