use sdl2
import sdl2/[Core]
import Theater
import structs/ArrayList

Actor: class {
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

  init: func () {
    updateMethod = func (deltaTime: Int) {}
    childActors = ArrayList<Actor*> new()
  }

  buildFromTexture: func (=texture, =sourceRect, =width, =height)

  getRealSize: func () -> (Int, Int) {
    width, height: Int

    if (scale != 1.0) {
      width = width * scale
      height = height * scale
    } else {
      width = this width
      height = this height
    }

    return (width, height)
  }

  getRealLocation: func () -> (Int, Int) {
    rx := x
    ry := y
    windowWidth, windowHeight: Int
    SDL getWindowSize(Theater window, windowWidth&, windowHeight&)

    (w, h) := getRealSize()

    if (anchor == "center") {
      rectX := (windowWidth / 2) - (w / 2)
      rectY := (windowHeight / 2) - (h / 2)
      rx += rectX
      ry += rectY
    }
    if (anchor == "n") {
      rectX := (windowWidth / 2) - (w / 2)
      rx += rectX
    }
    if (anchor == "ne") {
      rightX := windowWidth - w
      rx += rightX
    }
    if (anchor == "w") {
      rectY := (windowHeight / 2) - (h / 2)
      ry += rectY
    }
    if (anchor == "e") {
      rectY := (windowHeight / 2) - (h / 2)
      rightX := windowWidth - w
      rx += rightX
      ry += rectY
    }
    if (anchor == "sw") {
      lowY := windowHeight - h
      ry += lowY
    }
    if (anchor == "s") {
      rectX := (windowWidth / 2) - (w / 2)
      lowY := windowHeight - h
      rx += rectX
      ry += lowY
    }
    if (anchor == "se") {
      rightX := windowWidth - w
      lowY := windowHeight - h
      rx += rightX
      ry += lowY
    }

    return (rx, ry)
  }

  render: func (ox, oy: Int) {
    destination: SdlRect

    (x, y) := getRealLocation()
    (w, h) := getRealSize()

    pm := Theater pixelMod
    if (pm != 1) {
      while (x % pm != 0) x -= 1
      while (y % pm != 0) y -= 1
    }

    destination w = width
    destination h = height

    if (anchor != "") {
      // Anchored actors don't move relative to the camera
      destination x = x
      destination y = y
    } else {
      destination x = x + ox
      destination y = y + oy
    }

    if (transparency > 1.0) {
      transparency = 1.0
    }
    if (transparency < 0.0) {
      transparency = 0.0
    }

    SDL setTextureAlphaMod(texture, transparency * 255)
    SDL renderCopy(Theater renderer, texture, sourceRect&, destination&)

    if (childActors getSize() > 0) {
      newOffsetX := x + ox
      newOffsetY := y + oy
      childActors each(|child| child render(newOffsetX, newOffsetY) )
    }
  }

  update: func (deltaTime: Int) {
    updateMethod(deltaTime)

    if (childActors getSize() > 0) {
      childActors each(|child| child update(deltaTime) )
    }
  }

  checkInBounds: func (x, y: Int) -> Bool {
    (realX, realY) := getRealLocation()
    (realW, realH) := getRealSize()
    lowX := realX
    highX := realX + realW
    lowY := realY
    highY := realY + realH

    if ((x >= lowX && x <= highX) && (y >= lowY && y <= highY)) {
      return true
    }

    return false
  }

  addChild: func (child: Actor) {
    childActors add(child)
  }

  addChildren: func (children: ArrayList<Actor>) {
    childActors addAll(children)
  }
}
