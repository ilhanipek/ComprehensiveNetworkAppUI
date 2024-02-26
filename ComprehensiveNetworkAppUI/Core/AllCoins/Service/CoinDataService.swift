//
//  CoinDatatService.swift
//  ComprehensiveNetworkAppUI
//
//  Created by ilhan serhan ipek on 8.09.2023.
//

import Foundation

class CoinDataService {
  private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=false&price_change_percentage=24h&locale=en"

  func fetchCoinswithAsync() async throws -> [Coin]{
    guard let url = URL(string: urlString) else { return []}
    do {
      print("Fetching data..")
      let (data,_) = try await URLSession.shared.data(from: url)
      let coins = try JSONDecoder().decode([Coin].self, from: data)
      return coins
    }catch {
      print("DEBUG: Error: \(error.localizedDescription)")
      return []
    }

  }
}

extension CoinDataService {
  func fetchCoinswithResult(completion: @escaping (Result<[Coin],CoinAPIError>) -> Void){

    guard let url = URL(string: urlString) else { return }

    URLSession.shared.dataTask(with: url) { data, response, error in
      if let error = error {
        completion(.failure(.unknownError(error: error)))
        return
      }

      guard let httpResponse = response as? HTTPURLResponse else {
        completion(.failure(.requestFailed(description: "Request failed")))
        return
      }

      guard httpResponse.statusCode == 200 else {
        completion(.failure(.invalidStatusCode(statusCode: httpResponse.statusCode)))
        return
      }
      guard let data = data else {
        completion(.failure(.invalidData))
        return
      }

      do{
        let coins = try JSONDecoder().decode([Coin].self, from: data)
        completion(.success(coins))
      }catch {
        completion(.failure(.jsonParsingFailure))
      }

    }.resume()
  }

  func fetchCoins(completion: @escaping ([Coin]?,Error?)-> Void){

    guard let url = URL(string: urlString) else { return }

    URLSession.shared.dataTask(with: url) { data, response, error in
      if let error = error {
        completion(nil,error)
        return
      }
      guard let data = data else { return }

      guard let coins = try? JSONDecoder().decode([Coin].self, from: data) else {
        print("Failed to decode coins")
        return
      }
      completion(coins,nil)
    }.resume()
  }

  func fetchPrice(coin: String,completion: @escaping (Double) -> Void){
    let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=usd"
    guard let url = URL(string: urlString) else { return}
    URLSession.shared.dataTask(with: url) { data, response, error in
      DispatchQueue.main.async {
        if let error = error {
//          self.errorMessage = error.localizedDescription
          print("DEBUG: Failed with error \(error.localizedDescription)")
        }
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//          self.errorMessage = error?.localizedDescription
          return
        }
        print(httpResponse.statusCode)

        guard let data = data else { return }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
        guard let jsonObject2 = jsonObject[coin] as? [String: Double] else {
          print("Failed to parse ")
          return
        }
        guard let price = jsonObject2["usd"] else { return }

//        self.coin = coin.capitalized
//        self.price = "$\(price)"
        print("DEBUG: Price in service is: \(price)")
        completion(price)
      }
    }.resume()
  }
}
