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
    
    @StateObject var viewModel = LottoViewModel()
    
    // 로또 데이터
    @State private var model: LottoModel?
    
    // 당첨번호
    @State private var numbers: [Int] = []
    
    // 사용자의 당첨 결과
    @State private var results: [Float] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // 선택한 번호
                VStack(spacing: 0) {
                    Text("선택한 번호")
                        .font(.system(size: 24).bold())
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    VStack(spacing: 8) {
                        // splitedStrings의 첫번째 요소를 제외한 반복문 실행
                        ForEach(1...splitedStrings.count - 1, id: \.self) { i in
                            HStack {
                                // 12글자를 2글자씩 나누기
                                let ballRow = stride(from: 0, to: splitedStrings[i].count, by: 2).compactMap { j -> Int? in
                                    let startIndex = splitedStrings[i].index(splitedStrings[i].startIndex, offsetBy: j)
                                    let endIndex = splitedStrings[i].index(after: startIndex)
                                    
                                    return Int(splitedStrings[i][startIndex...endIndex])
                                }
                                
                                ForEach(ballRow, id: \.self) { ballNumber in
                                    let isContain: Bool = numbers.contains(ballNumber)
                                    let showBonusNumber: Bool = model != nil && results.count > i - 1 && results[i - 1] == 5.5 && ballNumber == model!.bnusNo
                                    
                                    ResultBall(number: ballNumber, isSelected: isContain || showBonusNumber)
                                }
                            }
                        }
                    }
                    .padding(.top, 24)
                }
                
                // 당첨결과
                if model != nil {
                    calcWinning()
                        .font(.system(size: 20).bold())
                        .multilineTextAlignment(.center)
                        .padding(.top, 32)
                }
                
                // 로또 데이터
                Group {
                    if let model = model {
                        VStack(spacing: 0) {
                            Text("로또 6/45 제\(model.drwNo)회")
                                .font(.system(size: 24).bold())
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                            
                            Text("\(model.drwNoDate) 추첨")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.top, 4)
                            
                            Text("당첨번호")
                                .font(.system(size: 16).bold())
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.top, 24)
                            
                            HStack {
                                Ball(number: model.drwtNo1)
                                Ball(number: model.drwtNo2)
                                Ball(number: model.drwtNo3)
                                Ball(number: model.drwtNo4)
                                Ball(number: model.drwtNo5)
                                Ball(number: model.drwtNo6)
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .font(Font.title.weight(.medium))
                                    .foregroundColor(.black)
                                Ball(number: model.bnusNo)
                            }
                            .padding(.top, 8)
                            
                            Group {
                                Text("총 당첨금: ")
                                    .foregroundColor(.black) +
                                Text("₩\(convertToCommas(model.firstAccumamnt) ?? "0")")
                                    .foregroundColor(.blue)
                            }
                            .font(.system(size: 20).bold())
                            .multilineTextAlignment(.center)
                            .padding(.top, 32)
                            
                            Text("1등 당첨금: ₩\(convertToCommas(model.firstWinamnt) ?? "0") x \(model.firstPrzwnerCo)명")
                                .font(.system(size: 16).bold())
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.top, 8)
                            
                            Text("총 판매액: ₩\(convertToCommas(model.totSellamnt) ?? "0")")
                                .font(.system(size: 16).bold())
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.top, 32)
                        }
                    } else {
                        Text("로또 6/45 제\(convertToCommas(Int(splitedStrings[0])!) ?? "0")회\n데이터를 불러올 수 없습니다.")
                            .font(.system(size: 20).bold())
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.top, 48)
                .padding(.bottom, 8)
                
                Link(destination: URL(string: scannedCode)!) {
                    Text("자세히 보기")
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 32)
                .padding(.bottom, 8)
            }
        }
        .navigationTitle("")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .onAppear {
            results = Array(repeating: 0, count: splitedStrings.count - 1)
            
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
    func calcResult() {
        // splitedStrings의 첫번째 요소를 제외한 반복문 실행
        for (i, string) in splitedStrings.dropFirst().enumerated() {
            // 12글자를 2글자씩 나누기
            for j in stride(from: 0, to: string.count, by: 2) {
                let startIndex = string.index(string.startIndex, offsetBy: j)
                let endIndex = string.index(after: startIndex)
                let ballNumber = Int(string[startIndex...endIndex]) ?? 0
                
                // 당첨 번호 확인 및 결과 반영
                if results.count > i {
                    if numbers.contains(ballNumber) {
                        results[i] += 1
                    } else if let model = model, ballNumber == model.bnusNo {
                        results[i] += 0.5
                    }
                }
            }
        }
        
        print(results)
    }
    
    // 당첨 결과 계산
    func calcWinning() -> Text {
        let ranks: [Int] = [
            results.filter { $0 == 6 }.count,
            results.filter { $0 == 5.5 }.count,
            results.filter { $0 == 5 }.count,
            results.filter { $0 >= 4 && $0 <= 4.5 }.count,
            results.filter { $0 >= 3 && $0 <= 3.5 }.count
        ]
        
        if ranks.allSatisfy({ $0 == 0 }) {
            return Text(verbatim: "당첨결과: 낙첨")
        }
        
        let rankText = ranks
            .enumerated()
            .compactMap { (index, item) -> String? in
                item > 0 ? "\(index + 1)등 \(item)개" : nil
            }
            .joined(separator: ", ")
        
        return Text(verbatim: "당첨결과: \(rankText)")
    }
}

#Preview {
    ScanResultView(scannedCode: "http://m.dhlottery.co.kr/?v=1150q181923264244q101325273032q071623343641q040608122638q1620213341441726684384", splitedStrings: ["1150", "080918353925", "080925183032", "071623343641", "040608122638", "162021334125"])
}
