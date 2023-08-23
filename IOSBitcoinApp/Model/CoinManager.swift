//
//  CoinManager.swift
//  IOSBitcoinApp
//
//  Created by Gokhan Kaya on 23.08.2023.
//

import Foundation
struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "D47CF28C-F471-436C-818A-218C5E7843DD"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency:String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString){
            let session =  URLSession(configuration: .default)
            
            let task = session.dataTask(with: url){(data,response,error) in
                
                if error != nil{
                    print(error!)
                    return
                }
                if let safedata = data{
                    let bitcoinPrice = self.parseJSON(safedata)
                }
            }
            task.resume()
        }
    }

    func parseJSON(_ data: Data) -> Double? {
            
            //Create a JSONDecoder
            let decoder = JSONDecoder()
            do {
                
                //try to decode the data using the CoinData structure
                let decodedData = try decoder.decode(CoinData.self, from: data)
                
                //Get the last property from the decoded data.
                let lastPrice = decodedData.rate
                print(lastPrice)
                return lastPrice
                
            } catch {
                
                //Catch and print any errors.
                print(error)
                return nil
            }
        }
}
