//
//  SIMD2.swift
//  Canvas3D
//
//  Created by Kristian Trenskow on 27/04/2025.
//

import simd

extension SIMD2: Interpolatable where Scalar: Interpolatable {
	public func interpolate(
		to: SIMD2<Scalar>,
		by: Double
	) -> SIMD2<Scalar> {
		return SIMD2<Scalar>(
			x.interpolate(
				to: to.x,
				by: by),
			y.interpolate(
				to: to.y,
				by: by))
	}
}
