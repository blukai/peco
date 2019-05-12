import
  sdl2/sdl,
  sdl2/sdl_gfx_primitives as gfx,
  ball as ball_system,
  paddle as paddle_system

const
  Title = "Peco"
  ScreenW = 640
  ScreenH = 480
  WindowFlags = 0
  RendererFlags = sdl.RendererAccelerated or sdl.RendererPresentVsync
  FrameRate = 60
  FrameRateInterval = 1000

type
  App = ref AppObj
  AppObj = object
    window*: sdl.Window
    renderer*: sdl.Renderer

var
  ball: ball_system.Ball
  paddle: paddle_system.Paddle

proc events(app: App): bool =
  result = true
  var event: sdl.Event
  while sdl.pollEvent(addr(event)) != 0:
    case event.kind:
      of sdl.Quit:
        return false
      of sdl.KeyDown:
        sdl.logInfo(sdl.LogCategoryApplication, "pressed %s", $event.key.keysym.sym)
        case event.key.keysym.sym:
          of sdl.KQ:
            return false
          else: discard
      of sdl.MouseMotion:
        paddle.move(event.motion.x - int(paddle.w / 2))
      else: discard

proc main() =
  if sdl.init(sdl.InitVideo) != 0:
    sdl.logCritical(sdl.LogCategoryError, "could not initialize sdl: %s", sdl.getError())
    return
  defer: sdl.quit()

  let app = App(window: nil, renderer: nil)

  app.window = sdl.createWindow(
    Title,
    sdl.WindowPosCentered,
    sdl.WindowPosCentered,
    ScreenW,
    ScreenH,
    WindowFlags)
  if app.window == nil:
    sdl.logCritical(sdl.LogCategoryError, "could not create window: %s", sdl.getError())
    return
  defer: app.window.destroyWindow()

  app.renderer = sdl.createRenderer(app.window, -1, RendererFlags)
  if app.renderer == nil:
    sdl.logCritical(sdl.LogCategoryError, "could not create renderer: %s", sdl.getError())
    return
  defer: app.renderer.destroyRenderer()

  if sdl.setRenderDrawColor(app.renderer, sdl.Color(r: 255, g: 128, b: 128)) != 0:
    sdl.logWarn(sdl.LogCategoryVideo, "could not set draw color: %s", sdl.getError())
    return

  sdl.logInfo(sdl.LogCategoryApplication, "sdl initialized successfully")

  var
    # fps info
    fps_lasttime, fps_current, fps_frames: uint32
    # fps limiter
    stime, etime, delta: uint32

  # entities

  ball = ball_system.Ball(radius: 10)
  ball.init()
  var ball_rect = sdl.Rect(
    x: cint(ball.x),
    y: cint(ball.y),
    w: int(ball.radius * 2),
    h: int(ball.radius * 2))

  paddle = paddle_system.Paddle(w: 100, h: 10)
  paddle.init()
  var paddle_rect = sdl.Rect(
    x: cint(paddle.x),
    y: cint(paddle.y),
    w: paddle.w,
    h: paddle.h,
  )

  while app.events():
    stime = sdl.getTicks()

    discard sdl.setRenderDrawColor(app.renderer, sdl.Color(r: 255, g: 128, b: 128))
    if app.renderer.renderClear() != 0:
      sdl.logWarn(sdl.LogCategoryVideo, "could not clear screen: %s", sdl.getError())
    # ----

    ball.move(paddle)
    ball_rect.x = int(ball.x)
    ball_rect.y = int(ball.y)
    discard sdl.setRenderDrawColor(app.renderer, sdl.Color(r: 255))
    discard app.renderer.renderDrawRect(addr(ball_rect))
    discard app.renderer.renderFillRect(addr(ball_rect))

    paddle_rect.x = int(paddle.x)
    discard sdl.setRenderDrawColor(app.renderer, sdl.Color(r: 255))
    discard app.renderer.renderDrawRect(addr(paddle_rect))
    discard app.renderer.renderFillRect(addr(paddle_rect))

    # ----
    app.renderer.renderPresent()
    # ----

    etime = sdl.getTicks()
    # fps info
    fps_frames += 1
    if fps_lasttime + FrameRateInterval < etime:
      fps_lasttime = etime
      fps_current = fps_frames
      fps_frames = 0
      sdl.logInfo(sdl.LogCategoryApplication, "fps: %d", fps_current)
    # fps limiter
    delta = etime - stime
    if delta < uint32(FrameRateInterval / FrameRate):
      sdl.delay(uint32(FrameRateInterval / FrameRate) - delta)

when isMainModule:
  main()
