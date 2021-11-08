module SessionsHelper
  
  # identifier plus rapidement l'utilisateur grâce aux sessions >>> à appeler à la page login mais aussi juste après la création d'un nouvel utilisateur (par exemple).
  def log_in(user) 
    session[:user_id] = user.id
  end

  # créer le cookie avec un token qui sera stocké dans le navigateur du user, et stocker de manière sécurisée dans le remember_digest en base de données
  def remember(user)
    # ici je vais créer un remember_token qui est une suite aléatoire de caractères
    remember_token = SecureRandom.urlsafe_base64
    # j'ai mon token, je vais stocker son digest en base de données via la méthode remember du model user :    
    user.remember(remember_token)
    #  maintenant, je vais créer les cookies : un cookie qui va conserver l'user_id, et un autre qui va enregistrer le remember_token
    cookies.permanent[:user_id] = user.id
    cookies.permanent[:remember_token] = remember_token
  end

  def current_user
    if session[:user_id] # vérifier s'il y a bien une session contenant l'id de notre utilisateur
      current_user = User.find_by(id: session[:user_id]) # trouver l'instance de User contenant les infos de ton utilisateur connecté
    elsif cookies[:user_id] # vérifier s'il y a bien un cookie contenant l'id de notre utilisateur
      user = User.find_by(id: cookies[:user_id]) # trouver l'utilisateur en DB à partir du cookie qui stocke le user_id
      if user && BCrypt::Password.new(user.remember_digest).is_password?(cookies[:remember_token]) # prendre le remember_token stocké en cookie, le hasher, puis le comparer avec notre remember_digest stocké en base
        log_in user # si tout est bon, il ne nous reste plus qu'à souhaiter bienvenue à l'utilisateur !
        current_user = user # et reconnaitre que le user trouvé avec la session est le même que celui trouvé avec le cookie 
      end
    end
  end

  # vérifier que l'utilisateur est bien connecté (par exemple pour ensuite lui donner accès à certaines views)
  def logged_in? #https://levelup.gitconnected.com/simple-authentication-guide-with-ruby-on-rails-16a6255f0be8  
    !current_user.nil? # autre solution >>> session[:user_id] ou session.key?(:user_id)
  end

  # vérifier que l'utilisateur est bien connecté (par exemple pour ensuite lui donner accès à certaines views)
  def authenticate_user
    unless current_user
      flash[:danger] = "Please log in."
      redirect_to new_session_path
    end
  end

  # effacer les cookies et remettre le remember_digest à nil.
  def forget(user)
    # on remet le remember_digest à nil puisqu'il ne nous servira plus :
    user.update(remember_digest: nil)
    # on efface les cookies dans le navigateur de l'utilisateur
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # méthode log_out(user) complète tenant compte de la destruction des cookies >>> à appeler dans la méthode destroy du sessions_controller
  def log_out(user)
    session.delete(:user_id)
    forget(user)
  end

end
