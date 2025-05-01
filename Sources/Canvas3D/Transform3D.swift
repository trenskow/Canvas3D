//
//  Transform3D.swift
//  Canvas3D
//
//  Created by Kristian Trenskow on 27/04/2025.
//

import simd
import Foundation
import SwiftUI

public struct Transform3D {

	var simd: simd_float4x4

	public init() {
		self.simd = matrix_identity_float4x4
	}

	init(
		matrix: simd_float4x4
	) {
		self.simd = matrix
	}

}

extension Transform3D {

	public static var identity: Transform3D {
		return Transform3D()
	}

	public static func rotation(
		_ angle: Angle,
		around axis: Point3D
	) -> Transform3D {

		let normalizedAxis = simd_normalize(axis.simd())

		let c = Float(cos(angle.radians))
		let s = Float(sin(angle.radians))
		let t = 1 - c
		let x = Float(normalizedAxis.x)
		let y = Float(normalizedAxis.y)
		let z = Float(normalizedAxis.z)

		return self.init(
			matrix: simd_float4x4(
				SIMD4<Float>(t * x * x + c,     t * x * y + s * z, t * x * z - s * y, 0),
				SIMD4<Float>(t * x * y - s * z, t * y * y + c,     t * y * z + s * x, 0),
				SIMD4<Float>(t * x * z + s * y, t * y * z - s * x, t * z * z + c,     0),
				SIMD4<Float>(0, 0, 0, 1)
			))
	}

	public static func translate(
		offset: Point3D
	) -> Transform3D {
		return self.init(
			matrix: matrix_float4x4(
				SIMD4<Float>(1, 0, 0, 0),
				SIMD4<Float>(0, 1, 0, 0),
				SIMD4<Float>(0, 0, 1, 0),
				SIMD4<Float>(Float(offset.x), Float(offset.y), Float(offset.z ?? 0), 1)
			))
	}

	public static func scale(
		scale: Point3D
	) -> Transform3D {
		self.init(
			matrix: simd_float4x4(diagonal: SIMD4<Float>(
				x: Float(scale.x),
				y: Float(scale.y),
				z: Float(scale.z ?? 1),
				w: 1)))
	}

}

extension Transform3D {

	public static func *(
		lhs: Transform3D,
		rhs: Transform3D
	) -> Transform3D {
		return Transform3D(
			matrix: lhs.simd * rhs.simd)
	}

}

extension Transform3D {

	public init(
		m11: CGFloat, m12: CGFloat, m13: CGFloat, m14: CGFloat,
		m21: CGFloat, m22: CGFloat, m23: CGFloat, m24: CGFloat,
		m31: CGFloat, m32: CGFloat, m33: CGFloat, m34: CGFloat,
		m41: CGFloat, m42: CGFloat, m43: CGFloat, m44: CGFloat
	) {
		self.simd = simd_float4x4(
			SIMD4<Float>(Float(m11), Float(m12), Float(m13), Float(m14)),
			SIMD4<Float>(Float(m21), Float(m22), Float(m23), Float(m24)),
			SIMD4<Float>(Float(m31), Float(m32), Float(m33), Float(m34)),
			SIMD4<Float>(Float(m41), Float(m42), Float(m43), Float(m44)))
	}

	public var m11: CGFloat {
		get {
			return CGFloat(simd[0, 0])
		}
		set {
			simd[0, 0] = Float(newValue)
		}
	}

	public var m12: CGFloat {
		get {
			return CGFloat(simd[0, 1])
		}
		set {
			simd[0, 1] = Float(newValue)
		}
	}

	public var m13: CGFloat {
		get {
			return CGFloat(simd[0, 2])
		}
		set {
			simd[0, 2] = Float(newValue)
		}
	}

	public var m14: CGFloat {
		get {
			return CGFloat(simd[0, 3])
		}
		set {
			simd[0, 3] = Float(newValue)
		}
	}

	public var m21: CGFloat {
		get {
			return CGFloat(simd[1, 0])
		}
		set {
			simd[1, 0] = Float(newValue)
		}
	}

	public var m22: CGFloat {
		get {
			return CGFloat(simd[1, 1])
		}
		set {
			simd[1, 1] = Float(newValue)
		}
	}

	public var m23: CGFloat {
		get {
			return CGFloat(simd[1, 2])
		}
		set {
			simd[1, 2] = Float(newValue)
		}
	}

	public var m24: CGFloat {
		get {
			return CGFloat(simd[1, 3])
		}
		set {
			simd[1, 3] = Float(newValue)
		}
	}

	public var m31: CGFloat {
		get {
			return CGFloat(simd[2, 0])
		}
		set {
			simd[2, 0] = Float(newValue)
		}
	}

	public var m32: CGFloat {
		get {
			return CGFloat(simd[2, 1])
		}
		set {
			simd[2, 1] = Float(newValue)
		}
	}

	public var m33: CGFloat {
		get {
			return CGFloat(simd[2, 2])
		}
		set {
			simd[2, 2] = Float(newValue)
		}
	}

