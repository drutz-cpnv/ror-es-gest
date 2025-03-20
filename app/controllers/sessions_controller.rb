class SessionsController < Devise::SessionsController
  # Méthode créée pour vider complètement la réponse
  def clear_response
    response.headers["Content-Type"] = ""
    self.response_body = nil
  end

  # Surcharge de la méthode pour gérer la redirection après connexion
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    
    # Obtenir l'URL stockée ou l'URL par défaut
    stored_location = stored_location_for(resource_name)
    
    # Nettoyer la réponse avant la redirection pour éviter les problèmes d'affichage
    clear_response
    
    # Rediriger vers l'URL stockée ou l'URL par défaut avec un statut 302 (temporaire)
    if stored_location.present?
      redirect_to stored_location, status: :found
    else
      redirect_to after_sign_in_path_for(resource), status: :found
    end
  end
end 