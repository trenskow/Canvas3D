//
//  Point3D.swift
//  Canvas3D
//
//  Created by Kristian Trenskow on 24/04/2025.
//

import simd
import CoreGraphics

public struct Point3D: Sendable, Codable {

	public var x: CGFloat
	public var y: CGFloat
	public var z: CGFloat?

	public init(
		x: CGFloat,
		y: CGFloat,
		z: CGFloat? = nil
	) {
		self.x = x
		self.y = y
		self.z = z
	}

}

extension Point3D: Equatable, Hashable { }

extension Point3D {

	public static let zero = Point3D(
		x: 0,
		y: 0,
		z: 0)

}

extension Point3D {

	func simd(
		defaultZ z: CGFloat = 0
	) -> SIMD3<Float> {
		return SIMD3<Float>(
			Float(self.x),
			Float(self.y),
			Float(self.z ?? z))
	}

	init(
		simd: SIMD3<Float>
	) {
		self.x = CGFloat(simd.x)
		self.y = CGFloat(simd.y)
		self.z = CGFloat(simd.z)
	}

	init(
		simd: SIMD2<Float>,
		z: Float?
	) {
		self.x = CGFloat(simd.x)
		self.y = CGFloat(simd.y)
		self.z = z.map(CGFloat.init) ?? 0
	}

}

extension Point3D {

	public func toCGPoint() -> CGPoint {
		return CGPoint(
			x: self.x,
			y: self.y)
	}

	public init(
		_ cgPoint: CGPoint,
		z: CGFloat?
	) {
		self.x = cgPoint.x
		self.y = cgPoint.y
		self.z = z ?? 0
	}

}

extension Point3D: Interpolatable {

	public func interpolate(
		to: Point3D,
		by: Double,
		defaultZ z: CGFloat = 0
	) -> Point3D {
		return Point3D(
			x: self.x.interpolate(
				to: to.x,
				by: by),
			y: self.y.interpolate(
				to: to.y,
				by: by),
			z: (self.z ?? z).interpolate(
				to: (to.z ?? z),
				by: by))
	}

	public func interpolate(
		to: Point3D,
		by: Double
	) -> Point3D {
		return self.interpolate(
			to: to,
			by: by,
			defaultZ: 0)
	}

}
