class Api::GamesController < ApplicationController
  def index
    offset = params[:offset] || 0
    limit = params[:limit] || 100

    @games =
      Game.select(:id, :status, :owner_id, :opponent_id, :winning_player_id)
        .limit(limit).offset(offset)
    @games = @games.where('owner_id = ?', params[:owner_id]) if params[:owner_id]
    @games = @games.where('opponent_id = ?', params[:opponent_id]) if params[:opponent_id]

    render json: {games: @games.to_a}
  end

  def create
    @game = Game.new(_game_params)

    if @game.save
      render json: @game, status: :created
    else
      render json: {error: @game.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def show
    begin
      @game = Game.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
    end

    if @game
      render json: @game
    else
      render json: {error: e.message}, status: :not_found
    end
  end

  private
  def _game_params
    params.require(:game).permit(:owner_id, :opponent_id)
  end
end
