module CommentsHelper

  def is_permitted_comment?
    @gossip = Gossip.find(params[:gossip_id])
    @comment = Comment.find(params[:id])
    @user = User.find(@comment.user_id)
    unless current_user == @user
      flash[:danger] = "Vous n'êtes pas autorisé(e) à modifier ou supprimer ce commentaire"
      redirect_to gossip_path(@gossip.id)
    end
  end

end
