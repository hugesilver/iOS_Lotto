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
                    Ball(number: lottoNumbers[index])
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
}

struct GenerateNumberView_Previews: PreviewProvider {
    static var previews: some View {
        GenerateNumberView()
    }
}
