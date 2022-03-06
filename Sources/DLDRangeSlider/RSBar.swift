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
                        .fill(Color.barBackgroundColor)
                )
        }
    }
}

private extension RSBar {
    
}

private extension Color {
    static var barBackgroundColor: Color {
        #if os(iOS)
        return Color(uiColor: .systemGray5)
        #elseif os(macOS)
        return Color(nsColor: .placeholderTextColor)
        #endif
    }
}

struct SliderTrack_Previews: PreviewProvider {
    static var previews: some View {
        RSBar(tint: .accentColor, range: 0.15...0.85, bounds: 0.0...1.0)
            .padding()
    }
}
