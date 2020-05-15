//  ZESpiral.swift
//
//  Created by Secret Asian Man 3 on 20.04.18.
//  based on ZESpiral by ZevEisenberg @
//  https://github.com/ZevEisenberg/ZESpiral

import Foundation
import SwiftUI

// get co-ordinates of intersection of 2 lines
// defined by y = mx + b
func intersect(
    m1:Double,
    m2:Double,
    b1:Double,
    b2:Double
) -> CGPoint {
    // Note: since we control the theta-step, we can guaratantee the lines are not parallel, i.e.
    // m1 != m2, hence no need to error check
    let x = (b2 - b1) / (m1 - m2)
    return CGPoint(
        x:x,
        y:(m1*x)+b1
    )
}

// get cartesian co-ordinates of a point
// on the spiral r = theta
// and also move them out by some radius
func spiralPoint(theta:Double, thicc: Double) -> CGPoint {
    CGPoint(
        x: xCosX(theta) + cos(theta) * thicc,
        y: xSinX(theta) + sin(theta) * thicc
    )
}

// moves control point out by some radius
// theta: the direction to move the point
// phi: the angle subtended by the arc, larger phi requires a greater adjustment in control point
func moveOutControl(
    pt: CGPoint,
    theta: Double,
    phi: Double
) -> CGPoint {
    let tPrime = thiccness * 2 * sin(phi / 2) / sin(phi)
    return CGPoint(
        x: Double(pt.x) + cos(theta) * tPrime,
        y: Double(pt.y) + sin(theta) * tPrime
    )
}

// adjust the spiral to the center of frame
func center(
    _ pt:CGPoint
) -> CGPoint{
    return CGPoint(
        x:pt.x + CGFloat(MAX_RADIUS + thiccness),
        y:pt.y + CGFloat(MAX_RADIUS + thiccness)
    )
}

// helper functions
func xCosX(_ x:Double)->Double{x * cos(x)}
func xSinX(_ x:Double)->Double{x * sin(x)}
