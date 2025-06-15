//
//  QRScannerDelegate.swift
//  Lotto
//
//  Created by 김태은 on 12/8/24.
//

import SwiftUI
import AVKit

class QRScannerDelegate: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    @Published var scannedCode: String = ""
    @Published var splitedString: [String] = []
    
    // 알림
    @Published var message: String = ""
    @Published var showAlert: Bool = false
    
    // 스캔 결과 뷰 이동
    @Published var isPresented: Bool = false
    
    // 오류 메시지 알림창 출력
    func showError(_ message: String) {
        self.message = message
        showAlert.toggle()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metaObject = metadataObjects.first {
            guard let readableObject = metaObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let code = readableObject.stringValue else { return }
            
            print(code)
            scannedCode = code
        }
    }
    
    func splitString(code: String) {
        let regexPattern = #"^https?://m\.dhlottery\.co\.kr/\?v=(\d{1,5})m(\d{12})(m\d{12})*(n\d{12})*(m|n)(\d{22})$"#
        
        do {
            let regex = try NSRegularExpression(pattern: regexPattern)
            let range = NSRange(code.startIndex..., in: code)
            
            if regex.firstMatch(in: code, range: range) != nil {
                // url 내 번호 추출
                let prepare = code.components(separatedBy: "?v=")[1]
                var splited = prepare.components(separatedBy: "m")
                
                if let lastElement = splited.last?.components(separatedBy: "n") {
                    splited[splited.count - 1] = String(lastElement.first!.prefix(12))
                }
                
                // 분할 가공한 문자열 삽입
                splitedString = splited
                
                // 스캔 결과 뷰 이동
                self.isPresented = true
            } else {
                print("URL이 조건에 맞지 않습니다.")
                showError("로또 용지의 QR코드를 인식해주세요.")
            }
        } catch {
            print("QR 데이터 정규식 오류: \(error.localizedDescription)")
            showError("로또 용지의 QR코드를 인식해주세요.")
        }
    }
}
