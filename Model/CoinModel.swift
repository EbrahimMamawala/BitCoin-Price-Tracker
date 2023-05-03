
import Foundation

struct CoinModel{
    let rate: Double
    
    var rateString: String{
        let roundedRate = round(rate*100)/100.0
        return String(roundedRate)
    }
    
}
