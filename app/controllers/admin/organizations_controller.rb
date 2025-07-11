class Admin::OrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_organization, only: [:show]

  def index
    # Get all organizations where current user is an admin
    @organizations = current_user.organizations.joins(:memberships)
                                 .where(memberships: { user: current_user, role: :admin })
                                 .includes(:users, :memberships)
  end

  def show
    @members = @organization.users.includes(:memberships, :parental_consent)
                           .joins(:memberships)
                           .where(memberships: { organization: @organization })
                           .order(:name)
    
    # Analytics data
    @analytics = calculate_analytics(@members)
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    
    if @organization.save
      # Make current user an admin of the new organization
      Membership.create!(
        user: current_user,
        organization: @organization,
        role: :admin
      )
      
      redirect_to admin_organization_path(@organization), 
                  notice: 'Organization created successfully!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update_member_role
    @organization = current_user.organizations.joins(:memberships)
                                .where(memberships: { user: current_user, role: :admin })
                                .find(params[:id])
    
    membership = @organization.memberships.find_by(user_id: params[:user_id])
    
    if membership && membership.update(role: params[:role])
      redirect_to admin_organization_path(@organization), notice: 'Member role updated successfully.'
    else
      redirect_to admin_organization_path(@organization), alert: 'Failed to update member role.'
    end
  end

  private

  def require_admin
    unless admin?
      redirect_to root_path, alert: "Admins only."
    end
  end

  def set_organization
    @organization = current_user.organizations.joins(:memberships)
                                .where(memberships: { user: current_user, role: :admin })
                                .find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_organizations_path, alert: 'Organization not found or access denied.'
  end

  def organization_params
    params.require(:organization).permit(:name, :description)
  end

  def calculate_analytics(members)
    # Create a fresh query for role breakdown to avoid ORDER BY conflicts
    role_breakdown = @organization.memberships
                                  .joins(:user)
                                  .group(:role)
                                  .count
                                  .transform_keys { |key| Membership.roles.key(key) }
    
    {
      total_members: members.count,
      role_breakdown: role_breakdown,
      age_group_breakdown: members.group_by(&:age_group).transform_values(&:count),
      consent_pending: members.select { |user| 
        user.age && user.age < 13 && 
        (!user.parental_consent || !user.parental_consent.consent_granted?)
      }.count,
      minors_count: members.select { |user| user.age && user.age < 18 }.count
    }
  end
end 