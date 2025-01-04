//
//  LatestLottoView.swift
//  Lotto
//
//  Created by 김태은 on 11/7/23.
//

import SwiftUI

struct RecentLottoView: View {
    @StateObject var viewModel = LottoViewModel()
    @State var recentLottoes: [LottoModel] = []
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                Color.clear
                    .frame(height: 16)
                
                ScrollView {
                    VStack {
                        ForEach(sortRecentLotto()) { recentLotto in
                            NavigationLink(destination: DetailView(model: recentLotto)) {
                                VStack(spacing: 0) {
                                    Text("제\(recentLotto.drwNo)회")
                                        .font(.system(size: 24).bold())
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("\(recentLotto.drwNoDate)")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                        .padding(.top, 4)
                                    
                                    HStack {
                                        Ball(number: recentLotto.drwtNo1)
                                        Ball(number: recentLotto.drwtNo2)
                                        Ball(number: recentLotto.drwtNo3)
                                        Ball(number: recentLotto.drwtNo4)
                                        Ball(number: recentLotto.drwtNo5)
                                        Ball(number: recentLotto.drwtNo6)
                                        Image(systemName: "plus")
                                            .resizable()
                                            .frame(width: 16, height: 16)
                                            .font(Font.title.weight(.medium))
                                            .foregroundColor(.black)
                                        Ball(number: recentLotto.bnusNo)
                                    }
                                    .padding(.top, 12)
                                }
                                .padding(.vertical, 12)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
        }
        .navigationTitle("")
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
        return recentLottoes.sorted { $0.drwNo > $1.drwNo }
    }
}

#Preview {
    RecentLottoView()
}
