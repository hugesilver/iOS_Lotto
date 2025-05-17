//
//  StoreModel.swift
//  Lotto
//
//  Created by 김태은 on 5/16/25.
//

import Foundation

struct StoreModel: Identifiable, Decodable {
    let id: Int
    let name: String
    let roadAddr: String
    let jibunAddr: String
    let lat: Double
    let lng: Double
}
