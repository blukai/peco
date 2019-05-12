import
  sdl2/sdl,
  random

const
  ScreenW = 640
  ScreenH = 480

type
  Ball* = ref BallObj
  BallObj = object
    x, y: float
    radius*: float
    color*: sdl.Color
    vel_x, vel_y: float

proc launch*(ball: Ball) =
  ball.x = ScreenW.float/2 - ball.radius
  ball.y = ScreenH.float/2 - ball.radius

  ball.vel_x = 3
  ball.vel_y = 5

  if (rand(1'f) > 0.5):
    ball.vel_x *= -1

proc move*(ball: Ball, rect: ptr sdl.Rect) =
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

  rect.x = ball.x.int
  rect.y = ball.y.int
