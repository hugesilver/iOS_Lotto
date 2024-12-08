//
//  ScannerView.swift
//  Lotto
//
//  Created by 김태은 on 12/8/24.
//

import SwiftUI
import AVKit

struct ScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    
    @StateObject private var qrDelegate = QRScannerDelegate()
    
    // QR 코드 스캐너 속성
    @State private var session: AVCaptureSession = .init()
    
    // QR 코드 스캐너 AV 출력
    @State private var qrOutput: AVCaptureMetadataOutput = .init()
    
    // 알림창
    @State private var message: String = ""
    @State private var showAlert: Bool = false
    
    // QR 스캔된 코드
    @State private var scannedCode: String = ""
    
    
    var body: some View {
        ZStack {
            CameraView(frameSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), session: $session)
            
            Group {
                ForEach(0...4, id: \.self) { index in
                    let rotation = Double(index) * 90
                    
                    RoundedRectangle(cornerRadius: 2, style: .circular)
                        .trim(from: 0.61, to: 0.64)
                        .stroke(.white, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                        .rotationEffect(Angle(degrees: rotation))
                }
            }
            .frame(width: 250, height: 250)
            .overlay(
                Text("로또 용지의 QR 코드를 스캔")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .offset(y: -150)
                , alignment: .top
            )
        }
        .onAppear {
            checkCameraPermission()
        }
        .onDisappear {
            session.stopRunning()
            clearSession()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("오류"),
                message: Text(message),
                primaryButton: .default(Text("설정으로 이동")) {
                    let settingString = UIApplication.openSettingsURLString
                    if let settingsURL = URL(string: settingString) {
                        openURL(settingsURL)
                    }
                },
                secondaryButton: .cancel(Text("취소")) {
                    dismiss()
                }
            )
        }
        .onChange(of: qrDelegate.scannedCode) { code in
            if let scanned = code {
                scannedCode = scanned
                session.stopRunning()
                qrDelegate.scannedCode = nil
            }
        }
        
    }
    
    // 카메라 설정
    func setupCamera() {
        do {
            guard let device = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
                showError("알 수 없는 오류가 발생하였습니다.")
                return
            }
            
            let input = try AVCaptureDeviceInput(device: device)
            
            guard session.canAddInput(input), session.canAddOutput(qrOutput) else {
                showError("알 수 없는 오류가 발생하였습니다.")
                return
            }
            
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            
            qrOutput.metadataObjectTypes = [.qr]
            qrOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            
            session.commitConfiguration()
            
            // session은 백그라운드 스레드에서 시작
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
        } catch {
            showError(error.localizedDescription)
        }
    }
    
    // 오류 메시지 알림창 출력
    func showError(_ message: String) {
        self.message = message
        showAlert.toggle()
    }
    
    // 카메라 권한 체크
    func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                setupCamera()
            case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video) {
                    setupCamera()
                } else {
                    showError("카메라 허용이 필요합니다.")
                }
            case .denied, .restricted:
                showError("카메라 허용이 필요합니다.")
            default: break
            }
        }
    }
    
    // 세션 초기화
    func clearSession() {
        for input in session.inputs {
            session.removeInput(input)
        }
        
        for output in session.outputs {
            session.removeOutput(output)
        }
    }
}

#Preview {
    ScannerView()
}
