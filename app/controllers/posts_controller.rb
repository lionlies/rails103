class PostsController < ApplicationController


  before_action :authenticate_user!
  before_action :find_group
  before_action :member_required, only: [:new, :create]

  def new
    @post = @group.posts.new
  end

  def create
    @post = @group.posts.build(post_params)
    @post.author = current_user

    if @post.save
      redirect_to group_path(@group), notice: "New post added!"
    else
      render :new
    end
  end

  def edit
    @group = Group.find(params[:group_id])
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])

    if @post.update(post_params)
      redirect_to group_path(@group), notice: "Post updated!"
    else
      render :edit
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
    redirect_to group_path(@group), alert: "Post deleted!"
  end

  private

  def member_required
    if !current_user.is_member_of?(@group)
      flash[:warning] = "Please join this group first."
      redirect_to group_path(@group)
    end
  end

  def post_params
    params.require(:post).permit(:content)
  end

  def find_group
    @group = Group.find(params[:group_id])
  end

end
