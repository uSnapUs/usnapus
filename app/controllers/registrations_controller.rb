class RegistrationsController < Devise::RegistrationsController

  private
    def after_sign_up_path_for(resource)
      new_event_path
    end
  
end