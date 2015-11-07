use sdl2
import sdl2/[Core, Image]
import [Actor, Scene]

Theater: class {
  window: static SdlWindow
  renderer: static SdlRenderer
  scene: Scene

  pixelMod: static Int = 1

  init: func (title: String, width, height: Int) {
    SDL init(SDL_INIT_EVERYTHING)

    window = SDL createWindow(title,
      SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
      width, height, SDL_WINDOW_SHOWN|SDL_WINDOW_RESIZABLE)

    renderer = SDL createRenderer(window, -1,
      SDL_RENDERER_ACCELERATED|SDL_RENDERER_PRESENTVSYNC)
  }

  render: func () {
    scene render()
  }

  getTextureFromImage: static func (filename: String) -> SdlTexture {
    image := SDLImage load(filename)
    if (image == null) {
      "Error loading image, %s" printfln(SDL getError())
      exit(1)
    }
    texture := SDL createTextureFromSurface(renderer, image)
    SDL freeSurface(image)
    return texture
  }
}
