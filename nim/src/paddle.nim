import sdl2/sdl

const
  ScreenW = 640
  ScreenH = 480

type
  Paddle* = ref PaddleObj
  PaddleObj = object
    x*, y*: int
    w*, h*: int

proc init_left*(pad: Paddle) =
  pad.x = 0
  pad.y = int((ScreenH - pad.h) / 2)

proc init_right*(pad: Paddle) =
  pad.x = ScreenW - pad.w
  pad.y = int((ScreenH - pad.h) / 2)

proc move*(pad: Paddle, y: int) =
  pad.y = y

  if y < 0:
    pad.y = 0
  elif pad.y > ScreenH - pad.h:
    pad.y = ScreenH - pad.h
