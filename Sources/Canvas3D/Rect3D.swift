//
//  Rect3D.swift
//  Canvas3D
//
//  Created by Kristian Trenskow on 27/04/2025.
//

import CoreGraphics

public struct Rect3D {

	public var origin: Point3D
	public var size: Size3D

	init(
		origin: Point3D,
		size: Size3D
	) {
		self.origin = origin
		self.size = size
	}

}

extension Rect3D: Interpolatable {

	public func interpolate(
		to: Rect3D,
		by: Double
	) -> Rect3D {
		return Rect3D(
			origin: self.origin.interpolate(
				to: to.origin,
				by: by),
			size: self.size.interpolate(
				to: to.size,
				by: by))
	}

}

extension Rect3D {

	public var x: CGFloat {
		get { self.origin.x }
		set { self.origin.x = newValue }
	}

	public var y: CGFloat {
		get { self.origin.y }
		set { self.origin.y = newValue }
	}

	public func z(
		default z: CGFloat
	) -> CGFloat {
		return self.origin.z ?? z
	}

	public var z: CGFloat {
		get {
			self.z(
				default: 0)
		}
		set { self.origin.z = newValue }
	}

	public var width: CGFloat {
		get { self.size.width }
		set { self.size.width = newValue }
	}

	public var height: CGFloat {
		get { self.size.height }
		set { self.size.height = newValue }
	}

	public var depth: CGFloat {
		get { self.size.depth }
		set { self.size.depth = newValue }
	}

	public var minX: CGFloat {
		return Swift.min(origin.x, origin.x + size.width)
	}

	public var minY: CGFloat {
		return Swift.min(origin.y, origin.y + size.height)
	}

	public func minZ(
		default z: CGFloat
	) -> CGFloat {
		return Swift.min(
			self.origin.z ?? z,
			self.origin.z ?? z + size.depth)
	}

	public var minZ: CGFloat {
		return self.minZ(
			default: 0)
	}

	public var maxX: CGFloat {
		return Swift.max(origin.x, origin.x + size.width)
	}

	public var maxY: CGFloat {
		return Swift.max(origin.y, origin.y + size.height)
	}

	public func maxZ(
		default z: CGFloat
	) -> CGFloat {
		return Swift.max(
			self.origin.z ?? z,
			self.origin.z ?? z + size.depth)
	}

	public var maxZ: CGFloat {
		return self.maxZ(
			default: 0)
	}

	public func min(
		defaultZ z: CGFloat
	) -> Point3D {
		return Point3D(
			x: self.minX,
			y: self.minY,
			z: self.minZ(
				default: z))
	}

	public var min: Point3D {
		return self.min(
			defaultZ: 0)
	}

	public func max(
		defaultZ z: CGFloat
	) -> Point3D {
		return Point3D(
			x: self.maxX,
			y: self.maxY,
			z: self.maxZ(
				default: z))
	}

	public var max: Point3D {
		return self.max(
			defaultZ: 0)
	}

	public var midX: CGFloat {
		return (self.minX + self.maxX) / 2
	}

	public var midY: CGFloat {
		return (self.minY + self.maxY) / 2
	}

	public func midZ(
		default z: CGFloat
	) -> CGFloat {
		return (self.minZ(default: z) + self.maxZ(default: z)) / 2
	}

	public var midZ: CGFloat {
		return self.midZ(
			default: 0)
	}

	public func mid(
		defaultZ z: CGFloat
	) -> Point3D {
		return Point3D(
			x: self.midX,
			y: self.midY,
			z: self.midZ(
				default: z))
	}

	public var mid: Point3D {
		return self.mid(
			defaultZ: 0)
	}

}
