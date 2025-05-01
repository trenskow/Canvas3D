//
//  Context.swift
//  Canvas3D
//
//  Created by Kristian Trenskow on 24/04/2025.
//

import simd
import SwiftUI

extension Canvas3D {

	public struct GraphicsContext3D {

		public struct Bounds {

			public let minX: CGFloat
			public let minY: CGFloat
			public let maxX: CGFloat
			public let maxY: CGFloat

			init(
				minX: CGFloat,
				minY: CGFloat,
				maxX: CGFloat,
				maxY: CGFloat
			) {
				self.minX = minX
				self.minY = minY
				self.maxX = maxX
				self.maxY = maxY
			}

		}

		private struct State {
			let transform: Transform3D
		}

		public let context2d: GraphicsContext
		public let camera: Camera
		public let viewport: Viewport

		private var states: [State] = []

		private var transform: Transform3D = .identity

		init(
			context2d: GraphicsContext,
			camera: Camera,
			viewport: Viewport
		) {
			self.context2d = context2d
			self.camera = camera
			self.viewport = viewport
		}

		private mutating func saveState() {
			self.states.append(
				State(
					transform: self.transform))
		}

		private mutating func restoreState() {

			guard let state = self.states.popLast()
			else { return }

			self.transform = state.transform

		}

		public mutating func withSavedState<T>(
			_ block: (inout GraphicsContext3D) throws -> T
		) rethrows -> T {

			self.saveState()

			defer { self.restoreState() }

			return try block(&self)

		}

		public mutating func translate(
			_ translation: Point3D
		) {
			self.transform = self.transform * .translate(
				offset: translation)
		}

		public mutating func rotate(
			_ angle: Angle,
			around axis: Point3D
		) {
			self.transform = self.transform * .rotation(
				angle,
				around: axis)
		}

		public mutating func scale(
			_ scale: Point3D
		) {
			self.transform = self.transform * .scale(
				scale: scale)
		}

		public func screenBounds(
			atZ z: CGFloat? = nil
		) -> Bounds {

			let screenBounds = self.camera
				.screenBounds(
					atZ: z.map(Float.init) ?? self.camera.target.z,
					transform: self.transform.simd)

			return Bounds(
				minX: CGFloat(screenBounds.minX),
				minY: CGFloat(screenBounds.minY),
				maxX: CGFloat(screenBounds.maxX),
				maxY: CGFloat(screenBounds.maxY))

		}

		public func screenPoint(
			forWorldViewPoint worldViewPoint: Point3D
		) -> CGPoint {
			return CGPoint(simd: self.camera.project(
				worldPoint: worldViewPoint.simd(),
				transform: self.transform.simd))
		}

		public func screenPoint(
			forWorldPoint worldPoint: CGPoint,
			atZ z: CGFloat? = nil
		) -> CGPoint {
			return CGPoint(simd: self.camera.project(
				worldPoint: SIMD3<Float>(
					x: Float(worldPoint.x),
					y: Float(worldPoint.y),
					z: z.map(Float.init) ?? self.camera.target.z),
				transform: self.transform.simd))
		}

		public func worldViewPoint(
			forScreenPoint screenPoint: CGPoint,
			atZ z: CGFloat? = nil
		) -> Point3D? {

			let screenPoint = SIMD2<Float>(
				Float(screenPoint.x),
				Float(screenPoint.y))

			guard let worldPoint = self.camera.unproject(
				z: z.map({ Float($0) }) ?? self.camera.target.z,
				screenPoint: SIMD2<Float>(
					x: Float(screenPoint.x),
					y: Float(screenPoint.y)),
				transform: self.transform.simd)
			else { return nil }

			return Point3D(
				simd: worldPoint,
				z : z.map(Float.init) ?? self.camera.target.z)

		}

		public func stroke(
			_ path: Path3D,
			with shading: GraphicsContext.Shading,
			lineWidth: CGFloat = 1
		) {
			self.context2d.stroke(
				path.path(
					in: self.camera,
					transform: self.transform),
				with: shading,
				lineWidth: lineWidth)
		}

