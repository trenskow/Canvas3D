//
//  DimensionAddressable.swift
//  Canvas3D
//
//  Created by Kristian Trenskow on 27/04/2025.
//

public protocol DimensionAddressable {

	associatedtype Value

	var x: Value { get set }
	var y: Value { get set }
	var z: Value { get set }

	init(
		x: Value,
		y: Value,
		z: Value)

}

extension DimensionAddressable {

	public subscript(_ dimension: Dimension) -> Value {
		get {
			switch dimension {
			case .x:
				return x
			case .y:
				return y
			case .z:
				return z
			}
		}
		set {
			switch dimension {
			case .x:
				self.x = newValue
			case .y:
				self.y = newValue
			case .z:
				self.z = newValue
			}
		}
	}

}

extension DimensionAddressable where Value: Interpolatable {
	public func interpolate(
		to: Self,
		by: Double
	) -> Self {
		return Self(
			x: x.interpolate(
				to: to.x,
				by: by),
			y: y.interpolate(
				to: to.y,
				by: by),
			z: z.interpolate(
				to: to.z,
				by: by))
	}
}
