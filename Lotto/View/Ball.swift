//
//  Ball.swift
//  Lotto
//
//  Created by 김태은 on 11/13/24.
//

import SwiftUI

struct Ball: View {
    let number: Int
    
    var body: some View {
        Circle()
            .frame(width: 40, height: 40)
            .foregroundColor(colors(number: number))
            .overlay(
                Text("\(number)")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    .minimumScaleFactor(1.0)
            )
    }
    
    func colors(number: Int) -> Color {
        switch(number) {
        case 0: return Color.black
        case 1...10: return Color.yellow.opacity(0.9)
        case 11...20: return Color.teal.opacity(0.8)
        case 21...30: return Color.red.opacity(0.9)
        case 31...40: return Color.gray
        default: return Color.green
        }
    }
}

#Preview {
    Ball(number: 0)
}
