//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDataSource{
   
    
    
    

    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    
    @IBOutlet weak var currencyLabel: UILabel!
    
    var currency:String?
    var coinManager=CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        currencyPicker.dataSource=self
        currencyPicker.delegate=self
        coinManager.delegate=self
    }
    
    
    
    
}

//MARK: - CoinManagerDelegate
extension ViewController : CoinManagerDelegate{
    func didCoinUpdate(coinModel: CoinModel) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text=String(format: "%.3f", coinModel.rate)
            self.currencyLabel.text=self.currency!
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UIPickerViewDelegate
extension ViewController : UIPickerViewDelegate{
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
        currency=coinManager.currencyArray[row]
        coinManager.fetchRate(currency: coinManager.currencyArray[row])
    }
}
