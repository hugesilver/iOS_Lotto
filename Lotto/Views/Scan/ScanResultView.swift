//
//  ScanResultView.swift
//  Lotto
//
//  Created by 김태은 on 12/9/24.
//

import SwiftUI

struct ScanResultView: View {
    let scannedCode: String
    let splitedStrings: [String]
    
    @StateObject private var viewModel = LottoViewModel()
    
    // 로또 데이터
    @State private var model: LottoModel?
    
    // 당첨번호
    @State private var numbers: [Int] = []
    
    // 행마다 맞춘 공 개수
    @State private var matchedBalls: [Float] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // 선택한 번호와 당첨결과
                ScanResultSelectedNumbersView(
                    splitedStrings: splitedStrings,
                    model: $model,
                    numbers: $numbers,
                    matchedBalls: $matchedBalls
                )
                
                // 로또 데이터
                Group {
                    if let model = model {
                        LottoDataView(model: model, url: scannedCode)
                    } else {
                        Text("로또 6/45 제\(convertToCommas(Int(splitedStrings[0])!) ?? "0")회\n데이터를 불러올 수 없습니다.")
                            .font(.system(size: 20).bold())
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.top, 48)
                .padding(.bottom, 8)
            }
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .onAppear {
            matchedBalls = Array(repeating: 0, count: splitedStrings.count - 1)
            
            viewModel.fetchLottoNumbers(drawNumber: Int(splitedStrings[0])!) { model in
                
                if let model = model {
                    self.numbers.append(model.drwtNo1)
                    self.numbers.append(model.drwtNo2)
                    self.numbers.append(model.drwtNo3)
                    self.numbers.append(model.drwtNo4)
                    self.numbers.append(model.drwtNo5)
                    self.numbers.append(model.drwtNo6)
                }
                
                self.model = model
                
                calcResult()
            }
        }
    }
    
    // 선택한 번호 일치 확인
    private func calcResult() {
        // splitedStrings의 첫번째 요소를 제외한 반복문 실행
        for (i, string) in splitedStrings.dropFirst().enumerated() {
            // 12글자를 2글자씩 나누기
            let ballNumbers: [Int] = divideNumbers(string)
            
            // 당첨 번호 확인 및 결과 반영
            for ball in ballNumbers {
                if matchedBalls.count > i {
                    if numbers.contains(ball) {
                        matchedBalls[i] += 1
                    } else if let model = model, ball == model.bnusNo {
                        matchedBalls[i] += 0.5
                    }
                }
            }
        }
    }
}

// 선택한 번호와 당첨결과 뷰
struct ScanResultSelectedNumbersView: View {
    let splitedStrings: [String]
    @Binding var model: LottoModel?
    @Binding var numbers: [Int]
    @Binding var matchedBalls: [Float]
    
    var body: some View {
        Group {
            // 선택한 번호
            Text("선택한 번호")
                .font(.system(size: 24).bold())
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 8) {
                // splitedStrings의 첫번째 요소를 제외한 반복문 실행
                ForEach(1...splitedStrings.count - 1, id: \.self) { i in
                    HStack {
                        // 12글자를 2글자씩 나누기
                        let ballNumbers: [Int] = divideNumbers(splitedStrings[i])
                        
                        ForEach(ballNumbers, id: \.self) { ballNumber in
                            let isContain: Bool = numbers.contains(ballNumber)
                            let showBonusNumber: Bool = model != nil && matchedBalls.count > i - 1 && matchedBalls[i - 1] == 5.5 && ballNumber == model!.bnusNo
                            
                            ResultBall(number: ballNumber, isSelected: isContain || showBonusNumber)
                        }
                    }
                }
            }
            .padding(.top, 24)
            
            // 당첨결과
            if model != nil {
                resultText()
                    .font(.system(size: 20).bold())
                    .multilineTextAlignment(.center)
                    .padding(.top, 32)
            }
        }
    }
    
    // 당첨 결과 계산
    private func resultText() -> Text {
        var rankTexts: [String] = []
        
        let ranks: [Int] = [
            matchedBalls.filter { $0 == 6 }.count,
            matchedBalls.filter { $0 == 5.5 }.count,
            matchedBalls.filter { $0 == 5 }.count,
            matchedBalls.filter { $0 >= 4 && $0 <= 4.5 }.count,
            matchedBalls.filter { $0 >= 3 && $0 <= 3.5 }.count
        ]
        
        if ranks.allSatisfy({ $0 == 0 }) {
            return Text(verbatim: "당첨결과: 낙첨")
        }
        
        for (index, item) in ranks.enumerated() {
            if item > 0 {
                rankTexts.append("\(index + 1)등 \(item)개")
            }
        }
        
        return Text(verbatim: "당첨결과: \(rankTexts.joined(separator: ", "))")
    }
}

// 12글자를 2글자씩 나누기
fileprivate func divideNumbers(_ string: String) -> [Int] {
    var numbers: [Int] = []
    
    for i in stride(from: 0, to: string.count, by: 2) {
        let startIndex = string.index(string.startIndex, offsetBy: i)
        let endIndex = string.index(after: startIndex)
        
        numbers.append(Int(string[startIndex...endIndex]) ?? 0)
    }
    
    return numbers
}

#Preview {
    ScanResultView(scannedCode: "http://m.dhlottery.co.kr/?v=1150q181923264244q101325273032q071623343641q040608122638q1620213341441726684384", splitedStrings: ["1150", "080918353925", "080925183032", "071623343641", "040608122638", "162021334125"])
}
