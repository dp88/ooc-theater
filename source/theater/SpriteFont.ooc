use sdl2
import sdl2/[Core]
import Actor
import structs/[ArrayList, HashMap]

SpriteFont: class {
  texture: SdlTexture
  keymap: HashMap<Char, SdlRect>

  init: func (=texture, size, x, y, columns: Int, chars: String) {
    keymap = HashMap<Char, SdlRect> new()
    len := chars size

    for (i in 0..len) {
      rect: SdlRect

      column := i % columns
      row: Int = i / columns

      lx := (column * size) + x
      ly := (row * size) + y

      rect x = lx
      rect y = ly
      rect w = size
      rect h = size

      keymap put(chars[i], rect)
    }
  }

  getText: func (text: String, size, x, y: Int) -> Actor {
    actorText := Actor new()
    len := text size

    actorText x = x
    actorText y = y

    for (i in 0..len) {
      spriteChar: Actor
      rect := keymap get(text[i])
      spriteChar = Actor new()
      spriteChar buildFromTexture(texture, rect, size, size)
      spriteChar x = i * size
      spriteChar y = 0
      actorText addChild(spriteChar)
    }

    return actorText
  }
}
