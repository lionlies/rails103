class GroupsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts
  end

  def create
    @group = current_user.groups.create(group_params)

    if @group.save
      current_user.join!(@group)
      redirect_to groups_path
    else
      render :new
    end
  end

  def edit
    @group = current_user.groups.find(params[:id])
  end

  def update
    @group = current_user.groups.find(params[:id])

    if @group.update(group_params)
      redirect_to groups_path, notice: "Group info updated!"
    else
      render :edit
    end
  end

  def destroy
    @group = current_user.groups.find(params[:id])
    @group.delete
    redirect_to groups_path, alert: "Group is deleted!"
  end

  def join
    @group = Group.find(params[:id])

    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "You've joined this group now."
    else
      flash[:warning] = "You are already in this group."
    end

    redirect_to group_path(@group)
  end

  def leave
    @group = Group.find(params[:id])

    if current_user.is_member_of?(@group)
      current_user.leave!(@group)
      flash[:alert] = "You've left this group."
    else
      flash[:warning] = "You weren't in this group yet!"
    end

    redirect_to group_path(@group)
  end

  private

  def group_params
    params.require(:group).permit(:title, :description)
  end
end
