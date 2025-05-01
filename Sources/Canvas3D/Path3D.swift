//
//  Path3D.swift
//  Canvas3D
//
//  Created by Kristian Trenskow on 27/04/2025.
//

import SwiftUI

public struct Path3D {

	public enum Element {

		case closePath

		case curve(
			to: Point3D,
			control1: Point3D,
			control2: Point3D)

		case line(
			to: Point3D)

		case move(
			to: Point3D)

		case quadCurve(
			to: Point3D,
			control: Point3D)

		case subpath(Path3D)

	}

	private(set) var elements: [Element] = []
	private(set) var transform: Transform3D = .identity

	public var currentPoint: Point3D? {

		guard let last = self.elements.last else {
			return nil
		}

		switch last {
		case .closePath:
			return nil
		case .curve(let to, _, _),
				.line(let to),
				.move(let to),
				.quadCurve(let to, _):
			return to
		case .subpath(let path):
			return path.currentPoint
		}

	}

	public var isEmpty: Bool {
		return self.elements.isEmpty
	}

	public init() {}

	public mutating func move(
		to point: Point3D
	) {
		self.elements.append(
			.move(to: point))
	}

	public mutating func addArc(
		center: Point3D,
		radius: CGFloat,
		startAngle: Angle,
		endAngle: Angle,
		clockwise: Bool = false
	) {

		let start = Point3D(
			x: center.x + radius * cos(startAngle.radians),
			y: center.y + radius * sin(startAngle.radians))

		let end = Point3D(
			x: center.x + radius * cos(endAngle.radians),
			y: center.y + radius * sin(endAngle.radians))

		if clockwise {
			self.elements.append(
				.curve(
					to: end,
					control1: center,
					control2: start))
		} else {
			self.elements.append(
				.curve(
					to: start,
					control1: center,
					control2: end))
		}

	}

	public mutating func addArc(
		tangent1End: Point3D,
		tangent2End: Point3D,
		radius: CGFloat
	) {

		let center = Point3D(
			x: (tangent1End.x + tangent2End.x) / 2,
			y: (tangent1End.y + tangent2End.y) / 2)

		let start = Point3D(
			x: center.x + radius * (tangent1End.y - center.y),
			y: center.y - radius * (tangent1End.x - center.x))

		let end = Point3D(
			x: center.x + radius * (tangent2End.y - center.y),
			y: center.y - radius * (tangent2End.x - center.x))

		self.elements.append(
			.curve(
				to: end,
				control1: start,
				control2: end))

	}

	public mutating func addCurve(
		to point: Point3D,
		control1: Point3D,
		control2: Point3D
	) {
		self.elements.append(
			.curve(
				to: point,
				control1: control1,
				control2: control2))
	}

	public mutating func addEllipse(
		in rect: Rect3D
	) {

		let center = Point3D(
			x: rect.midX,
			y: rect.midY,
			z: rect.midZ)

		let rx = rect.width / 2
		let ry = rect.height / 2

		let kappa: CGFloat = 0.552284749831

		let cpX = rx * kappa
		let cpY = ry * kappa

		self.move(to: Point3D(x: center.x, y: center.y - ry, z: center.z))

		self.addCurve(
			to: Point3D(x: center.x + rx, y: center.y, z: center.z),
			control1: Point3D(x: center.x + cpX, y: center.y - ry, z: center.z),
			control2: Point3D(x: center.x + rx, y: center.y - cpY, z: center.z))

		self.addCurve(
			to: Point3D(x: center.x, y: center.y + ry, z: center.z),
			control1: Point3D(x: center.x + rx, y: center.y + cpY, z: center.z),
			control2: Point3D(x: center.x + cpX, y: center.y + ry, z: center.z))

		self.addCurve(
			to: Point3D(x: center.x - rx, y: center.y, z: center.z),
			control1: Point3D(x: center.x - cpX, y: center.y + ry, z: center.z),
			control2: Point3D(x: center.x - rx, y: center.y + cpY, z: center.z))

		self.addCurve(
			to: Point3D(x: center.x, y: center.y - ry, z: center.z),
			control1: Point3D(x: center.x - rx, y: center.y - cpY, z: center.z),
			control2: Point3D(x: center.x - cpX, y: center.y - ry, z: center.z))

		self.elements.append(.closePath)

	}

