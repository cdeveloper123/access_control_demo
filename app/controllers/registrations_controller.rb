class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?

    if resource.persisted?
      # Create organization membership
      if params[:user][:organization_id].present?
        organization = Organization.find(params[:user][:organization_id])
        Membership.create!(
          user: resource,
          organization: organization,
          role: :member
        )
      end

      # Handle parental consent for users under 13
      if resource.age && resource.age < 13
        if params[:user][:parent_email].present?
          parental_consent = ParentalConsent.create!(
            user: resource,
            parent_email: params[:user][:parent_email]
          )
          
          # Send the consent email
          ParentalConsentMailer.consent_request(parental_consent).deliver_now
          
          # Redirect to waiting for consent page
          set_flash_message! :notice, :signed_up_but_waiting_consent
          sign_up(resource_name, resource)
          respond_with resource, location: waiting_for_consent_path
        else
          # Parent email is required for users under 13
          resource.errors.add(:parent_email, "is required for users under 13")
          clean_up_passwords resource
          set_minimum_password_length
          respond_with resource
        end
      else
        # Normal registration flow for users 13 and older
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up if is_flashing_format?
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
          expire_data_after_sign_in!
          respond_with resource, location: new_session_path(resource_name)
        end
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :date_of_birth, :organization_id, :parent_email])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :date_of_birth])
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :date_of_birth, :organization_id, :parent_email)
  end
end 