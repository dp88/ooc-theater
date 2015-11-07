use sdl2
use theater
import sdl2/[Core, Event]
import theater/[Theater, Actor, SpriteFont]

main: func (argc: Int, argv: CString*) {
  Theater init("OOC Theater", 640, 480)
  Theater scene = MyScene new()

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

    SDL getWindowSize(Theater window, rect w&, rect h&)

    SDL renderClear(Theater renderer)
    SDL setRenderDrawColor(Theater renderer, 0, 0, 0, 255)
    SDL renderFillRect(Theater renderer, rect&)

    Theater scene render(0, 0)
    Theater scene update(deltaTime)

    SDL renderPresent(Theater renderer)

    nextFrame += 16
    delay := nextFrame - SDL getTicks()

    if (delay > 10) {
      SDL delay(delay)
    }
  }

  SDL destroyRenderer(Theater renderer)
  SDL destroyWindow(Theater window)
  SDL quit()
}

MyScene: class extends Actor {
  sampleTexture: SdlTexture
  sampleFont: SpriteFont

  init: func () {
    super()

    sampleTexture = Theater getTextureFromImage("spritesheet.gif")
    fontChars := " !\"#$%&;()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{:}~"
    sampleFont = SpriteFont new(sampleTexture, 8, 0, 32, 16, fontChars)

    sampleText := sampleFont getText("Sample sprite text!", 16, 128, 240)
    this addChildren(sampleText)

    titleRect: SdlRect
    titleRect x = 0
    titleRect y = 0
    titleRect w = 176
    titleRect h = 32
    title := Actor new()
    title buildFromTexture(sampleTexture, titleRect, 352, 64)
    title x = -176
    title y = 24
    title anchor = "n"

    this addChild(title)
  }
}
