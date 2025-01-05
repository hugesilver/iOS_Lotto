//
//  DetailView.swift
//  Lotto
//
//  Created by 김태은 on 11/16/24.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    let model: LottoModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                LottoDataView(model: model, url: "https://m.dhlottery.co.kr/gameResult.do?method=byWin&drwNo=\(model.drwNo)")
                    .padding(.vertical, 8)
            }
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
    }
}

#Preview {
    DetailView(model: LottoModel(returnValue: "", drwNo: 1234, drwNoDate: "2024-11-16", totSellamnt: 0, firstAccumamnt: 0, firstWinamnt: 0, firstPrzwnerCo: 0, drwtNo1: 0, drwtNo2: 0, drwtNo3: 0, drwtNo4: 0, drwtNo5: 0, drwtNo6: 0, bnusNo: 0))
}
