//
//  CameraView.swift
//  Canvas3D
//
//  Created by Kristian Trenskow on 24/04/2025.
//

import SwiftUI

public struct Canvas3D: View {

	private let projection: Camera.Projection?
	private let renderer: (inout GraphicsContext3D) -> Void

	private let eye: Point3D
	private let target: Point3D

	public init(
		projection: Camera.Projection? = nil,
		eye: Point3D = Point3D(
			x: 0,
			y: 0,
			z: 1),
		target: Point3D = .zero,
		renderer: @escaping (inout GraphicsContext3D) -> Void,
		near: CGFloat = 0.1,
		far: CGFloat = 100.0
	) {
		self.projection = projection
		self.eye = eye
		self.target = target
		self.renderer = renderer
	}

	public var body: some View {
		Canvas { context, size in

			let camera = Camera(
				eye: eye.simd(),
				target: target.simd(),
				projection: self.projection ?? Camera.Projection.orthographic(
					left: 0,
					right: Float(size.width),
					top: 0,
					bottom: Float(size.height)),
				near: self.projection == nil ? -1000 : 0.1,
				far: self.projection == nil ? 1000 : 100,
				screenSize: SIMD2<Float>(
					x: Float(size.width),
					y: Float(size.height)))

			var context = GraphicsContext3D(
				context2d: context,
				camera: camera,
				viewport: Viewport(
					size: size))

			self.renderer(
				&context)

		}
	}

}
