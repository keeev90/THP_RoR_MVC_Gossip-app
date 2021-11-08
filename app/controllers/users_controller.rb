class UsersController < ApplicationController
  before_action :authenticate_user, only: [:show]
  #skip_before_action :verify_authenticity_token

  def new # pointer vers la view new (formulaire d'inscription)
    #@city_options = City.all.map { |city| city.name }.flatten # transmettre données à la liste de choix déroulant > ERROR : le form_tag (views new) ne prend pas en compte le choix user parmi la liste déroulante (cellule reste blanche)
  end 

  # focus sur map (idem que collect): https://www.rubyguides.com/2018/10/ruby-map-method/
  # focus sur flatten : https://apidock.com/ruby/Array/flatten

  def create
    # création d'un nouveau user avec les données obtenues à partir du formulaire
    @user = User.new(
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )
    @user.city = City.all.sample

    if @user.save # essaie de sauvegarder en base @user et @city
      log_in(@user) # stocker l'id de l'utilisateur connecté dans session[:user_id] via la méthode du SessionHelper
      remember(@user) if params[:remember_me]  # si la checkbox est cochée, on va cuisiner le cookie pour l'utilisateur via la méthode du SessionHelper
      flash[:success] = "Bienvenue, #{@user.first_name} !"
      redirect_to root_path
    else
      flash[:warning] = @user.errors.full_messages
      render :new # sinon, il render directement la view new (qui est celle sur laquelle on est déjà) tout en gardant les variables disponibles (notamment @gossip)
    end
  end
  
  def show
    @user = User.find(params[:id]) #pour cibler plus vite le user concerné dans la base de donnée 
  end

  private

  def user_params # https://stackoverflow.com/questions/18424671/what-is-params-requireperson-permitname-age-doing-in-rails-4
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

end
