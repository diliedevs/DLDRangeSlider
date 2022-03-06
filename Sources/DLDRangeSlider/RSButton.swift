//
//  RSButton.swift
//  RangeSliderTester
//
//  Created by Dionne Lie-Sam-Foek on 05/03/2022.
//

import SwiftUI

struct RSButton: View {
    let position: CGPoint
    let onDrag: (CGFloat) -> Void
    
    init(position: CGPoint, onDrag: @escaping (CGFloat) -> Void) {
        self.position = position
        self.onDrag = onDrag
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .shadow(color: .black.opacity(0.25), radius: 3, y: 1)
                .frame(width: RSMath.buttonWidth, height: RSMath.buttonWidth)
        }
        .frame(minWidth: RSMath.interactiveButtonWidth, minHeight: RSMath.interactiveButtonWidth)
        .position(position)
        .gesture(
            DragGesture()
                .onChanged {
                    onDrag($0.location.x)
                }
        )
    }
}

private extension RSButton {
    
}

struct SliderButton_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            RSButton(position: .zero, onDrag: { _ in })            
        }
    }
}
