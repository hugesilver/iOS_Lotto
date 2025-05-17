//
//  NaverMapCoordinator.swift
//  Lotto
//
//  Created by 김태은 on 5/15/25.
//

import Foundation
import NMapsMap

final class NaverMapCoordinator: NSObject, ObservableObject, NMFMapViewCameraDelegate, NMFMapViewTouchDelegate, CLLocationManagerDelegate {
    enum AlertType { case location, selectedStore }
    
    @Published var showAlert: Bool = false
    var alertType: AlertType = .location
    var selectedStore: StoreModel?
    
    static let shared = NaverMapCoordinator()
    
    var locationManager: CLLocationManager?
    let view = NMFNaverMapView(frame: .zero)
    let viewModel = MapViewModel()
    var stores: [StoreModel] = []
    var markers: [NMFMarker] = []
    
    override init() {
        super.init()
        
        // mapView 기본 설정
        view.mapView.lightness = 0.2
        view.showZoomControls = true
        view.showLocationButton = true
        view.mapView.zoomLevel = 16
        view.showScaleBar = true
        
        view.mapView.addCameraDelegate(delegate: self)
        view.mapView.touchDelegate = self
        
        // 복권판매점 리스트 불러오기
        self.getStoreList()
    }
    
    // 카메라 이동이 끝났을 때
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        // 마커 불러오기
        let cameraPosition = mapView.cameraPosition.target
        makeMarkers(lat: cameraPosition.lat, lng: cameraPosition.lng)
    }
    
    // 위치권한 부여
    func checkIfLocationServiceIsEnabled() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self.locationManager = CLLocationManager()
                    self.locationManager!.delegate = self
                    self.checkLocationAuthorization()
                }
            } else {
                print("위치 정보 거부")
            }
        }
    }
    
    // 위치권한 확인
    func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("위치 정보 접근이 제한되었습니다.")
        case .denied:
            print("위치 정보 접근을 거절했습니다. 설정에 가서 변경하세요.")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.alertType = .location
                self.showAlert = true
            }
        case .authorizedAlways, .authorizedWhenInUse:
            fetchUserLocation()
            
        @unknown default:
            break
        }
    }
    
    // 나의 위치 찾기
    private func fetchUserLocation() {
        view.mapView.positionMode = .direction
        
        if let locationManager = locationManager {
            let lat = locationManager.location?.coordinate.latitude
            let lng = locationManager.location?.coordinate.longitude
            
            guard let lat = lat, let lng = lng else { return }
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
            cameraUpdate.animation = .fly
            cameraUpdate.animationDuration = 1
            
            view.mapView.moveCamera(cameraUpdate)
        }
    }
    
    // 복권판매점 리스트 불러오기
    private func getStoreList() {
        if stores.isEmpty {
            stores = viewModel.loadStoresFromCSV()
        }
    }
    
    // 마커 불러오기
    private func makeMarkers(lat: Double, lng: Double) {
        let coord = CLLocation(latitude: lat, longitude: lng)
        
        let nearbyStores = stores.filter { store in
            let storeLocation = CLLocation(latitude: store.lat, longitude: store.lng)
            return coord.distance(from: storeLocation) <= 1000
        }
        
        // 기존 마커 제거
        markers.forEach { $0.mapView = nil }
        markers.removeAll()
        
        // 마커 추가
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            for store in nearbyStores {
                let marker = NMFMarker(position: NMGLatLng(lat: store.lat, lng: store.lng))
                marker.tag = UInt(store.id)
                marker.iconImage = NMFOverlayImage(image: UIImage.mapPin)
                marker.width = 34
                marker.height = 51
                marker.captionText = store.name
                marker.captionRequestedWidth = 80
                marker.captionAligns = [NMFAlignType.bottom]
                marker.mapView = view.mapView
                
                marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                    guard let self = self else { return true }
                    
                    if let marker = overlay as? NMFMarker {
                        if let store = self.stores.first(where: { $0.id == Int(marker.tag) }) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.alertType = .selectedStore
                                self.showAlert = true
                                self.selectedStore = store
                            }
                        }
                    }
                    
                    return true
                }
                
                markers.append(marker)
            }
        }
    }
}
