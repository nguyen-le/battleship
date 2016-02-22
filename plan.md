Guidlines
---------
there are two grids (10 x 10)
  1. your zone + ships + opponents shots
  2. the shots youve taken against your opponent

there are 2 players, client-server, playing from browser
client contacts API to _START_, _PLAY_, and _COMPLETE_ game

- The state of the game should be persisted in an SQL-based database (PostgreSQL, MySQL, SQLite, etc)
- 2 players, 5 ships each (5, 4, 3, 3, 2)

The final deliverables we'd like are:
- The finished rails app
- A brief description of the series of API calls a hypothetical frontend would use to play a game from ship placement through victory/defeat.
- A short writeup of how the development went, how long it took you, any challenges you ran into, why you made the design decisions you did, etc.

Components
----------
```
Player {
  <int> id
  <str> user_name
}
Game {
  <int> id
  <int> player_a_id
  <int> player_b_id
  <int> current_attacker_id  # (if current_user.id != @current_attacker_id)
  <int> winning_player_id
  <str> status               # [PENDING, SETUP, IN PROGRESS, FINISHED] (only fire if @status is IN PROGRESS)
  <str> type                 # [STANDARD, MINI, LARGE]
}
PlayerState {
  <int> id
  <int> game_id
  <int> player_id
  <int> health
<jsonb> grid
        ex:
        {
          "a": [0,0,0,0,0,0],
          "b": [0,0,0,0,0,0],
          "c": [0,0,0,0,0,0],
          "d": [0,0,0,0,0,0],
          "e": [0,0,0,0,0,0],
          "f": [0,0,0,0,0,0],
        }
}
Ship {
  <int> id
  <int> game_id
  <int> player_id
  <str> ship_type
<jsonb> location
        ex:
        {
          "a1": 2,
          "b1": 0
        }
}
Shots {
  <int> id
  <int> game_id
  <int> user_id
  <int> receiving_player_id
  <str> location (ex: 'a1', 'b2')
}
```

#Steps
##Step 1
_DONE_
POST /users
Player A creates an account with their username

POST /users
Player B creates an account with their username


##Step 2
_DONE_
POST /games
Player A creates Game and with Player B username
Game 1 is created with Player A.id and Player B.id, status PENDING


##Step 2.1
_DONE_
`GET /users`
  used for finding your opponent
`GET /games`
  gives you your game data


##Step 3
_DONE_
PUT /games
Game 1 is accepted by Player B. status SETUP
Game 1 randomly chooses the current-attacker-id

##Step 3.1
_DONE_
via GameService:
  When Game is in SETUP, PlayerState is created


##Step 3.2a
_DONE_
create Ship model

`POST /games/:game_id/ships`
Game must be in status SETUP
Player A and Player B can now setup their Grid
Player A and Player B create their ships


##Step 3.2b
_DONE_
Game doesn't start until both players have ships


##Step 4
_DONE_
model Shot

`POST /games/:game_id/shots`
Player.id posting must be `Game.current_attacker_id`
Game is status IN PROGRESS

Shot.new with gameId, playerId, location
if Shot.valid?
  check if player has a ship at that location
  if Ship at location
    Opponent.health -= 1
    if Opponent.health == 0
      Game = FINISHED
      Game.winning_player_id = Player.id

find Game.Grid where `game_id == :game_id` AND `opponent_id == current_user.id`
if there is no shot with `grid_id`, `player_id`, `location`
  create Shot with `grid_id, player_id, location`
  update Grid to represent Shot
  check if the Shot landed on a Ship
else
  can't do that

##Step 5
_DONE_
player surrender
