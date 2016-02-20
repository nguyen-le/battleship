class Api::UsersController < ApplicationController
  def create
    @user = User.new(_user_params)

    begin
      success = @user.save!
    rescue ActiveRecord::RecordInvalid => e
      error_msg = e.message
    end

    if success
      render json: UserSerializer.new(@user), status: :created, format: 'json'
    else
      render json: {error: error_msg}, status: :unprocessable_entity
    end
  end

  private
  def _user_params
    params.require(:user).permit(:user_name, :name)
  end
end
