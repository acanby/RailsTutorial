class UsersController < ApplicationController
	before_filter :authenticate, :only => [:edit, :update, :index, :destroy]
	before_filter :correct_user, :only => [:edit, :update]
	before_filter :admin_user, :only => :destroy
	before_filter :redirect_logged_in_user, :only => [:new,:create]
	
  def new
		@user = User.new
		@title = "Sign up"
  end

	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(:page => params[:page])
		@title = @user.name
	end
	
	def create
		@user = User.new(params[:user])
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to the Sample App!"
			redirect_to @user
		else
			@title = "Sign up"
			@user.password = @user.password_confirmation = ""
			render 'new'
		end
	end
	
	def edit
		@user = User.find(params[:id])
		@title = "Edit user"
	end
	
	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			flash[:success] = "Profile updated"
			redirect_to @user
		else
			@title = "Edit user"
			render 'edit'
		end
	end
	
	def index
		@title = "All users"
		@users = User.paginate(:page => params[:page])
	end
	
	def destroy
		@toDelete = User.find(params[:id])
		if @toDelete == @current_user
			flash[:notice] = "You cannot delete your own account"
		else
			@toDelete.destroy
			flash[:success] = "User destroyed"
		end
			redirect_to users_path
	end
	
	private
		
		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end
		
		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end
		
		def redirect_logged_in_user
			if signed_in?
				redirect_to @current_user 
			end
		end

end
