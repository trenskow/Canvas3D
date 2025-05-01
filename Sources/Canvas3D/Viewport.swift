//
//  Viewport.swift
//  Canvas3D
//
//  Created by Kristian Trenskow on 25/04/2025.
//

import CoreGraphics

public struct Viewport {

	public let size: CGSize
	public let offset: CGPoint

	public init(
		size: CGSize,
		offset: CGPoint = .zero
	) {
		self.size = size
		self.offset = offset
	}

}

