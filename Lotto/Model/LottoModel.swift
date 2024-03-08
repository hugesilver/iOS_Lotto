//
//  LottoModel.swift
//  Lotto
//
//  Created by 김태은 on 11/27/23.
//

import Foundation

struct LottoModel : Hashable, Decodable {
    var totSellamnt: Int?
    var returnValue: String?
    var drwNoDate: String?
    var firstWinamnt: Int?
    var drwtNo6: Int?
    var drwtNo4: Int?
    var firstPrzwnerCo: Int?
    var drwtNo5: Int?
    var bnusNo: Int?
    var firstAccumamnt: Int?
    var drwNo: Int?
    var drwtNo2: Int?
    var drwtNo3: Int?
    var drwtNo1: Int?
    
    init?(totSellamnt: Int?, returnValue: String?, drwNoDate: String?, firstWinamnt: Int?, drwtNo6: Int?, drwtNo4: Int?, firstPrzwnerCo: Int?, drwtNo5: Int?, bnusNo: Int?, firstAccumamnt: Int?, drwNo: Int?, drwtNo2: Int?, drwtNo3: Int?, drwtNo1: Int?) {
        guard let totSellamnt = totSellamnt,
              let returnValue = returnValue,
              let drwNoDate = drwNoDate,
              let firstWinamnt = firstWinamnt,
              let drwtNo6 = drwtNo6,
              let drwtNo4 = drwtNo4,
              let firstPrzwnerCo = firstPrzwnerCo,
              let drwtNo5 = drwtNo5,
              let bnusNo = bnusNo,
              let firstAccumamnt = firstAccumamnt,
              let drwNo = drwNo,
              let drwtNo2 = drwtNo2,
              let drwtNo3 = drwtNo3,
              let drwtNo1 = drwtNo1
        else {
            return nil
        }
        
        self.totSellamnt = totSellamnt
        self.returnValue = returnValue
        self.drwNoDate = drwNoDate
        self.firstWinamnt = firstWinamnt
        self.drwtNo6 = drwtNo6
        self.drwtNo4 = drwtNo4
        self.firstPrzwnerCo = firstPrzwnerCo
        self.drwtNo5 = drwtNo5
        self.bnusNo = bnusNo
        self.firstAccumamnt = firstAccumamnt
        self.drwNo = drwNo
        self.drwtNo2 = drwtNo2
        self.drwtNo3 = drwtNo3
        self.drwtNo1 = drwtNo1
    }
}
