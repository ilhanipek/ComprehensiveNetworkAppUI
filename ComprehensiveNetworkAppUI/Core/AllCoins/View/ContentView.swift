//
//  ContentView.swift
//  ComprehensiveNetworkAppUI
//
//  Created by ilhan serhan ipek on 8.09.2023.
//

import SwiftUI

struct ContentView: View {
  @StateObject var viewModel = CoinsViewModel()
    var body: some View {
      VStack{
        if let error = viewModel.errorMessage {
          Text(error)
        }else {
          List{
            ForEach(viewModel.coins) { coin in
              HStack{
                Text("\(coin.marketCapRank)")
                  .foregroundColor(.gray)

                VStack(alignment: .leading) {
                  Text(coin.name)

                  Text(coin.symbol.uppercased())
                }
              }
            }
          }
            .padding()
        }
      }


    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
