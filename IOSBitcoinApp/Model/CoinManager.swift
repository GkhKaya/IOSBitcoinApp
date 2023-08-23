//
//  CoinManager.swift
//  IOSBitcoinApp
//
//  Created by Gokhan Kaya on 23.08.2023.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}
struct CoinManager {
    var delegate: CoinManagerDelegate?

    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "D47CF28C-F471-436C-818A-218C5E7843DD"

    let currencyArray = ["TL","AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD", "IDR", "ILS", "INR", "JPY", "MXN", "NOK", "NZD", "PLN", "RON", "RUB", "SEK", "SGD", "USD", "ZAR",]

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"

        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)

            let task = session.dataTask(with: url) { (data, response, error) in

                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {

                    if let bitcoinPrice = self.parseJSON(safeData) {

                        //Optional: round the price down to 2 decimal places.
                        let priceString = String(format: "%.2f", bitcoinPrice)

                        //Call the delegate method in the delegate (ViewController) and
                        //pass along the necessary data.
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
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
            return lastPrice

        } catch {

            //Catch and print any errors.
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}



