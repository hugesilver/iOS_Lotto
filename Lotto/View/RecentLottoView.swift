//
//  LatestLottoView.swift
//  Lotto
//
//  Created by 김태은 on 11/7/23.
//

import SwiftUI

struct LatestLottoView: View {
    @StateObject var viewModel = WinnerListViewModel()
    @State var recentLottoes: [LottoModel] = []
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(sortRecentLotto(), id: \.self) { recentLotto in
                    VStack {
                        Text("\(recentLotto.drwNoDate!) \(recentLotto.drwNo!)회 당첨결과")
                            .font(.system(size: 24).bold())
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        HStack {
                            ball(number: recentLotto.drwtNo1!)
                            ball(number: recentLotto.drwtNo2!)
                            ball(number: recentLotto.drwtNo3!)
                            ball(number: recentLotto.drwtNo4!)
                            ball(number: recentLotto.drwtNo5!)
                            ball(number: recentLotto.drwtNo6!)
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 22, height: 22)
                                .font(Font.title.weight(.medium))
                                .foregroundColor(.black)
                            ball(number: recentLotto.bnusNo!)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear{
            getRecentLotto()
        }
    }
    
    func calculateWeeksPassed() -> Int {
        // 로또 첫 추첨 날짜 2002.12.7
        let startDate = Calendar.current.date(from: DateComponents(year: 2002, month: 12, day: 7))!
        
        // 현재 날짜
        var calendar = Calendar.current
        
        // 한국 표준시간 기준
        calendar.timeZone = TimeZone(abbreviation: "KST")!
        
        // 당일이 아닌 명일 기준으로
        let date = calendar.date(byAdding: .day, value: -1, to: Date())
        
        // 가장 최근의 토요일
        let mostRecentSaturday = calendar.nextDate(after: date!, matching: DateComponents(weekday: 7), matchingPolicy: .previousTimePreservingSmallerComponents)!
        
        // 몇 주가 지났는지 계산
        let weeksPassed = calendar.dateComponents([.weekOfYear], from: startDate, to: mostRecentSaturday).weekOfYear!
        
        return weeksPassed
    }
    
    func getRecentLotto() {
        let weeksPassed = calculateWeeksPassed()
        
        for i in 0...10 {
            if recentLottoes.count > 9 || weeksPassed - i < 1 {
                break
            }
            
            viewModel.fetchLottoNumbers(drawNumber: weeksPassed - i) { lottoModel in
                if let lottoModel = lottoModel, lottoModel.returnValue == "success" {
                    recentLottoes.append(lottoModel)
                } else {
                    print("LottoModel fetch 실패")
                }
            }
        }
    }
    
    func sortRecentLotto() -> [LottoModel] {
        return recentLottoes.sorted { $0.drwNo! > $1.drwNo! }
    }
    
    func ball(number: Int) -> some View {
        return Circle()
            .frame(width: 40, height: 40)
            .foregroundColor(colors(number: number))
            .overlay(Text("\(number)")
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
    LatestLottoView()
}
