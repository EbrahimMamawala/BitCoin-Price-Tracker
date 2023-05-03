
import Foundation

protocol CoinManagerDelegate{
    func didUpdatePrices(_ coinManager: CoinManager ,coin: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "30E527A5-BAF1-4042-8A6B-FB817A85F313"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func fetchCurrentPrice(currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        // Create a URL
        if let url = URL(string: urlString){
            // Create a URLSession
            
            let session = URLSession(configuration: .default)
            
            // Give the session a task
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let coin = self.parseJSON(safeData){
                        self.delegate?.didUpdatePrices(self, coin: coin)
                    }
                }
            }
            
            // Start the task
            task.resume()
        }
        
    }
    
    func parseJSON(_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let rate = decodedData.rate
            
            let coin = CoinModel(rate: rate)
            return coin
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
}
