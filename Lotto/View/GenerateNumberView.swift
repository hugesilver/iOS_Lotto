//
//  ContentView.swift
//  Lotto
//
//  Created by 김태은 on 2023/09/26.
//

import SwiftUI

struct GenerateNumberView: View {
    @State private var lottoNumbers: [Int] = [0, 0, 0, 0, 0, 0]
    
    var body: some View {
        VStack {
            Text("로또 번호 생성기")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
            
            HStack {
                ForEach(lottoNumbers.indices, id: \.self) { index in
                    ball(number: lottoNumbers[index])
                }
            }
            
            Button("추첨 시작") {
                self.generateLottoNumbers()
            }
            .buttonStyle(.borderedProminent)
            .tint(.white)
            .foregroundColor(.black)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.blue)
    }
    
    func generateLottoNumbers() {
        var numbers = Set<Int>()
        
        while numbers.count < 6 {
            let randomNum = Int.random(in: 1...45)
            numbers.insert(randomNum)
        }
        
        lottoNumbers = Array(numbers)
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
    
    func ball(number: Int) -> some View {
        return Circle()
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
}

struct GenerateNumberView_Previews: PreviewProvider {
    static var previews: some View {
        GenerateNumberView()
    }
}
