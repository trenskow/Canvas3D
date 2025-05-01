//
//  SIMD4.swift
//  Canvas3D
//
//  Created by Kristian Trenskow on 23/04/2025.
//

import simd

extension SIMD4 where Scalar: BinaryFloatingPoint {

	var xyz: SIMD3<Scalar> {
		return SIMD3<Scalar>(
			x,
			y,
			z)
	}

}

extension SIMD4: DimensionAddressable where Scalar: BinaryFloatingPoint {

	public init(
		x: Scalar,
		y: Scalar,
		z: Scalar
	) {
		self.init(x, y, z, 0)
	}

}

extension SIMD4: Interpolatable where Scalar: Interpolatable {
	public func interpolate(
		to: SIMD4<Scalar>,
		by: Double
	) -> SIMD4<Scalar> {
		return SIMD4<Scalar>(
			x.interpolate(
				to: to.x,
				by: by),
			y.interpolate(
				to: to.y,
				by: by),
			z.interpolate(
				to: to.z,
				by: by),
			w.interpolate(
				to: to.w,
				by: by))
	}
}
