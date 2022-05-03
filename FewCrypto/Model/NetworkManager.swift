//
//  NetworkManager.swift
//  FewCrypto
//
//  Created by Fewcher on 17.04.2022.
//

import Foundation

class NetworkManager: ObservableObject {

    @Published var usd = 0 // usd from json
    @Published var rub = 0 // rub from json
    //whenever an object with a property marked @Published is changed,
    //all views using that object will be reloaded to reflect those changes.
    @Published var releaseDate = ""
    // даже если убираю @published - главная форма обновляет все (три) значения и умножает на лету, но медленнее ?!
    
    
    func fetchData(completion: @escaping (Int) -> Void  ) {
        if let url = URL(string: "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd%2Crub") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(PriceData.self, from: safeData)
                            DispatchQueue.main.async {
                                self.usd = results.bitcoin.usd
                                self.rub = results.bitcoin.rub
                                print(results.bitcoin.usd)
                                print(results.bitcoin.rub)
                                // read two values from json
                                
                                // and write to data storage
                                let defaults = UserDefaults(suiteName: "group.FewCrypto.Fewcher")
                                defaults!.set(self.usd, forKey: "usd")
                                defaults!.set(self.rub, forKey: "rub")
                                // попробуй без !
                                
                                self.releaseDate = String(Date().formatted(date: .numeric, time: .shortened))
                                //date, format: Date.FormatStyle().month().day().hour().minute()
                                    // format from the widget
                                defaults!.set(self.releaseDate, forKey: "date")
                                print(self.releaseDate)
                            }
                        } catch {
                            print(error)
                        }
                        completion(self.usd)
                    }
                }
            }
            task.resume()
        }
    }
}