	public var m34: CGFloat {
		get {
			return CGFloat(simd[2, 3])
		}
		set {
			simd[2, 3] = Float(newValue)
		}
	}

	public var m41: CGFloat {
		get {
			return CGFloat(simd[3, 0])
		}
		set {
			simd[3, 0] = Float(newValue)
		}
	}

	public var m42: CGFloat {
		get {
			return CGFloat(simd[3, 1])
		}
		set {
			simd[3, 1] = Float(newValue)
		}
	}

	public var m43: CGFloat {
		get {
			return CGFloat(simd[3, 2])
		}
		set {
			simd[3, 2] = Float(newValue)
		}
	}

	public var m44: CGFloat {
		get {
			return CGFloat(simd[3, 3])
		}
		set {
			simd[3, 3] = Float(newValue)
		}
	}

}

extension Transform3D: Interpolatable {

	private struct Quaternion: Equatable, Interpolatable {

		var x: CGFloat = 0.0
		var y: CGFloat = 0.0
		var z: CGFloat = 0.0
		var w: CGFloat = 0.0

		fileprivate func interpolate(
			to: Self,
			by position: Double
		) -> Self {
			return Quaternion(
				x: x.interpolate(to: to.x, by: position),
				y: y.interpolate(to: to.y, by: position),
				z: z.interpolate(to: to.z, by: position),
				w: w.interpolate(to: to.w, by: position)
			)
		}

		private static func ==(
			lhs: Quaternion,
			rhs: Quaternion
		) -> Bool {
			return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z && lhs.w == rhs.w
		}

	}

	private init(
		a: [CGFloat]
	) {
		self.init(
			m11: a[0], m12: a[1], m13: a[2], m14: a[3],
			m21: a[4], m22: a[5], m23: a[6], m24: a[7],
			m31: a[8], m32: a[9], m33: a[10], m34: a[11],
			m41: a[12], m42: a[13], m43: a[14], m44: a[15])
	}

	private init(
		tf: Transform3D,
		s: Quaternion
	) {
		self.init(
			m11: tf.m11 / s.x, m12: tf.m12 / s.x, m13: tf.m13 / s.x, m14: 0.0,
			m21: tf.m21 / s.y, m22: tf.m22 / s.y, m23: tf.m23 / s.y, m24: 0.0,
			m31: tf.m31 / s.z, m32: tf.m32 / s.z, m33: tf.m33 / s.z, m34: 0.0,
			m41: 0.0, m42: 0.0, m43: 0.0, m44: 1.0)
	}

	private func toArray() -> [CGFloat] {
		return [
			m11, m12, m13, m14,
			m21, m22, m23, m24,
			m31, m32, m33, m34,
			m41, m42, m43, m44,
		]
	}

	private func transpose(
		_ m: Transform3D
	) -> Transform3D {

		let mT = m.toArray()
		var rT = Transform3D.identity.toArray()

		for i: Int in 0...15 {

			let col = i % 4
			let row = i / 4
			let j = col * 4 + row

			rT[j] = mT[i]

		}

		return Transform3D(a: rT)

	}

	private func matrixQuaternion(
		_ m: Transform3D
	) -> Quaternion {

		var q = Quaternion()

		if (m.m11 + m.m22 + m.m33 > 0) {

			let t = m.m11 + m.m22 + m.m33 + 1.0
			let s = 0.5 / sqrt(t)

			q.w = s * t
			q.z = (m.m12 - m.m21) * s
			q.y = (m.m31 - m.m13) * s
			q.x = (m.m23 - m.m32) * s

		} else if (m.m11 > m.m22 && m.m11 > m.m33) {

			let t = m.m11 - m.m22 - m.m33 + 1.0
			let s = 0.5 / sqrt(t)

			q.x = s * t
			q.y = (m.m12 + m.m21) * s
			q.z = (m.m31 + m.m13) * s
			q.w = (m.m23 - m.m32) * s

		} else if (m.m22 > m.m33) {

			let t = -m.m11 + m.m22 - m.m33 + 1.0
			let s = 0.5 / sqrt(t)

			q.y = s * t
			q.x = (m.m12 + m.m21) * s
			q.w = (m.m31 - m.m13) * s
			q.z = (m.m23 + m.m32) * s

		} else {

			let t = -m.m11 - m.m22 + m.m33 + 1.0
			let s = 0.5 / sqrt(t)

			q.z = s * t
			q.w = (m.m12 - m.m21) * s
			q.x = (m.m31 + m.m13) * s
			q.y = (m.m23 + m.m32) * s

		}

		return q

	}

