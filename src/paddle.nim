import sdl2/sdl

const
  ScreenW = 640
  ScreenH = 480

type
  Paddle* = ref PaddleObj
  PaddleObj = object
    x*, y*: int
    w*, h*: int

proc init*(pad: Paddle) =
  pad.x = int((ScreenW - pad.w) / 2)
  pad.y = ScreenH - pad.h

proc move*(pad: Paddle, x: int) =
  pad.x = x

  if x < 0:
    pad.x = 0
  elif pad.x > ScreenW - pad.w:
    pad.x = ScreenW - pad.w
