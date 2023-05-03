
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencySelector: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        coinManager.delegate = self
        currencySelector.delegate = self
        currencySelector.dataSource = self
    }

}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate{
    func didUpdatePrices(_ coinManager: CoinManager, coin: CoinModel) {
        DispatchQueue.main.async{
            self.priceLabel.text = coin.rateString
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}

//MARK: - UIPickerViewDelegate and UIPickerViewDataSource

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyLabel.text = coinManager.currencyArray[row]
        coinManager.fetchCurrentPrice(currency: coinManager.currencyArray[row])
    }
}

