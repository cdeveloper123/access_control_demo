class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :check_age_consent

  def index
    @user = current_user
    @user_age = @user.age
    @user_age_group = @user.age_group
    
    # Use helper methods from ApplicationController
    @membership = current_membership
    @organization = current_organization
    @user_role = @membership&.role
    
    # Check if user needs parental consent (this should not happen due to before_action, but kept for view logic)
    @needs_consent = age_blocked?
    
    # Get participation areas if user has access
    if @organization && !@needs_consent
      if admin? || moderator?
        # Admins and moderators see all activities by default
        @participation_areas = @organization.participation_areas.order(:title)
      else
        # Regular members see age-filtered activities
        @participation_areas = @organization.participation_areas
                                           .for_age(@user_age || 18) # Default to 18 if age is nil
                                           .order(:title)
      end
    else
      @participation_areas = []
    end
  end

  private

  def check_age_consent
    if age_blocked?
      redirect_to waiting_for_consent_path, alert: "You must wait for parental consent to proceed."
    end
  end
end 