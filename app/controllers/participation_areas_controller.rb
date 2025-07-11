class ParticipationAreasController < ApplicationController
  before_action :authenticate_user!
  before_action :require_organization_member
  before_action :set_participation_area, only: [:show, :edit, :update, :destroy]
  before_action :require_moderator_or_admin_for_creation, only: [:new, :create]
  before_action :require_moderator_or_admin_for_edit, only: [:edit, :update, :destroy]

  def index
    @participation_areas = current_organization.participation_areas
                                              .order(:min_age, :title)
                                              .includes(:organization)
    @user_age = current_user.age || 18
    
    # Admins and moderators see all activities by default, members see age-filtered
    if moderator_or_admin? && !params[:show_my_age].present?
      @age_appropriate_areas = @participation_areas
      @showing_all = true
    else
      @age_appropriate_areas = @participation_areas.for_age(@user_age)
      @showing_all = false
    end
    
    @all_areas_count = @participation_areas.count
    @user_can_create = moderator_or_admin?
  end

  def show
    @can_edit = can_edit_activity?(@participation_area)
  end

  def new
    @participation_area = current_organization.participation_areas.build
    set_age_group_suggestions
  end

  def create
    @participation_area = current_organization.participation_areas.build(participation_area_params)
    
    if @participation_area.save
      redirect_to @participation_area, notice: '🎉 Activity created successfully! Members can now participate.'
    else
      set_age_group_suggestions
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    set_age_group_suggestions
  end

  def update
    if @participation_area.update(participation_area_params)
      redirect_to @participation_area, notice: '✅ Activity updated successfully!'
    else
      set_age_group_suggestions
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @participation_area.destroy
    redirect_to participation_areas_path, notice: '🗑️ Activity deleted successfully.'
  end

  private

  def set_participation_area
    @participation_area = current_organization.participation_areas.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to participation_areas_path, alert: 'Activity not found or access denied.'
  end

  def participation_area_params
    params.require(:participation_area).permit(:title, :content, :min_age, :max_age)
  end

  def require_organization_member
    unless current_organization
      redirect_to dashboard_path, alert: 'You must be a member of an organization to manage activities.'
    end
  end

  def require_moderator_or_admin_for_creation
    unless moderator_or_admin?
      redirect_to participation_areas_path, alert: 'Only moderators and admins can create activities.'
    end
  end

  def require_moderator_or_admin_for_edit
    unless moderator_or_admin?
      redirect_to participation_areas_path, alert: 'Only moderators and admins can edit or delete activities.'
    end
  end

  def member_or_above?
    current_membership&.member? || current_membership&.moderator? || current_membership&.admin?
  end

  def moderator_or_admin?
    current_membership&.moderator? || current_membership&.admin?
  end

  def can_edit_activity?(activity)
    moderator_or_admin?
  end

  def set_age_group_suggestions
    @age_groups = {
      'Children (5-12)' => { min: 5, max: 12 },
      'Teens (13-17)' => { min: 13, max: 17 },
      'Adults (18+)' => { min: 18, max: 99 },
      'Young Adults (18-30)' => { min: 18, max: 30 },
      'All Ages (5+)' => { min: 5, max: 99 },
      'Seniors (65+)' => { min: 65, max: 99 }
    }
  end

  # Make helper methods available in views
  helper_method :member_or_above?, :moderator_or_admin?, :can_edit_activity?
end
