//
//  LottoModel.swift
//  Lotto
//
//  Created by 김태은 on 11/27/23.
//

import Foundation

struct LottoModel: Identifiable, Codable {
    let returnValue: String // 요청 결과
    let drwNo: Int // 회차 번호
    let drwNoDate: String // 당첨 발표 날짜
    let totSellamnt: Int // 총 판매액
    let firstAccumamnt: Int // 1등 총상금액
    let firstWinamnt: Int // 1등 상금액
    let firstPrzwnerCo: Int // 1등 당첨인원
    let drwtNo1: Int // 1번 번호
    let drwtNo2: Int // 2번 번호
    let drwtNo3: Int // 3번 번호
    let drwtNo4: Int // 4번 번호
    let drwtNo5: Int // 5번 번호
    let drwtNo6: Int // 6번째 번호
    let bnusNo: Int // 보너스 번호
    
    // Identifiable 처리
    var id: Int {
        drwNo
    }
}
