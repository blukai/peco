import sdl2/sdl

const
  ScreenW = 640
  ScreenH = 480

type
  Ball* = ref BallObj
  BallObj = object
    x*, y*: float
    radius*: float
    vel_x, vel_y: float

proc init*(ball: Ball) =
  ball.x = float(ScreenW) / 2 - ball.radius
  ball.y = float(ScreenH) / 2 - ball.radius

  ball.vel_x = 3
  ball.vel_y = 5

proc move*(ball: Ball) =
  ball.x += ball.vel_x
  ball.y += ball.vel_y

  # top
  if ball.y <= 0:
    ball.vel_y *= -1
  # right
  if ball.x >= ScreenW - 2 * ball.radius:
    ball.vel_x *= -1
  # bottom
  if ball.y >= ScreenH - 2 * ball.radius:
    ball.vel_y *= -1
  # left
  if ball.x <= 0:
    ball.vel_x *= -1
