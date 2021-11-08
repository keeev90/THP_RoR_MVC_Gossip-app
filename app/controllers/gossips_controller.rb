class GossipsController < ApplicationController
  before_action :authenticate_user
  before_action :is_permitted_gossip?, only: [:edit, :update, :destroy]

  def index # Méthode qui récupère tous les potins et les envoie à la view index (index.html.erb) pour affichage
    puts "#" * 60
    puts "Home controller required to GET index.html.erb from home view"
    puts "#" * 60

    @gossips = Gossip.all #transmettre les données de la table gossips à la view (sous forme d'array de hashs)
  end

  def show # Méthode qui récupère le potin concerné et l'envoie à la view show (show.html.erb) pour affichage
    puts "#" * 60
    puts "Gossip controller required to GET show.html.erb from gossip view, with dynamic URL variable"
    puts  params[:id] #idem que params["gossip_id"] >>> récupérer la valeur contenue dans l'URL - à l'endroit où on a initialisé la variable dans un GET (i.e fichier routes/rb >>> gossip/:gossip_id) - stockée dans un hash temporaire "params" {"gossip_id"=>"valeur_dans_URL"} 
    puts "#" * 60

    @gossip = Gossip.find(params[:id]) #pour cibler le gossip concerné dans la base de donnée 
  end

  def new # Méthode qui crée un potin vide et l'envoie à une view qui affiche le formulaire pour 'le remplir' (new.html.erb)
    @gossip = Gossip.new #pour éviter une method error sur les alerts https://stackoverflow.com/questions/40192004/ruby-on-rails-undefined-method-errors-for-nilnilclass
  end

  def create
    # Méthode qui créé un potin à partir du contenu du formulaire de new.html.erb, soumis par l'utilisateur
    # pour info, le contenu de ce formulaire sera accessible dans le hash params (ton meilleur pote)
    # Une fois la création faite, on redirige généralement vers la méthode show (pour afficher le potin créé)
    puts "#" * 60
    puts "Ceci est le contenu de params :"
    puts params
    puts "#" * 60

    @gossip = Gossip.new(gossip_params) # création d'un nouveau gossip avec les données obtenues à partir du formulaire,
    @gossip.user = current_user #affecter l'auteur du gossip au user connecté via le session helper 
    if @gossip.save # essaie de sauvegarder en base @gossip
      redirect_to gossips_path
      flash[:success] = "Le Gossip a bien été créé."  # si ça marche, il redirige vers la page d'index du site, en passant par la route sélectionnée, donc ton app repart sur un controller, sa méthode, etc.
    else
      render :new # sinon, il render directement la view new (qui est celle sur laquelle on est déjà) tout en gardant les variables disponibles (notamment @gossip)
      flash[:warning] = @gossip.errors.full_messages

      puts "#" * 60
      puts "Ceci est le contenu de params :"
      puts @gossip.errors.full_messages
      puts "#" * 60
    end
    # doc Ruby pour redirect_to et render : https://guides.rubyonrails.org/layouts_and_rendering.html#using-render
    # doc pour Flash messages : https://www.rubyguides.com/2019/11/rails-flash-messages/
  end

  def edit # Méthode qui récupère le potin concerné et l'envoie à la view edit (edit.html.erb) pour affichage dans un formulaire d'édition
    @gossip = Gossip.find(params[:id])
  end

  # Focus sur form_for (à coder dans views)
  # Pour générer un formulaire qui correspond à un model en particulier, il y a une méthode qui s'appelle form_for. 
  # Cette méthode prend en paramètre l'enregistrement que vous souhaitez modifier (ici @gossip) et un block qui aura comme paramètre un FormBuilder, qui est un objet qui va nous permettre de générer les différents champs.

  def update 
    # Méthode qui met à jour le potin à partir du contenu du formulaire de edit.html.erb, soumis par l'utilisateur
    # pour info, le contenu de ce formulaire sera accessible dans le hash params
    # Une fois la modification faite, on redirige généralement vers la méthode show (pour afficher le potin modifié)
    @gossip = Gossip.find(params[:id])
    
    if @gossip.update(gossip_params)
      redirect_to gossip_path(@gossip.id)
      flash.now[:success] = "Le Gossip a bien été modifié."
    else
      flash.now[:warning] = @gossip.errors.full_messages
      render 'edit'
    end
  end

  def destroy 
    # Méthode qui récupère le potin concerné et le détruit en base
    # Une fois la suppression faite, on redirige généralement vers la méthode index (pour afficher la liste à jour)
    @gossip = Gossip.find(params[:id])
    @gossip.destroy
    redirect_to gossips_path
    flash[:success] = "Le Gossip a bien été supprimé."
  end

  private 
  
  def gossip_params
    params.require(:gossip).permit(:title, :content)
  end

end
