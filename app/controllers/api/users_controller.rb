class Api::UsersController < ApplicationController
  def index
    offset = params[:offset] || 0
    limit = params[:limit] || 100

    @users = User.select(:id, :user_name).limit(limit).offset(offset)
    @users = @users.where('user_name = ?', params[:user_name]) if params[:user_name]

    render json: {users: @users.to_a}
  end

  def create
    @user = User.new(_create_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def show
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      return render json: {errors: e.message}, status: :not_found
    end

    render json: @user
  end

  private
  def _params(*attrs)
    params.require(:user).permit(attrs)
  end

  def _create_params
    _params(:user_name)
  end

end
