class ProfileController < ApplicationController
  before_action :authenticate_user
  before_action :is_permitted?, only: [:edit, :update, :destroy]

  def show
    @user = current_user
  end

  def edit
  end 

  def update
  end 

  def destroy
  end
  
end
