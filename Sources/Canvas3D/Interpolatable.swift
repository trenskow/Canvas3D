//
//  Interpolatable.swift
//  Canvas3D
//
//  Created by Kristian Trenskow on 27/04/2025.
//

import Foundation

public protocol Interpolatable {
	func interpolate(
		to: Self,
		by: Double
	) -> Self
}

extension BinaryFloatingPoint where Self: Interpolatable {
	public func interpolate(
		to: Self,
		by: Double
	) -> Self {
		return self + (to - self) * Self(by)
	}
}

extension Float : Interpolatable {}
extension Double: Interpolatable {}

extension SIMD3: Interpolatable where Scalar: Interpolatable {
	public func interpolate(
		to: SIMD3<Scalar>,
		by: Double
	) -> SIMD3<Scalar> {
		return SIMD3<Scalar>(
			x.interpolate(
				to: to.x,
				by: by),
			y.interpolate(
				to: to.y,
				by: by),
			z.interpolate(
				to: to.z,
				by: by))
	}
}