	private func quaternionMatrix(
		_ q: Quaternion
	) -> Transform3D {

		var m = Transform3D()

		m.m11 = 1.0 - 2.0 * pow(q.y, 2.0) - 2.0 * pow(q.z, 2.0)
		m.m12 = 2.0 * q.x * q.y + 2.0 * q.w * q.z
		m.m13 = 2.0 * q.x * q.z - 2.0 * q.w * q.y
		m.m14 = 0.0

		m.m21 = 2.0 * q.x * q.y - 2.0 * q.w * q.z
		m.m22 = 1.0 - 2.0 * pow(q.x, 2.0) - 2.0 * pow(q.z, 2.0)
		m.m23 = 2.0 * q.y * q.z + 2.0 * q.w * q.x
		m.m24 = 0.0

		m.m31 = 2.0 * q.x * q.z + 2.0 * q.w * q.y
		m.m32 = 2.0 * q.y * q.z - 2.0 * q.w * q.x
		m.m33 = 1.0 - 2.0 * pow(q.x, 2.0) - 2.0 * pow(q.y, 2.0)
		m.m34 = 0.0

		m.m41 = 0.0
		m.m42 = 0.0
		m.m43 = 0.0
		m.m44 = 1.0

		return m

	}

	private func interpolateQuaternion(
		_ a: Quaternion,
		b: Quaternion,
		position: Double
	) -> Quaternion {

		var q = Quaternion()

		let dp = Double(a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w)

		var theta = acos(dp)
		if (theta == 0.0) { return a }
		if (theta < 1.0) { theta *= -1.0 }

		let st = sin(theta)

		let sut = sin(position * theta)
		let sout = sin((1.0 - position) * theta)
		let coeff1 = CGFloat(sout / st)
		let coeff2 = CGFloat(sut / st)

		q.x = coeff1 * a.x + coeff2 * b.x
		q.y = coeff1 * a.y + coeff2 * b.y
		q.z = coeff1 * a.z + coeff2 * b.z
		q.w = coeff1 * a.w + coeff2 * b.w

		let qLen:CGFloat = sqrt(q.x * q.x + q.y * q.y + q.z * q.z + q.w * q.w)
		q.x /= qLen
		q.y /= qLen
		q.z /= qLen
		q.w /= qLen

		return q

	}

	public func interpolate(
		to: Self,
		by position: Double
	) -> Self {

		var fromTf = self
		var toTf = to

		fromTf = transpose(fromTf)
		toTf = transpose(toTf)

		let from = Quaternion(x: fromTf.m14, y: fromTf.m24, z: fromTf.m34, w: 0.0)
		let to = Quaternion(x: toTf.m14, y: toTf.m24, z: toTf.m34, w: 0.0)
		let vT = from.interpolate(to: to, by: position)

		let fromS = Quaternion(
			x: sqrt(pow(fromTf.m11, 2.0) + pow(fromTf.m12, 2.0) + pow(fromTf.m13, 2.0)),
			y: sqrt(pow(fromTf.m21, 2.0) + pow(fromTf.m22, 2.0) + pow(fromTf.m23, 2.0)),
			z: sqrt(pow(fromTf.m31, 2.0) + pow(fromTf.m32, 2.0) + pow(fromTf.m33, 2.0)),
			w: 0.0
		)
		let toS = Quaternion(
			x: sqrt(pow(toTf.m11, 2.0) + pow(toTf.m12, 2.0) + pow(toTf.m13, 2.0)),
			y: sqrt(pow(toTf.m21, 2.0) + pow(toTf.m22, 2.0) + pow(toTf.m23, 2.0)),
			z: sqrt(pow(toTf.m31, 2.0) + pow(toTf.m32, 2.0) + pow(toTf.m33, 2.0)),
			w: 0.0
		)

		let vS = fromS.interpolate(to: toS, by: position)

		let fromRotation = Transform3D(tf: fromTf, s: fromS)
		let toRotation = Transform3D(tf: toTf, s: toS)

		var fromQuat = matrixQuaternion(fromRotation)
		var toQuat = matrixQuaternion(toRotation)

		let fromQuatLen: CGFloat = sqrt(fromQuat.x*fromQuat.x + fromQuat.y*fromQuat.y + fromQuat.z*fromQuat.z + fromQuat.w*fromQuat.w)
		fromQuat.x /= fromQuatLen
		fromQuat.y /= fromQuatLen
		fromQuat.z /= fromQuatLen
		fromQuat.w /= fromQuatLen
		let toQuatLen: CGFloat = sqrt(toQuat.x*toQuat.x + toQuat.y*toQuat.y + toQuat.z*toQuat.z + toQuat.w*toQuat.w)
		toQuat.x /= toQuatLen
		toQuat.y /= toQuatLen
		toQuat.z /= toQuatLen
		toQuat.w /= toQuatLen

		let valueQuat = interpolateQuaternion(fromQuat, b: toQuat, position: position)

		var valueTf = quaternionMatrix(valueQuat)

		valueTf.m11 *= vS.x
		valueTf.m12 *= vS.x
		valueTf.m13 *= vS.x

		valueTf.m21 *= vS.y
		valueTf.m22 *= vS.y
		valueTf.m23 *= vS.y

		valueTf.m31 *= vS.z
		valueTf.m32 *= vS.z
		valueTf.m33 *= vS.z

		valueTf.m14 = vT.x
		valueTf.m24 = vT.y
		valueTf.m34 = vT.z

		valueTf = transpose(valueTf)

		return valueTf

	}

}
