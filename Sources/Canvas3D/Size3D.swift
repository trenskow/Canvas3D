//
//  Size3D.swift
//  Canvas3D
//
//  Created by Kristian Trenskow on 27/04/2025.
//

import CoreGraphics

public struct Size3D {

	public var width: CGFloat
	public var height: CGFloat
	public var depth: CGFloat

	public init(
		width: CGFloat,
		height: CGFloat,
		depth: CGFloat) {
		self.width = width
		self.height = height
		self.depth = depth
	}

}

extension Size3D: Interpolatable {

	public func interpolate(
		to: Size3D,
		by: Double
	) -> Size3D {
		return Size3D(
			width: self.width.interpolate(
				to: to.width,
				by: by),
			height: self.height.interpolate(
				to: to.height,
				by: by),
			depth: self.depth.interpolate(
				to: to.depth,
				by: by))
	}

}

extension Size3D: DimensionAddressable {

	public var x: CGFloat {
		get { self.width }
		set { self.width = newValue }
	}

	public var y: CGFloat {
		get { self.height }
		set { self.height = newValue }
	}

	public var z: CGFloat {
		get { self.depth }
		set { self.depth = newValue }
	}

	public init(
		x: CGFloat,
		y: CGFloat,
		z: CGFloat
	) {
		self.init(
			width: x,
			height: y,
			depth: z)
	}

}
