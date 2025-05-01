# Canvas3D

A (sort of) in-place replacement of SwiftUI build in `Canvas` - but with the added `z` and camera.

## Usage

An example can be seen below.

````swift
import SwiftUI
import Canvas3D

struct My3DView: View {
	var body: some View {
		Canvas3D(
			projection: .perspective,
			eye: Point3D(
				x: 100,
				y: 100,
				z: 100),
			target: Point3D(
				x: 0,
				y: 0,
				z: 0)
		) { context in

			var path = Path3D()

			path.move(to: Point3D(x: -50, y: -50, z: 0))
			path.line(to: Point3D(x: 50, y: -50, z: 0))
			path.line(to: Point3D(x: 50, y: 50, z: 0))
			path.line(to: Point3D(x: -50, y: 50, z: 0))

			context.fill(
				path,
				with: .color(.blue))

		}
	}
}
````

> More examples to come...

# License

See license in LICENSE

