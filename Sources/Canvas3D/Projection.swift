//
//  Projection.swift
//  Canvas3D
//
//  Created by Kristian Trenskow on 23/04/2025.
//

extension Camera {

	public enum Projection {
		case perspective(
			fovY: Float = Float.pi / 3)
		case orthographic(
			left: Float = -1,
			right: Float = 1,
			top: Float = 1,
			bottom: Float = -1)
	}

}

extension Camera.Projection {

	public static var perspective: Self {
		.perspective()
	}

	public static var orthographic: Self {
		.orthographic()
	}

}
