//
//  ContentView.swift
//  FewCrypto
//
//  Created by Fewcher on 15.04.2022.
//

import SwiftUI

struct ContentView: View {
    
//    @State private var bitcoin = ""
//    @State private var dollars = 0
//    @State private var rub = 0
//    @State private var dateStr = "never"
    
    @AppStorage("bitcoin") private var bitcoin = "0"
    @AppStorage("dollars") private var dollars = 0
    @AppStorage("rub") private var rub = 0
    @AppStorage("dateStr") private var dateStr = "Updated: Never"
    // storing with UserDefaults
    
    @FocusState private var focus: Bool
    
    //@ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
        Form {
            
            Text(dateStr)
                .font(.footnote)
                .foregroundColor(.gray)
            
            Section {
                HStack {
                    Text("₿ ")
                    TextField("0", text: $bitcoin)
                        .keyboardType(.decimalPad)
                        .focused($focus)
                        .onChange(of: bitcoin){ newValue in // calculate value 'on the go'
                            if newValue.last == "," { // replacing , (comma) with . (dot)
                                bitcoin = String(newValue.dropLast())
                                bitcoin.append(".")
                            } else { // filtering an input to only let through this:
                                let filtered = newValue.filter { "0123456789.,".contains($0) }
                                if filtered != newValue {
                                    self.bitcoin = filtered
                                }
                            }
                        }
                }
            }
            
            Section {
                HStack {
                    Text("$ ")
                    Text("\(dollars)")
                }
            }
            
            Section {
                HStack {
                    Text("₽ ")
                    Text("\(rub)")
                }
            }
            
            Button("Update") {
                if let url = URL(string: "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd%2Crub") {
                    let session = URLSession(configuration: .default)
                    let task = session.dataTask(with: url) { (data, response, error) in
                        if error == nil {
                            let decoder = JSONDecoder()
                            if let safeData = data {
                                do {
                                    let results = try decoder.decode(PriceData.self, from: safeData)
                                            DispatchQueue.main.async {
                                                dollars = Int((Double(bitcoin) ?? 0) * Double(results.bitcoin.usd))
                                                rub = Int((Double(bitcoin) ?? 0) * Double(results.bitcoin.rub))
                                                //привожу к int чтобы убрать десятичные
                                                
                                                dateStr = "Updated: " + String(Date.now.formatted(date: .long, time: .shortened))
                                                // date-time of last update
                                            }
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    }
                    task.resume()
                }
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) { //hide keyboard
                    Button("Done") {
                        focus = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
