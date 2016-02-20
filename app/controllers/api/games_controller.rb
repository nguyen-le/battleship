class Api::GamesController < ApplicationController
  def create
    @game = Game.new(_game_params)

    begin
      success = @game.save!
    rescue ActiveRecord::ActiveRecordError => e
      error_msg = e.message
    end

    if success
      render json: GameSerializer.new(@game), status: :created
    else
      render json: {error: error_msg}, status: :unprocessable_entity
    end
  end

  private
  def _game_params
    params.require(:game).permit(:owner_id, :opponent_id)
  end
end
