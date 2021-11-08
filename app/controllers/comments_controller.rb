class CommentsController < ApplicationController
  before_action :authenticate_user
  before_action :is_permitted_comment?, only: [:edit, :update, :destroy]

  def new
    @gossip = Gossip.find(params[:gossip_id]) 
    @comment = Comment.new
  end

  def create
    @gossip = Gossip.find(params[:gossip_id])
    @comment = Comment.new(content: params[:content], gossip_id: @gossip.id)
    @comment.user_id = current_user.id # associer le user connecté en tant qu'auteur

    if @comment.save
      redirect_to gossip_path(@gossip.id)
      flash[:success] = "Le commentaire a bien été ajouté"
    else
      render gossip_path(@gossip.id)
      flash[:warning] = @comment.errors.full_messages
    end
  end  

  def edit # passer les deux variables pour que le form_for puissent retrouver le gossip_comment_path
    @comment = Comment.find(params[:id])
    @gossip = Gossip.find(params[:gossip_id])
  end

  def update
    @gossip = Gossip.find(params[:gossip_id])
    @comment = Comment.find(params[:id])
    
    if @comment.update(content: params[:content])  
      redirect_to gossip_path(@gossip.id)
      flash[:success] = "Le commentaire a bien été modifié."
    else
      render :edit
      flash.now[:warning] = @comment.errors.full_messages
    end
  end
  
  def destroy 
    @gossip = Gossip.find(params[:gossip_id])
    @comment = Comment.find(params[:id])

    @comment.destroy
    redirect_to gossip_path(@gossip.id)
    flash[:success] = "Le Gossip a bien été supprimé."
  end
  
end
