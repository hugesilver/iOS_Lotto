//
//  LatestLottoView.swift
//  Lotto
//
//  Created by 김태은 on 11/7/23.
//

import SwiftUI

struct LatestLottoView: View {
    @StateObject var viewModel = WinnerListViewModel()
    @State var latestLottoes: [LottoModel] = []
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(sortedLottoes(), id: \.self) { latestLotto in
                    VStack {
                        Text("\(latestLotto.drwNoDate) \(latestLotto.drwNo)회 당첨결과")
                            .font(.system(size: 24).bold())
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding()
                        HStack {
                            ball(number: latestLotto.drwtNo1)
                            ball(number: latestLotto.drwtNo2)
                            ball(number: latestLotto.drwtNo3)
                            ball(number: latestLotto.drwtNo4)
                            ball(number: latestLotto.drwtNo5)
                            ball(number: latestLotto.drwtNo6)
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 22, height: 22)
                                .font(Font.title.weight(.medium))
                                .foregroundColor(.black)
                            ball(number: latestLotto.bnusNo)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear{
            latestLotto()
        }
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
    
    func latestLotto() {
        // Your existing code to calculate weeks passed...
        let weeksPassed = calculateWeeksPassed()
        for i in 0...10 {
            if latestLottoes.count > 9 || weeksPassed - i < 1 {
                break
            }
            // Call the function to fetch Lotto numbers for the latest draw
            viewModel.fetchLottoNumbers(drawNumber: weeksPassed - i) { lottoModel in
                if let lottoModel = lottoModel {
                    if lottoModel.returnValue == "fail" {
                        
                    } else {
                        latestLottoes.append(lottoModel)
                    }
                } else {
                    // Error occurred or nil data received
                    print("Failed to fetch LottoModel")
                }
            }
        }
    }
    
    func sortedLottoes() -> [LottoModel] {
        return latestLottoes.sorted { $0.drwNo > $1.drwNo }
    }
    
    func calculateWeeksPassed() -> Int {
        let startDateComponents = DateComponents(year: 2002, month: 12, day: 7)
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "KST")!
        let startDate = calendar.date(from: startDateComponents)!
        
        // Find the most recent Saturday
        let today = Calendar.current
        let date = today.date(byAdding: .day, value: -1, to: Date())
        let mostRecentSaturday = calendar.nextDate(after: date!,
                                                   matching: DateComponents(weekday: 7),
                                                   matchingPolicy: .previousTimePreservingSmallerComponents)!
        
        let weeksPassed = calendar.dateComponents([.weekOfYear], from: startDate, to: mostRecentSaturday).weekOfYear!
        
        return weeksPassed
    }
}


#Preview {
    LatestLottoView()
}
