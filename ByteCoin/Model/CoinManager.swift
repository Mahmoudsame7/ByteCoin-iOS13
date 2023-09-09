//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation
protocol CoinManagerDelegate {
    func didCoinUpdate(coinModel : CoinModel)
    func didFailWithError(error : Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "827D11C1-FF2F-450C-9097-7A6A2EF88D43"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate : CoinManagerDelegate?

    
    
    func fetchRate(currency : String){
        let url="\(baseURL)\(currency)?apikey=\(apiKey)"
        //print(url)
        performRequest(with: url)
    }
    func performRequest(with urlString: String){
        if let url=URL(string: urlString){
            //print(url)
            let urlSession=URLSession(configuration: .default)
            let task=urlSession.dataTask(with: url) { data, response, error in
                if error != nil{
                    print(error)
                    return
                }
                if let safeData=data{
                    if let coinModel=parseJSON(coinData: safeData){
                        self.delegate?.didCoinUpdate(coinModel: coinModel)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(coinData: Data)->CoinModel?{
        let decoder=JSONDecoder()
        do{
            let jsonData=try decoder.decode(CoinModel.self, from: coinData)
            let coinModel=CoinModel(rate: jsonData.rate)
            return coinModel
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
