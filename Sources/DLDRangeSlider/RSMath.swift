//
//  RSMath.swift
//  RangeSliderTester
//
//  Created by Dionne Lie-Sam-Foek on 06/03/2022.
//

import SwiftUI

struct RSMath {
    let totalWidth: CGFloat
    let range: ClosedRange<CGFloat>
    let bounds: ClosedRange<CGFloat>
    
    static let buttonWidth: CGFloat = 27
    static let interactiveButtonWidth: CGFloat = 44
    
    init<V: BinaryFloatingPoint>(totalWidth: CGFloat, range: ClosedRange<V>, bounds: ClosedRange<V>) {
        self.totalWidth = totalWidth
        let clampedRange = range.clamped(to: bounds)
        self.range = clampedRange.lowerBound.cgfloat...clampedRange.upperBound.cgfloat
        self.bounds = bounds.lowerBound.cgfloat...bounds.upperBound.cgfloat
    }
    
    static func trackWidth<V: BinaryFloatingPoint>(for totalWidth: CGFloat, range: ClosedRange<V>, bounds: ClosedRange<V>) -> CGFloat {
        RSMath(totalWidth: totalWidth, range: range, bounds: bounds).rangeDistance()
    }
    
    static func trackOffset<V: BinaryFloatingPoint>(for totalWidth: CGFloat, range: ClosedRange<V>, bounds: ClosedRange<V>) -> CGFloat {
        RSMath(totalWidth: totalWidth, range: range, bounds: bounds).fullLowerOffset
    }
    
    static func lowerButtonOffset<V: BinaryFloatingPoint>(for totalWidth: CGFloat, range: ClosedRange<V>, bounds: ClosedRange<V>) -> CGFloat {
        RSMath(totalWidth: totalWidth, range: range, bounds: bounds).lowerButtonOffset
    }
    
    static func upperButtonOffset<V: BinaryFloatingPoint>(for totalWidth: CGFloat, range: ClosedRange<V>, bounds: ClosedRange<V>) -> CGFloat {
        RSMath(totalWidth: totalWidth, range: range, bounds: bounds).upperButtonOffset
    }
    
    static func lowerBound<V: BinaryFloatingPoint>(for totalWidth: CGFloat, range: ClosedRange<V>, bounds: ClosedRange<V>, dragValue: CGFloat, step: V) -> V {
        let bound = RSMath(totalWidth: totalWidth, range: range, bounds: bounds).newLowerBound(from: dragValue, step: step.cgfloat)
        return V(bound)
    }
    
    static func upperBound<V: BinaryFloatingPoint>(for totalWidth: CGFloat, range: ClosedRange<V>, bounds: ClosedRange<V>, dragValue: CGFloat, step: V) -> V {
        let bound = RSMath(totalWidth: totalWidth, range: range, bounds: bounds).newUpperBound(from: dragValue, step: step.cgfloat)
        return V(bound)
    }
}

private extension RSMath {
    var btnWidth           : CGFloat { Self.buttonWidth }
    var halfBtnWidth       : CGFloat { btnWidth / 2 }
    var lowerLeadingOffset : CGFloat { halfBtnWidth }
    var lowerTrailingOffset: CGFloat { halfBtnWidth + btnWidth }
    var upperLeadingOffset : CGFloat { halfBtnWidth + btnWidth }
    var upperTrailingOffset: CGFloat { halfBtnWidth }
    
    var fullLowerOffset   : CGFloat { distanceFromValue(range.lowerBound, availableWidth: totalWidth, leadingOffset: lowerLeadingOffset, trailingOffset: lowerTrailingOffset) }
    var fullUpperOffset   : CGFloat { distanceFromValue(range.upperBound, availableWidth: totalWidth, leadingOffset: upperLeadingOffset, trailingOffset: upperTrailingOffset) }
    var lowerButtonOffset : CGFloat { distanceFromValue(range.lowerBound, availableWidth: totalWidth - btnWidth, leadingOffset: halfBtnWidth, trailingOffset: halfBtnWidth) }
    var upperButtonOffset : CGFloat { distanceFromValue(range.upperBound, availableWidth: totalWidth, leadingOffset: upperLeadingOffset, trailingOffset: halfBtnWidth) }
}

