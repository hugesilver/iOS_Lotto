//
//  MapView.swift
//  Lotto
//
//  Created by 김태은 on 5/14/25.
//

import SwiftUI
import NMapsMap
import CoreLocation

struct MapView: View {
    @StateObject private var naverMapCoordinator = NaverMapCoordinator.shared
    
    var body: some View {
        NaverMapView()
            .alert(isPresented: $naverMapCoordinator.showAlert) {
                switch naverMapCoordinator.alertType {
                case .location:
                    return Alert(
                        title: Text("오류"),
                        message: Text("위치 권한을 허용하지 않으면 현 위치를 볼 수 없습니다."),
                        primaryButton: .cancel(Text("닫기")) {},
                        secondaryButton: .default(Text("설정")) {
                            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            }
                        }
                    )
                case .selectedStore:
                    if let selectedStore = naverMapCoordinator.selectedStore {
                        return Alert(
                            title: Text(selectedStore.name),
                            message: Text(selectedStore.roadAddr),
                            primaryButton: .cancel(Text("닫기")),
                            secondaryButton: .default(Text("길찾기")) {
                                if let url = URL(string: "https://map.naver.com/v5/search/\(selectedStore.roadAddr.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "+"))") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        )
                    } else {
                        return Alert(title: Text("오류"), message: Text("선택된 가게 정보가 없습니다."), dismissButton: .default(Text("확인")))
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
    }
}

struct NaverMapView: UIViewRepresentable {
    func makeCoordinator() -> NaverMapCoordinator {
        NaverMapCoordinator.shared
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let coordinator = context.coordinator
        coordinator.checkIfLocationServiceIsEnabled()
        
        return coordinator.view
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {}
}


#Preview {
    MapView()
}
