//
//  CGPoint.swift
//  Canvas3D
//
//  Created by Kristian Trenskow on 24/04/2025.
//

import CoreGraphics

extension CGPoint {

	func with(
		x: CGFloat
	) -> CGPoint {
		return CGPoint(
			x: x,
			y: self.y)
	}

	func with(
		y: CGFloat
	) -> CGPoint {
		return CGPoint(
			x: self.x,
			y: y)
	}

}

extension CGPoint {

	var simd: SIMD2<Float> {
		return SIMD2<Float>(
			Float(x),
			Float(y))
	}

	init(
		simd: SIMD2<Float>
	) {
		self.init(
			x: CGFloat(simd.x),
			y: CGFloat(simd.y))
	}

}

extension CGPoint: Interpolatable {
	public func interpolate(
		to: CGPoint,
		by: Double
	) -> CGPoint {
		return CGPoint(
			x: x.interpolate(
				to: to.x,
				by: by),
			y: y.interpolate(
				to: to.y,
				by: by))
	}
}
