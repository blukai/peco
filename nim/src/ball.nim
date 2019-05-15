import
  sdl2/sdl,
  paddle

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

  ball.vel_x = 5
  ball.vel_y = 3

proc move*(ball: Ball, left_pad: ptr Paddle, right_pad: ptr Paddle) =
  ball.x += ball.vel_x
  ball.y += ball.vel_y

  # collisions

  # top
  if ball.y <= 0:
    ball.vel_y *= -1
  # bottom
  elif ball.y >= ScreenH - 2 * ball.radius:
    ball.vel_y *= -1
  # left
  elif ball.x <= 0:
    ball.init()
  # right
  elif ball.x >= ScreenW - 2 * ball.radius:
    ball.init()

  # right paddle
  if int(ball.y) >= right_pad.y and int(ball.y) <= right_pad.y + right_pad.h and int(ball.x) + 2 * int(ball.radius) >= right_pad.x:
    ball.vel_x *= -1
  # right paddle
  elif int(ball.y) >= left_pad.y and int(ball.y) <= left_pad.y + left_pad.h and int(ball.x) <= left_pad.x + left_pad.w:
    ball.vel_x *= -1
