//
//  Utils.swift
//  Lotto
//
//  Created by 김태은 on 1/5/25.
//

import Foundation

func convertToCommas(_ number: Int) -> String? {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    let formattedNumber = numberFormatter.string(from: NSNumber(value: number))
    
    return formattedNumber
}
