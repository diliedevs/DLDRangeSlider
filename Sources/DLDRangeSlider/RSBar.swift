//
//  RSBar.swift
//  RangeSliderTester
//
//  Created by Dionne Lie-Sam-Foek on 06/03/2022.
//

import SwiftUI

struct RSBar<V: BinaryFloatingPoint>: View {
    let tint: Color
    let range: ClosedRange<V>
    let bounds: ClosedRange<V>
    
    var body: some View {
        GeometryReader { geo in
            Capsule()
                .foregroundColor(tint)
                .accentColor(tint)
                .mask {
                    ZStack {
                        Capsule()
                            .frame(width: geo.trackWidth(for: range, bounds: bounds))
                            .offset(x: geo.trackOffset(for: range, bounds: bounds))
                    }
                    .frame(width: geo.size.width, alignment: .leading)
                }
                .background(
                    Capsule()
                        .fill(Color.controlBackgroundColor)
                )
        }
    }
}

private extension RSBar {
    
}

struct SliderTrack_Previews: PreviewProvider {
    static var previews: some View {
        RSBar(tint: .indigo, range: 0.15...0.85, bounds: 0.0...1.0)
            .padding()
    }
}
