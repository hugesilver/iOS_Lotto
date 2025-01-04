//
//  LottoModel.swift
//  Lotto
//
//  Created by 김태은 on 11/27/23.
//

import Foundation

struct LottoModel: Identifiable, Codable {
    let totSellamnt: Int
    let returnValue: String
    let drwNoDate: String
    let firstWinamnt: Int
    let drwtNo6: Int
    let drwtNo4: Int
    let firstPrzwnerCo: Int
    let drwtNo5: Int
    let bnusNo: Int
    let firstAccumamnt: Int
    let drwNo: Int
    let drwtNo2: Int
    let drwtNo3: Int
    let drwtNo1: Int
    
    var id: Int {
        drwNo
    }
}
