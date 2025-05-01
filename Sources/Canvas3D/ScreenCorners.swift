//
//  ScreenCorners.swift
//  Canvas3D
//
//  Created by Kristian Trenskow on 23/04/2025.
//

public struct ScreenCorners {

	public let topLeft: SIMD2<Float>?
	public let topRight: SIMD2<Float>?
	public let bottomLeft: SIMD2<Float>?
	public let bottomRight: SIMD2<Float>?

	init(
		topLeft: SIMD2<Float>?,
		topRight: SIMD2<Float>?,
		bottomLeft: SIMD2<Float>?,
		bottomRight: SIMD2<Float>?
	) {
		self.topLeft = topLeft
		self.topRight = topRight
		self.bottomLeft = bottomLeft
		self.bottomRight = bottomRight
	}

}

extension ScreenCorners {

	var all: [SIMD2<Float>] {
		return [
			self.topLeft,
			self.topRight,
			self.bottomLeft,
			self.bottomRight
		].compactMap({ $0 })
	}

	var minX: Float {
		return self.all.map({ $0.x }).min() ?? 0
	}

	var minY: Float {
		return self.all.map({ $0.y }).min() ?? 0
	}

	var maxX: Float {
		return self.all.map({ $0.x }).max() ?? 0
	}

	var maxY: Float {
		return self.all.map({ $0.y }).max() ?? 0
	}

}
