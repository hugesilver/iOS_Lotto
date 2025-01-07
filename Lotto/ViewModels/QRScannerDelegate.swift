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
        let regexPattern = #"^http://m\.dhlottery\.co\.kr/\?v=(\d{1,5})q(\d{12})(q\d{12})*(n\d{12})*(q|n)(\d{22})$"#
        
        do {
            let regex = try NSRegularExpression(pattern: regexPattern)
            let range = NSRange(code.startIndex..., in: code)
            
            if regex.firstMatch(in: code, range: range) != nil {
                // q 기준으로 문자열 나눔
                var splitByQ = code.components(separatedBy: "q")
                
                // 첫번째 요소의 링크 제거
                if let firstElement = splitByQ.first, let vRange = firstElement.range(of: "?v=") {
                    splitByQ[0] = String(firstElement[vRange.upperBound...])
                }
                
                // 마지막 요소의 12자 추출
                if let lastElement = splitByQ.last {
                    let trimmedLast = lastElement.prefix(12)
                    splitByQ[splitByQ.count - 1] = String(trimmedLast)
                }
                
                let result = splitByQ.map { String($0) }
                
                // 분할 가공한 문자열 삽입
                splitedString = result
                
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
