class Api::GamesController < ApplicationController
  before_action :_find_game, only: [:show, :update, :accept]
  before_action :_check_ownership, only: [:update]

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
    @game = Game.new(_create_params)
    @game.owner_id = current_user_id

    if @game.save
      render json: @game, status: :created
    else
      render json: {errors: @game.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def show
    render json: @game
  end

  def accept
    if @game.status != Game::PENDING ||
       @game.opponent_id != current_user_id ||
       (_update_params.has_key?('status') &&
         _update_params.fetch('status') != Game::SETUP)

      @errors << 'Opponent must accept game'
      return render json: {errors: @errors}, status: :unprocessable_entity
    end

    game_service = GameService.new(@game)
    begin
      #game_service.randomize_starting_player
      #game_service.update_status(_update_params.fetch('status'))
      game_service.do_setup_phase
      @game.save!
    rescue ActiveRecord::ActiveRecordError => e
      @errors << e.message
    end

    if @errors.empty?
      render json: @game
    else
      render json: {errors: @errors}, status: :unprocessable_entity
    end
  end

  private
  def _params(*attrs)
    params.require(:game).permit(*attrs)
  end

  def _create_params
    _params(:opponent_id)
  end

  def _update_params
    _params(:status)
  end

  def _find_game
    begin
      @game = Game.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      return render json: {errors: e.message}, status: :not_found
    end
  end
end
