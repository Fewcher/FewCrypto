////
////  NetworkManager.swift
////  FewCrypto
////
////  Created by Fewcher on 17.04.2022.
////
//
//import Foundation
//
//class NetworkManager: ObservableObject {
//
//    @Published var bitcoinUSD: Int
//    @Published var bitcoinRUB: Int
//    //@Published var posts = Int()
//
//    init() {
//        fetchData()
//    }
//
//    func fetchData() {
//        if let url = URL(string: "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd%2Crub") {
//            let session = URLSession(configuration: .default)
//            let task = session.dataTask(with: url) { (data, response, error) in
//                if error == nil {
//                    let decoder = JSONDecoder()
//                    if let safeData = data {
//                        do {
//                            //let results = try decoder.decode(Results.self, from: safeData)
//                            let results = try decoder.decode(Results.self, from: safeData)
//                            //print(results)
//                            DispatchQueue.main.async {
//                                self.bitcoinUSD = results.bitcoin.usd
//                                self.bitcoinRUB = results.bitcoin.rub
//                                //self.bitcoin = results.bitcoin
//                                //self.posts = results.bitcoin.usd
//                            }
//                        } catch {
//                            print(error)
//                        }
//                    }
//                }
//            }
//            task.resume()
//              //  .resume()
//        }
//    }
//}
