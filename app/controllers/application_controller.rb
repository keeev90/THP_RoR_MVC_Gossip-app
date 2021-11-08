class ApplicationController < ActionController::Base # Tous les controllers héritent de ApplicationController
  include SessionsHelper # inclure dans tous les controllers le helper "SessionsHelper" créé dans le fichier app/helpers/sessions_helper.rb
  include GossipsHelper
  include CommentsHelper
end
