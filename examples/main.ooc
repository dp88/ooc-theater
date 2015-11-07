use sdl2
use theater
import sdl2/[Core, Event]
import theater/[Theater, Scene, Actor, SpriteFont]

main: func (argc: Int, argv: CString*) {
  theater := Theater new("OOC Theater", 640, 480)
  theater scene = MyScene new()

  nextFrame := SDL getTicks()
  oldTime := 0
  newTime:= 0
  deltaTime := 0
  running := true
  event: SdlEvent
  rect: SdlRect

  rect x = 0
  rect y = 0

  while (running) {
    newTime = SDL getTicks()
    deltaTime = newTime - oldTime
    oldTime = newTime

    while (SdlEvent poll(event&)) {
      if (event type == SDL_QUIT) {
        running = false
      }
    }

    SDL getWindowSize(theater window, rect w&, rect h&)

    SDL renderClear(theater renderer)
    SDL setRenderDrawColor(theater renderer, 0, 0, 0, 255)
    SDL renderFillRect(theater renderer, rect&)

    theater scene render()
    theater scene update(deltaTime)

    SDL renderPresent(theater renderer)

    nextFrame += 16
    delay := nextFrame - SDL getTicks()

    if (delay > 10) {
      SDL delay(delay)
    }
  }

  SDL destroyRenderer(theater renderer)
  SDL destroyWindow(theater window)
  SDL quit()
}

MyScene: class extends Scene {
  sampleTexture: SdlTexture
  sampleFont: SpriteFont

  init: func () {
    super()

    sampleTexture = Theater getTextureFromImage("spritesheet.gif")
    fontChars := " !\"#$%&;()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{:}~"
    sampleFont = SpriteFont new(sampleTexture, 8, 0, 32, 16, fontChars)

    sampleText := sampleFont getText("Sample sprite text!", 16, 128, 240)
    this addActors(sampleText)

    titleRect: SdlRect
    titleRect x = 0
    titleRect y = 0
    titleRect w = 176
    titleRect h = 32
    title := Actor new(sampleTexture, titleRect, 352, 64)
    title x = -176
    title y = 24
    title anchor = "n"

    this addActor(title)
  }
}
