class Api::UsersController < ApplicationController
  def create
    @user = User.new(_user_params)

    begin
      success = @user.save!
    rescue ActiveRecord::ActiveRecordError => e
    end

    if success
      render json: @user, status: :created, format: 'json'
    else
      render json: {error: e.message}, status: :unprocessable_entity
    end
  end

  def show
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
    end

    if @user
      render json: @user
    else
      render json: {error: e.message}
    end
  end

  def index
    if params[:user_name]
      @users = User.where('user_name = ?', params[:user_name])
    elsif params[:offset] || params[:limit]
      offset = params[:offset] || 0
      limit = params[:limit] || 100
      @users = User.limit(limit).offset(offset)
    end
    #users = @users.map { |user| {id: user.id, user_name: user.user_name} }
    users = UserSerializer.collection(@users)
    render json: {users: users}
  end

  private
  def _user_params
    params.require(:user).permit(:user_name)
  end
end
