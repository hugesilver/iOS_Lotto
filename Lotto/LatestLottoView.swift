//
//  LatestLottoView.swift
//  Lotto
//
//  Created by 김태은 on 11/7/23.
//

import SwiftUI

struct LatestLottoView: View {
    var body: some View {
        VStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
    
    func latestLotto() -> Int {
        // Define the start date of the lottery
        let startDateComponents = DateComponents(year: 2002, month: 12, day: 7)
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "KST")!
        let startDate = calendar.date(from: startDateComponents)!
        
        // Find the most recent Saturday
        let date = calendar.date(byAdding: .day, value: -1, to: Date())!
        let mostRecentSaturday = calendar.nextDate(after: date,      matching: DateComponents(weekday: 7),
            matchingPolicy: .previousTimePreservingSmallerComponents)!
        
        // Calculate the number of weeks between the two dates
        let weeksPassed = calendar.dateComponents([.weekOfYear], from: startDate, to: mostRecentSaturday).weekOfYear!
        
        return weeksPassed
    }
}

#Preview {
    LatestLottoView()
}
