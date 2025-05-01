//
//  Camera.swift
//  Canvas3D
//
//  Created by Kristian Trenskow on 23/04/2025.
//

import simd
import Foundation

public struct Camera {

	let eye: SIMD3<Float>
	let target: SIMD3<Float>
	let up: SIMD3<Float>
	let projection: Projection
	let near: Float
	let far: Float
	let screenSize: SIMD2<Float>

	public init(
		eye: SIMD3<Float>,
		target: SIMD3<Float>,
		up: SIMD3<Float> = SIMD3<Float>(0, 1, 0),
		projection: Projection = .perspective(
			fovY: Float.pi / 3),
		near: Float = 0.1,
		far: Float = 100.0,
		screenSize: SIMD2<Float>
	) {
		self.eye = eye
		self.target = target
		self.up = up
		self.projection = projection
		self.near = near
		self.far = far
		self.screenSize = screenSize
	}

	private func lookAt(
		transform: simd_float4x4
	) -> simd_float4x4 {

		let z = simd_normalize(self.eye - self.target)
		let x = simd_normalize(simd_cross(self.up, z))
		let y = simd_cross(z, x)

		let t = SIMD3<Float>(
			-simd_dot(x, self.eye),
			 -simd_dot(y, self.eye),
			 -simd_dot(z, self.eye))

		return transform * simd_float4x4(
			SIMD4<Float>(x.x, y.x, z.x, 0),
			SIMD4<Float>(x.y, y.y, z.y, 0),
			SIMD4<Float>(x.z, y.z, z.z, 0),
			SIMD4<Float>(t.x, t.y, t.z, 1)
		)

	}

	private func projectionMatrix() -> simd_float4x4 {

		switch self.projection {

		case .perspective(
			let fovY
		):

			let yScale = 1 / tan(fovY * 0.5)
			let xScale = yScale / (self.screenSize.x / self.screenSize.y)
			let zRange = self.near - self.far

			return simd_float4x4(
				SIMD4<Float>(xScale, 0, 0, 0),
				SIMD4<Float>(0, yScale, 0, 0),
				SIMD4<Float>(0, 0, (self.far + self.near) / zRange, -1),
				SIMD4<Float>(0, 0, (2 * self.far * self.near) / zRange, 0))

		case .orthographic(
			let left,
			let right,
			let bottom,
			let top
		):

			let rl = right - left
			let tb = top - bottom
			let fn = self.far - self.near

			return simd_float4x4(
				SIMD4<Float>(2 / rl, 0, 0, 0),
				SIMD4<Float>(0, 2 / tb, 0, 0),
				SIMD4<Float>(0, 0, -2 / fn, 0),
				SIMD4<Float>(
					-(right + left) / rl,
					 -(top + bottom) / tb,
					 -(self.far + self.near) / fn,
					 1))

		}

	}

	private func pClip(
		_ worldPoint: SIMD4<Float>,
		transform: simd_float4x4
	) -> SIMD4<Float> {

		let view = lookAt(
			transform: transform)
		let projection = self.projectionMatrix()
		let pCamera = view * worldPoint

		return projection * pCamera

	}

	private func visible(
		pClip: SIMD4<Float>,
	) -> Bool {

		return abs(pClip.x) <= abs(pClip.w) &&
			abs(pClip.y) <= abs(pClip.w) &&
			abs(pClip.z) <= abs(pClip.w)

	}

	public func visible(
		worldPoint: SIMD4<Float>,
		transform: simd_float4x4
	) -> Bool {
		return self.visible(
			pClip: self.pClip(
				worldPoint,
				transform: transform))
	}

	public func project(
		worldPoint: SIMD4<Float>,
		transform: simd_float4x4 = matrix_identity_float4x4
	) -> SIMD2<Float> {

		let pClip = self.pClip(
			worldPoint,
			transform: transform)

		let pNDC = SIMD4<Float>(
			pClip.x / pClip.w,
			pClip.y / pClip.w,
			pClip.z / pClip.w,
			1)

		return SIMD2<Float>(
			(pNDC.x + 1) * 0.5 * self.screenSize.x,
			(1 - pNDC.y) * 0.5 * self.screenSize.y)

	}

	public func unproject(
		z: Float? = nil,
		screenPoint: SIMD2<Float>,
		transform: simd_float4x4 = matrix_identity_float4x4
	) -> SIMD2<Float>? {

		let ndcX = (2 * screenPoint.x / self.screenSize.x) - 1
		let ndcY = 1 - (2 * screenPoint.y / self.screenSize.y)
		let ndcNear = SIMD4<Float>(ndcX, ndcY, -1, 1)
		let ndcFar = SIMD4<Float>(ndcX, ndcY,  1, 1)

		let view = self.lookAt(
			transform: transform)
		let projection = self.projectionMatrix()
		let invViewProjection = simd_inverse(projection * view)

		let worldNear = invViewProjection * ndcNear
		let worldFar = invViewProjection * ndcFar
		let p0 = worldNear.xyz / worldNear.w
		let p1 = worldFar.xyz / worldFar.w

		let dir = p1 - p0
		let t = ((z ?? self.target.z) - p0.z) / dir.z

		guard dir.z != 0 else {
			return nil
		}

		let result = p0 + dir * t

		return SIMD2(
			x: result.x,
			y: result.y)

	}

	public func screenBounds(
		atZ z: Float? = nil,
		transform: simd_float4x4 = matrix_identity_float4x4
	) -> ScreenCorners {
		return ScreenCorners(
			topLeft: self.unproject(
				z: z,
				screenPoint: SIMD2<Float>(0, 0),
				transform: transform),
			topRight: self.unproject(
				z: z,
				screenPoint: SIMD2<Float>(self.screenSize.x, 0),
				transform: transform),
			bottomLeft: self.unproject(
				z: z,
				screenPoint: SIMD2<Float>(0, self.screenSize.y),
				transform: transform),
			bottomRight: self.unproject(
				z: z,
				screenPoint: SIMD2<Float>(self.screenSize.x, self.screenSize.y),
				transform: transform))
	}

}

extension Camera {

	public func visible(
		worldPoint: SIMD3<Float>,
		transform: simd_float4x4 = matrix_identity_float4x4
	) -> Bool {
		return self.visible(
			worldPoint: SIMD4<Float>(
				worldPoint.x,
				worldPoint.y,
				worldPoint.z,
				1),
			transform: transform)
	}

	public func visible(
		worldPoint: SIMD2<Float>,
		transform: simd_float4x4 = matrix_identity_float4x4
	) -> Bool {
		return self.visible(
			worldPoint: SIMD4<Float>(
				x: worldPoint.x,
				y: worldPoint.y,
				z: 0,
				w: 1),
			transform: transform)
	}

	public func project(
		worldPoint: SIMD3<Float>,
		transform: simd_float4x4 = matrix_identity_float4x4
	) -> SIMD2<Float> {

		return self.project(
			worldPoint: SIMD4<Float>(
				worldPoint.x,
				worldPoint.y,
				worldPoint.z,
				1),
			transform: transform)

	}

	public func project(
		worldPoint: SIMD2<Float>,
		transform: simd_float4x4 = matrix_identity_float4x4
	) -> SIMD2<Float> {

		return self.project(
			worldPoint: SIMD4<Float>(
				x: worldPoint.x,
				y: worldPoint.y,
				z: 0,
				w: 1),
			transform: transform)

	}

}
