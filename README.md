# Theater for ooc
Theater is a simple [ooc](https://ooc-lang.org) library, ported from an old Go project, which pairs with SDL2 to make sprite management slightly easier. It still lacks a number of basic features, like animations, rotation, etc. But it also contains a few useful features like built-in support for sprite-based fonts and nested game objects (known as Actors).

## Dependencies
Theater requires the SDL2 and corresponding SDL2 Image library to be installed.

On OS X via [Homebrew](http://brew.sh):
```bash
brew install sdl2{,_image}
```

On Linux (depending on distro):
```bash
apt-get install libsdl2{,-image}-dev
```
or
```bash
yum install SDL2{,_image}-devel
```

## Components
### Theater
```ooc
Theater: class {
  // Properties
  window: static SdlWindow
  renderer: static SdlRenderer
  scene: static Actor

  // Methods
  init: static func (title: String, width, height: Int)

  getTextureFromImage: static func (filename: String) -> SdlTexture
}
```

### Actor
```ooc
Actor: class {
  // Properties
  texture: SdlTexture
  sourceRect: SdlRect
  x: Int = 0
  y: Int = 0
  width, height: Int
  zIndex: Int = 0
  transparency: Float = 1.0
  anchor: String = ""
  scale: Float = 1.0
  updateMethod: Func(Int)
  click: Func
  childActors: ArrayList<Actor*>

  // Methods
  init: func ()

  buildFromTexture: func (=texture, =sourceRect, =width, =height)

  getRealSize: func () -> (Int, Int)

  getRealLocation: func () -> (Int, Int)

  render: func (ox, oy: Int)

  update: func (deltaTime: Int)

  checkInBounds: func (x, y: Int) -> Bool

  addChild: func (child: Actor)

  addChildren: func (children: ArrayList<Actor>)
}
```

### SpriteFont
```ooc
SpriteFont: class {
  // Properties
  texture: SdlTexture
  keymap: HashMap<Char, SdlRect>

  // Methods
  init: func (=texture, size, x, y, columns: Int, chars: String)

  getText: func (text: String, size, x, y: Int) -> Actor
}
```
