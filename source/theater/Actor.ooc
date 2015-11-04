use sdl2
import sdl2/[Core]
import Theater

Actor: class {
	texture: SdlTexture
	sourceRect: SdlRect
	x: Int = 0
	y: Int = 0
	width, height: Int
	zIndex: Int = 0
	transparency: Float = 1.0
	anchor: String = ""
	shouldScale: Bool = false
	scale: Float = 1.0
	update: Func(Int)
	click: Func

	init: func (t: SdlTexture, src: SdlRect, w, h: Int) {
		texture = t
		sourceRect = src
		width = w
		height = h
		update = func (deltaTime: Int) {}
	}

	getRealSize: func () -> (Int, Int) {
		width, height: Int

		if (scale != 1.0) {
			width = width * scale
			height = height * scale
		}

		return (width, height)
	}

	getRealLocation: func () -> (Int, Int) {
		rx := x
		ry := y
		winW, winH: Int
		halfWW, halfWH: Int
		halfRW, halfRH: Int
		SDL getWindowSize(Theater window, winW&, winH&)
		halfWW = winW / 2
		halfWH = winH / 2

		(w, h) := getRealSize()
		halfRW = w / 2
		halfRH = h / 2

		match (anchor) {
			case "center" =>
				rectX := halfWW - halfRW
				rectY := halfWH = halfRH
				rx += rectX
				ry += rectY
			case "n" =>
				rectX := halfWW - halfRW
				rx += rectX
			case "ne" =>
				rightX := winW - w
				rx += rightX
			case "w" =>
				rectY := halfWH - halfRH
				ry += rectY
			case "e" =>
				rectY := halfWH - halfRH
				rightX := winW - w
				rx += rightX
				ry += rectY
			case "sw" =>
				lowY := winH - h
				ry += lowY
			case "s" =>
				rectX := halfWW - halfRW
				lowY := winH - h
				rx += rectX
				ry += lowY
			case "se" =>
				rightX := winW - w
				lowY := winH - h
				rx += rightX
				ry += lowY
		}

		return (rx, ry)
	}

	render: func (camera: SdlRect) {
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
			destination x = x - camera x
			destination y = y - camera y
		}

		if (transparency > 1.0) {
			transparency = 1.0
		}
		if (transparency < 0.0) {
			transparency = 0.0
		}

    SDL setTextureAlphaMod(texture, transparency * 255)
		SDL renderCopy(Theater renderer, texture, sourceRect&, destination&)
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
}
