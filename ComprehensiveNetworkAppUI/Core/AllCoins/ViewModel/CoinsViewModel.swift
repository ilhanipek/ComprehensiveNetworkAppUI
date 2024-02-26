//
//  CoinsViewModel.swift
//  ComprehensiveNetworkAppUI
//
//  Created by ilhan serhan ipek on 8.09.2023.
//

import Foundation

class CoinsViewModel: ObservableObject {
  @Published var coin = ""
  @Published var price = ""

  @Published var coins = [Coin]()
  @Published var errorMessage: String?

  private let service = CoinDataService()
  init(){
//    fetchPrice(coin: "bitcoin")
    fetchCoinsWithCompletionHandler()
//    Task{
//      try await fetchCoinsWtihAsync()
//    }
    }

  func fetchCoinsWtihAsync() async throws{
    self.coins =  try await service.fetchCoinswithAsync()
  }

  func fetchCoinsWithCompletionHandler(){
//    service.fetchCoins { coins, error in
//      DispatchQueue.main.async {
//        if let error = error {
//          self.errorMessage = error.localizedDescription
//          return
//        }
//        self.coins = coins ?? []
//      }
//
//    }

    service.fetchCoinswithResult { [weak self] result in
      
      DispatchQueue.main.async {
        switch result {
        case .success(let coins):
          self?.coins = coins
        case .failure(let error):
          self?.errorMessage = error.localizedDescription
        }
      }
    }
  }

  
  func fetchPrice(coin: String){
    service.fetchPrice(coin: coin) { priceFromService in
      self.price = "\(priceFromService)"
      self.coin = coin
    }
  }

  
}
