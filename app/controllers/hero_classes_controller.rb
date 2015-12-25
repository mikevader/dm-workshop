class HeroClassesController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :admin_user, only: [:edit, :update, :destroy]

  def index
    @hero_classes = HeroClass.paginate(page: params[:page]).order('name')
  end

  def show
    @hero_class = HeroClass.find(params[:id])
    @spells = @hero_class.spells.paginate(page: params[:page])
  end

  def new
    @hero_class = HeroClass.new
  end
  
  def create
    @hero_class = HeroClass.new(hero_class_params)
    if @hero_class.save
      flash[:success] = "HeroClass created!"
      redirect_to hero_classes_url
    else
      render 'new'
    end
  end

  def edit
    @hero_class = HeroClass.find(params[:id])
  end
  
  def update
    @hero_class = HeroClass.find(params[:id])
    if @hero_class.update_attributes(hero_class_params)
      flash[:success] = "HeroClass udpated"
      redirect_to hero_classes_url
    else
      render 'edit'
    end
  end
  
  def destroy
    HeroClass.find(params[:id]).destroy
    flash[:success] = "HeroClass deleted"
    redirect_to hero_classes_url
  end

  private
  def hero_class_params
    params.require(:hero_class).permit(:name, :cssclass)
  end

  # Before filters

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless admin_user?
  end
end
