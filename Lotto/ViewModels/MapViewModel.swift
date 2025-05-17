//
//  MapViewModel.swift
//  Lotto
//
//  Created by 김태은 on 5/16/25.
//

import Foundation

class MapViewModel {
    func loadStoresFromCSV() -> [StoreModel] {
        guard let path = Bundle.main.path(forResource: "lotto_store_coords", ofType: "csv") else { return [] }
        
        do {
            let content = try String(contentsOfFile: path)
            let rows = content.components(separatedBy: "\n").dropFirst()
            var stores: [StoreModel] = []
            
            for (index, row) in rows.enumerated() {
                let columns = row.components(separatedBy: ",")
                guard columns.count > 5,
                      let lng = Double(columns[4]),
                      let lat = Double(columns[5].trimmingCharacters(in: .whitespacesAndNewlines)) else { continue }
                
                stores.append(StoreModel(id: Int(columns[0]) ?? index, name: columns[1], roadAddr: columns[2], jibunAddr: columns[3], lat: lat, lng: lng))
            }
            
            return stores
        } catch {
            print("CSV 읽기 오류: \(error)")
            return []
        }
    }
}