		public func fill(
			_ path: Path3D,
			with shading: GraphicsContext.Shading
		) {
			self.context2d.fill(
				path.path(
					in: self.camera,
					transform: self.transform),
				with: shading)
		}

	}

}

extension Canvas3D.GraphicsContext3D {

	private func projectPath(
		_ points: [Point3D]
	) -> Path? {

		guard points.count > 1
		else { return nil }

		let points = points
			.map { point in
				return self.camera.project(
					worldPoint: point.simd(),
					transform: self.transform.simd)
			}
			.map { point in
				return SIMD2<Float>(
					x: point.x + Float(self.viewport.offset.x),
					y: point.y + Float(self.viewport.offset.y))
			}

		return Path { path in

			path.move(
				to: CGPoint(simd: points[0]))

			for point in points.dropFirst() {
				path.addLine(
					to: CGPoint(simd: point))
			}

			path.addLine(
				to: CGPoint(simd: points[0]))

		}
	}
}

extension Canvas3D.GraphicsContext3D {

	public mutating func translate(
		x: CGFloat
	) {
		self.translate(
			Point3D(
				x: x,
				y: 0,
				z: 0))
	}

	public mutating func translate(
		y: CGFloat
	) {
		self.translate(
			Point3D(
				x: 0,
				y: y,
				z: 0))
	}

	public mutating func translate(
		z: CGFloat
	) {
		self.translate(
			Point3D(
				x: 0,
				y: 0,
				z: z))
	}

	public mutating func rotate(
		angleX: Angle
	) {
		self.rotate(
			angleX,
			around: Point3D(
				x: 1,
				y: 0,
				z: 0))
	}

	public mutating func rotate(
		angleY: Angle
	) {
		self.rotate(
			angleY,
			around: Point3D(
				x: 0,
				y: 1,
				z: 0))
	}

	public mutating func rotate(
		angleZ: Angle
	) {
		self.rotate(
			angleZ,
			around: Point3D(
				x: 0,
				y: 0,
				z: 1))
	}

	public mutating func scale(
		x: CGFloat
	) {
		self.scale(
			Point3D(
				x: x,
				y: 1,
				z: 1))
	}

	public mutating func scale(
		y: CGFloat
	) {
		self.scale(
			Point3D(
				x: 1,
				y: y,
				z: 1))
	}

	public mutating func scale(
		z: CGFloat
	) {
		self.scale(
			Point3D(
				x: 1,
				y: 1,
				z: z))
	}

}

extension Path3D {

	func path(
		in camera: Camera,
		transform: Transform3D = .identity
	) -> Path {

		return self
			.elements
			.reduce(into: Path()) { partialResult, element in

				switch element {

				case .move(let to):
					partialResult.move(
						to: CGPoint(simd: camera.project(
							worldPoint: to.simd(),
							transform: (transform * self.transform).simd)))

				case .line(let to):
					partialResult.addLine(
						to: CGPoint(simd: camera.project(
							worldPoint: to.simd(),
							transform: (transform * self.transform).simd)))

				case .curve(let to, let control1, let control2):
					partialResult.addCurve(
						to: CGPoint(simd: camera.project(
							worldPoint: to.simd(),
							transform: (transform * self.transform).simd)),
						control1: CGPoint(simd: camera.project(
							worldPoint: control1.simd(),
							transform: (transform * self.transform).simd)),
						control2: CGPoint(simd: camera.project(
							worldPoint: control2.simd(),
							transform: (transform * self.transform).simd)))

				case .quadCurve(let to, let control):
					partialResult.addQuadCurve(
						to: CGPoint(simd: camera.project(
							worldPoint: to.simd(),
							transform: (transform * self.transform).simd)),
						control: CGPoint(simd: camera.project(
							worldPoint: control.simd(),
							transform: (transform * self.transform).simd)))

				case .subpath(let subpath):
					partialResult.addPath(
						subpath.path(
							in: camera,
							transform: transform * self.transform))

				case .closePath:
					partialResult.closeSubpath()

				}

			}

	}

}
