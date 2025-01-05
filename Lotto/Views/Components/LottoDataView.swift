//
//  LottoDetailView.swift
//  Lotto
//
//  Created by 김태은 on 1/5/25.
//

import SwiftUI

struct LottoDataView: View {
    // 로또 데이터
    let model: LottoModel
    let url: String
    
    var body: some View {
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
                .padding(.top, 40)
            
            
            // 로또 홈페이지 링크
            Link(destination: URL(string: url)!) {
                Text("자세히 보기")
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 32)
            .padding(.bottom, 8)
        }
    }
}
