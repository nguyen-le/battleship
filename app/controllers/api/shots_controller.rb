class Api::ShotsController < ApplicationController
  before_action :_find_game, only: [:create]

  def create
    if @game.status != Game::IN_PROGRESS
      @errors << 'Cant create Shot at this time'
    elsif @game.owner_id != current_user_id && @game.opponent_id != current_user_id
      @errors << 'You dont have the right to create this Shot'
    else
      game_service = GameService.factory(@game)
      begin
        @shot = game_service.build_shot(
          current_user,
          _create_params.fetch(:location)
        )
        game_service.process_player_dmg(@shot)
      rescue RuntimeError, ActiveRecord::ActiveRecordError => e
        @errors << e.message
      end
    end

    if @errors.empty?
      render json: @shot, status: :created
    else
      render json: {errors: @errors}, status: :unprocessable_entity
    end
  end

  private
  def _params(*attrs)
    params.require(:shot).permit(attrs)
  end

  def _create_params
    _params(:location)
  end

  def _find_game
    begin
      @game = Game.find(params[:game_id])
    rescue ActiveRecord::RecordNotFound => e
      return render json: {errors: e.message}, status: :not_found
    end
  end
end
