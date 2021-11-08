class SessionsController < ApplicationController

  def new # pointer vers la view new (formulaire d'authentification)
  end

  def create # requis au moment de la génération du formulaire de la view new (récupération des params)
    # cherche s'il existe un utilisateur en base avec l’e-mail
    user = User.find_by(email: params[:email])
    # on vérifie si l'utilisateur existe bien ET si on arrive à l'authentifier (méthode bcrypt) avec le mot de passe 
    if user && user.authenticate(params[:password])
      # stocker l'id de l'utilisateur connecté dans session[:user_id] via la méthode du SessionHelper
      log_in(user)
      # si la checkbox est cochée, on va cuisiner le cookie pour l'utilisateur via la méthode du SessionHelper
      remember(user) if params[:remember_me]
      # redirige où tu veux, avec un flash ou pas
      redirect_to root_path
      flash[:success] = "Bienvenue, #{user.first_name} !"
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy # Déconnecter l'utilisateur. Cliquer sur le bouton "Se déconnecter" revient à supprimer le contenu de session[:user_id] et les cookies
    log_out(current_user)
    redirect_to root_path
  end
  
end