private extension RSMath {
    func rangeDistance() -> CGFloat {
        max(0, fullUpperOffset - fullLowerOffset)
    }
    
    func newLowerBound(from dragValue: CGFloat, step: CGFloat) -> CGFloat {
        bound(from: dragValue, step: step, availableWidth: totalWidth - btnWidth, leadingOffset: halfBtnWidth, trailingOffset: halfBtnWidth)
    }
    
    func newUpperBound(from dragValue: CGFloat, step: CGFloat) -> CGFloat {
        bound(from: dragValue, step: step, availableWidth: totalWidth, leadingOffset: upperLeadingOffset, trailingOffset: halfBtnWidth)
    }
    
    func distanceFromValue(_ value: CGFloat, availableWidth: CGFloat, leadingOffset: CGFloat, trailingOffset: CGFloat) -> CGFloat {
        guard availableWidth > (leadingOffset + trailingOffset) else { return 0 }
        
        let boundsLength = bounds.upperBound - bounds.lowerBound
        let relativeValue = (value - bounds.lowerBound) / boundsLength
        let offset = leadingOffset - ((leadingOffset + trailingOffset) * relativeValue)
        
        return offset + (availableWidth * relativeValue)
    }
    
    func bound(from dragValue: CGFloat, step: CGFloat, availableWidth: CGFloat, leadingOffset: CGFloat, trailingOffset: CGFloat) -> CGFloat {
        let relativeValue = (dragValue - leadingOffset) / (availableWidth - (leadingOffset + trailingOffset))
        let newValue = bounds.lowerBound + (relativeValue * (bounds.upperBound - bounds.lowerBound))
        let steppedValue = round(newValue / step) * step
        
        return min(bounds.upperBound, max(bounds.lowerBound, steppedValue))
    }
}

extension GeometryProxy {
    func trackWidth<V: BinaryFloatingPoint>(for range: ClosedRange<V>, bounds: ClosedRange<V>) -> CGFloat {
        RSMath.trackWidth(for: self.size.width, range: range, bounds: bounds)
    }
    
    func trackOffset<V: BinaryFloatingPoint>(for range: ClosedRange<V>, bounds: ClosedRange<V>) -> CGFloat {
        RSMath.trackOffset(for: self.size.width, range: range, bounds: bounds)
    }
    
    func lowerButtonPosition<V: BinaryFloatingPoint>(for range: ClosedRange<V>, bounds: ClosedRange<V>) -> CGPoint {
        let x = RSMath.lowerButtonOffset(for: self.size.width, range: range, bounds: bounds)
        let y = self.size.height / 2
        
        return CGPoint(x: x, y: y)
    }
    
    func upperButtonPosition<V: BinaryFloatingPoint>(for range: ClosedRange<V>, bounds: ClosedRange<V>) -> CGPoint {
        let x = RSMath.upperButtonOffset(for: self.size.width, range: range, bounds: bounds)
        let y = self.size.height / 2
        
        return CGPoint(x: x, y: y)
    }
    
    func newLowerBound<V: BinaryFloatingPoint>(for range: ClosedRange<V>, bounds: ClosedRange<V>, dragValue: CGFloat, step: V) -> V {
        RSMath.lowerBound(for: self.size.width, range: range, bounds: bounds, dragValue: dragValue, step: step)
    }
    
    func newUpperBound<V: BinaryFloatingPoint>(for range: ClosedRange<V>, bounds: ClosedRange<V>, dragValue: CGFloat, step: V) -> V {
        RSMath.upperBound(for: self.size.width, range: range, bounds: bounds, dragValue: dragValue, step: step)
    }
}

public extension BinaryFloatingPoint {
    var cgfloat: CGFloat { CGFloat(self) }
}

public extension Comparable {
    /// Returns the comparable element clamped to the given lower and upper bounds.
    /// - Parameters:
    ///   - start: The lowest value the comparable element can have.
    ///   - end: The highest value the comparable element can have.
    func clamp(low: Self, high: Self) -> Self {
        if self > high {
            return high
        } else if self < low {
            return low
        }
        
        return self
    }
}
