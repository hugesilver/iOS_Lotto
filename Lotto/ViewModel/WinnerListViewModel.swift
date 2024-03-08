import Foundation

class WinnerListViewModel : ObservableObject{
    func fetchLottoNumbers(drawNumber: Int, completion: @escaping (LottoModel?) -> Void) {
        // 로또 API URL
        let urlString = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(drawNumber)"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        
        // API 요청
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                // 데이터 확인
                // if let jsonString = String(data: data, encoding: .utf8) {
                //  print("Received JSON data: \(jsonString)")
                // }
                
                do {
                    // LottoModel로 JSON 디코드
                    let decoder = JSONDecoder()
                    let lottoModel = try decoder.decode(LottoModel.self, from: data)
                    
                    completion(lottoModel)
                } catch {
                    print("JSON 파싱 에러: \(error.localizedDescription)")
                    
                    completion(nil)
                }
            } else if let error = error {
                print("API를 불러오는 중 에러 발생: \(error.localizedDescription)")
                
                completion(nil)
            }
        }
        .resume() // API 요청 시작
    }
}
