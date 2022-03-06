//
//  RangeSlider.swift
//  RangeSliderTester
//
//  Created by Dionne Lie-Sam-Foek on 05/03/2022.
//

import SwiftUI

public struct RangeSlider<V: BinaryFloatingPoint>: View {
    @Binding var range: ClosedRange<V>
    var bounds: ClosedRange<V> = 0.0...1.0
    var step: V = 0.001
    let color: Color
    let height: CGFloat
    
    public init(range: Binding<ClosedRange<V>>, bounds: ClosedRange<V> = 0.0...1.0, step: V = 0.001, color: Color, height: CGFloat) {
        self._range = range
        self.bounds = bounds
        self.step = step
        self.color = color
        self.height = height.clamp(low: 1, high: RSMath.interactiveButtonWidth)
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RSBar(tint: color, range: range, bounds: bounds)
                    .frame(height: height)
                
                RSButton(position: geo.lowerButtonPosition(for: range, bounds: bounds)) {
                    updateLowerRange($0, in: geo)
                }
                
                RSButton(position: geo.upperButtonPosition(for: range, bounds: bounds)) {
                    updateUpperRange($0, in: geo)
                }
            }
            .frame(height: geo.size.height)
        }
        .frame(minHeight: RSMath.interactiveButtonWidth)
        .fixedSize(horizontal: false, vertical: true)
    }
}

private extension RangeSlider {
    func updateLowerRange(_ lower: CGFloat, in geo: GeometryProxy) {
        let newLower = geo.newLowerBound(for: range, bounds: bounds, dragValue: lower, step: step)
        let trueLower = min(newLower, range.upperBound)
        range = trueLower...range.upperBound
    }
    
    func updateUpperRange(_ upper: CGFloat, in geo: GeometryProxy) {
        let newUpper = geo.newUpperBound(for: range, bounds: bounds, dragValue: upper, step: step)
        let trueUpper = max(newUpper, range.lowerBound)
        range = range.lowerBound...trueUpper
    }
}

struct RangeSlider_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RangeSlider(range: .constant(0.15...0.85), color: .indigo, height: 10)
        }
        .padding()
    }
}
