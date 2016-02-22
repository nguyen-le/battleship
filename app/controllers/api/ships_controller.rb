class Api::ShipsController < ApplicationController
  before_action :_find_game, only: [:create]

  def create
    #GamePolicy
    if @game.status != Game::SETUP
      @errors << 'Cant create Ship at this time'
    elsif @game.owner_id != current_user_id && @game.opponent_id != current_user_id
      @errors << 'You dont have the right to create this Ship'
    else
      game_service = GameService.new(@game)
      begin
        @ship = game_service.build_ship(
          current_user,
          _create_params.fetch(:ship_type),
          _create_params.fetch(:location)
        )
        @ship.save!
      rescue RuntimeError, ActiveRecord::ActiveRecordError => e
        @errors << e.message
      end
    end

    if @errors.empty?
      render json: @ship, status: :created
    else
      render json: {errors: @errors}, status: :unprocessable_entity
    end
  end

  def update
  end

  private
  def _params(*attrs)
    params.require(:ship).permit(attrs)
  end

  def _create_params
    _params(:ship_type, location: [])
  end

  def _find_game
    begin
      @game = Game.find(params[:game_id])
    rescue ActiveRecord::RecordNotFound => e
      return render json: {errors: e.message}, status: :not_found
    end
  end
end