	public mutating func addLine(
		to point: Point3D
	) {
		self.elements.append(
			.line(
				to: point))
	}

	public mutating func addLines(
		_ points: [Point3D]
	) {
		for point in points {
			self.addLine(
				to: point)
		}
	}

	public mutating func addPath(
		_ path: Path3D,
	) {
		self.elements.append(
			.subpath(path))
	}

	public mutating func addQuadCurve(
		to point: Point3D,
		control: Point3D
	) {
		self.elements.append(
			.quadCurve(
				to: point,
				control: control))
	}

	public mutating func addRect(
		_ rect: Rect3D
	) {
		self.move(to: rect.origin)
		self.addLine(
			to: Point3D(
				x: rect.maxX,
				y: rect.minY,
				z: rect.minZ))
		self.addLine(
			to: Point3D(
				x: rect.maxX,
				y: rect.maxY,
				z: rect.minZ))
		self.addLine(
			to: Point3D(
				x: rect.minX,
				y: rect.maxY,
				z: rect.minZ))
		self.addLine(
			to: rect.origin)
	}

	public mutating func addRects(
		_ rects: [Rect3D]
	) {
		for rect in rects {
			self.addRect(
				rect)
		}
	}

	public mutating func addRoundedRect(
		_ rect: Rect3D,
		cornerSize: CGSize
	) {

		self.move(to: rect.origin)

		self.addLine(
			to: Point3D(
				x: rect.maxX - cornerSize.width,
				y: rect.minY,
				z: rect.minZ))

		self.addArc(
			center: Point3D(
				x: rect.maxX - cornerSize.width,
				y: rect.minY + cornerSize.height,
				z: rect.minZ),
			radius: cornerSize.width,
			startAngle: Angle(degrees: 270),
			endAngle: Angle(degrees: 360),
			clockwise: false)

		self.addLine(
			to: Point3D(
				x: rect.maxX,
				y: rect.maxY - cornerSize.height,
				z: rect.minZ))

		self.addArc(
			center: Point3D(
				x: rect.maxX - cornerSize.width,
				y: rect.maxY - cornerSize.height,
				z: rect.minZ),
			radius: cornerSize.width,
			startAngle: Angle(degrees: 0),
			endAngle: Angle(degrees: 90),
			clockwise: false)

		self.addLine(
			to: Point3D(
				x: rect.minX + cornerSize.width,
				y: rect.maxY,
				z: rect.minZ))

		self.addArc(
			center: Point3D(
				x: rect.minX + cornerSize.width,
				y: rect.maxY - cornerSize.height,
				z: rect.minZ),
			radius: cornerSize.width,
			startAngle: Angle(degrees: 90),
			endAngle: Angle(degrees: 180),
			clockwise: false)

		self.addLine(
			to: Point3D(
				x: rect.minX,
				y: rect.minY + cornerSize.height,
				z: rect.minZ))

		self.addArc(
			center: Point3D(
				x: rect.minX + cornerSize.width,
				y: rect.minY + cornerSize.height,
				z: rect.minZ),
			radius: cornerSize.width,
			startAngle: Angle(degrees: 180),
			endAngle: Angle(degrees: 270),
			clockwise: false)

		self.addLine(
			to: rect.origin)

		self.closeSubpath()

	}

	public mutating func closeSubpath() {
		self.elements.append(
			.closePath)
	}

	public mutating func offsetBy(
		dx: CGFloat,
		dy: CGFloat,
		dz: CGFloat? = nil
	) -> Path3D {
		return self.applying(
			.translate(
				offset: Point3D(
					x: dx,
					y: dy,
					z: dz)))
	}

	public func applying(
		_ transform: Transform3D
	) -> Path3D {
		var path = self
		path.transform = path.transform * transform
		return path
	}

	public func forEach(
		_ body: (Element) -> Void
	) {
		self.elements
			.forEach(
				body)
	}

}

extension Path3D {

	public init(
		lineFrom start: Point3D,
		to end: Point3D
	) {
		self.init()
		self.move(to: start)
		self.addLine(to: end)
	}

	init(
		rectangle rect: Rect3D
	) {
		self.init()
		self.addRect(rect)
	}

}

