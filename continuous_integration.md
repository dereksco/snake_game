
# tests/test_snake_game.py

import pytest
from snake_game import Snake, Game

def test_initial_snake_position():
    snake = Snake(start_pos=(5, 5))
    assert snake.body == [(5, 5)]
    assert snake.direction == "RIGHT"
    assert snake.score == 0

def test_snake_movement_right():
    snake = Snake(start_pos=(0, 0))
    snake.move()
    assert snake.body == [(1, 0)] # Moved right

def test_snake_movement_up():
    snake = Snake(start_pos=(5, 5))
    snake.change_direction("UP")
    snake.move()
    assert snake.body == [(5, 4)] # Moved up

def test_snake_cannot_reverse_direction():
    snake = Snake(start_pos=(5,5))
    snake.change_direction("LEFT") # Current direction is LEFT
    snake.change_direction("RIGHT") # Try to reverse
    assert snake.direction == "LEFT" # Should still be LEFT

def test_snake_grows_on_eating_food():
    game = Game(width=10, height=10)
    game.snake = Snake(start_pos=(1, 0)) # Position snake to eat food
    game.place_food() # Food is at (1,1)
    game.snake.change_direction("DOWN") # Move towards food

    initial_length = len(game.snake.body)
    initial_score = game.snake.score

    game.update_game_state() # Snake moves and eats food

    assert len(game.snake.body) == initial_length + 1
    assert game.snake.score == initial_score + 1
    assert game.food_pos is not None # New food should be placed

def test_game_over_on_wall_collision():
    game = Game(width=10, height=10)
    game.snake = Snake(start_pos=(0,0)) # Snake at top-left corner
    game.snake.change_direction("LEFT") # Try to move out of bounds

    game_active = game.update_game_state()
    assert game.game_over is True
    assert game_active is False

def test_game_over_on_self_collision():
    game = Game(width=3, height=3) # Small board for easy collision
    game.snake = Snake(start_pos=(1,1))
    # Make snake long enough to collide with itself immediately
    game.snake.body = [(1,1), (1,2), (0,2), (0,1), (0,0), (1,0)] # A loop
    game.snake.change_direction("RIGHT") # Next move will hit (1,1)

    game_active = game.update_game_state()
    assert game.game_over is True
    assert game_active is False
