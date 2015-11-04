use sdl2
import sdl2/[Core]

import Actor

import structs/ArrayList

Scene: class {
	actors: ArrayList<Actor>
	camera: SdlRect
	localUpdate: Func(Int)
	localRender: Func

	init: func () {
		actors = ArrayList<Actor> new()
		camera x = 0
		camera y = 0

		localUpdate = func (deltaTime: Int) {}
		localRender = func () {}
	}

	addActor: func (actor: Actor) {
		actors add(actor)
	}

	addActors: func (actors: ArrayList<Actor>) {
		this actors addAll(actors)
	}

	sortActors: func () {

	}

	update: func (deltaTime: Int) {
		this localUpdate(deltaTime)

		actors each(|actor|
			actor update(deltaTime)
		)
	}

	render: func () {
		localRender()

		actors each(|actor|
			actor render(camera)
		)
	}
}
