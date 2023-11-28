import Foundation

class WinnerListViewModel : ObservableObject{
    func fetchLottoNumbers(drawNumber: Int, completion: @escaping (LottoModel?) -> Void) {
        // Construct the URL for the Lotto API with the specified draw number
        let urlString = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(drawNumber)"
        
        // Perform the API request
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                                        print("Received JSON data: \(jsonString)")
                                    }
                    
                    // Parse the response data (assuming it's JSON)
                    
                    do {
                        let decoder = JSONDecoder()
                        let lottoModel = try decoder.decode(LottoModel.self, from: data)
                        
                        // Call the completion handler with the decoded LottoModel
                        completion(lottoModel)
                    } catch {
                        //                        print("Error parsing JSON: \(error)")
                        print("Error parsing JSON: \(error.localizedDescription)")
                        // Call the completion handler with nil to indicate an error
                        completion(nil)
                    }
                } else if let error = error {
                    print("Error fetching Lotto numbers: \(error)")
                    // Call the completion handler with nil to indicate an error
                    completion(nil)
                }
            }
            task.resume()
        }
    }
}
