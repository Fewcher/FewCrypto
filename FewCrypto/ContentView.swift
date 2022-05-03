//
//  ContentView.swift
//  FewCrypto
//
//  Created by Fewcher on 15.04.2022.
//

import SwiftUI
import WidgetKit // need this to refresh the widget by pressing the button

struct ContentView: View {
    
//    @State private var bitcoin = ""
//    @State private var dollars = 0
//    @State private var rub = 0
//    @State private var dateStr = "never"
    
//    @AppStorage("bitcoin") private var bitcoin = "0"
//    @AppStorage("usd") private var usd = 0
//    @AppStorage("rub") private var rub = 0
    // storing with UserDefaults
    // попробуй заменить UserDefaults(suiteName: "group.FewCrypto.Fewcher") на @AppStorage
        // когда ВСЕ переменные были @appstorage чот не работает
    
        @AppStorage("bitcoin") private var bitcoin = "0"
        //@State private var bitcoin = UserDefaults(suiteName: "group.FewCrypto.Fewcher")!.string(forKey: "bitcoin") ?? "0.11"
        //при загрузке формы вариант со @state userdefaults показывает опциональное значение
    
//        @State private var usd = UserDefaults(suiteName: "group.FewCrypto.Fewcher")!.integer(forKey: "usd")
//        @State private var rub = UserDefaults(suiteName: "group.FewCrypto.Fewcher")!.integer(forKey: "rub")
//        @State var date = UserDefaults(suiteName: "group.FewCrypto.Fewcher")!.string(forKey: "date")
    
//     @AppStorage("dateStr") private var dateStr = "Updated: Never"
//     @AppStorage("date") private var date = "Updated: Never"
    //private var date = UserDefaults(suiteName: "group.FewCrypto_NM.Fewcher")!.string(forKey: "date")
    //dateStr = "Updated: " + String(Date.now.formatted(date: .long, time: .shortened))
    // date-time of last update
    
    let rub = UserDefaults(suiteName: "group.FewCrypto.Fewcher")!.integer(forKey: "rub")
    let usd = UserDefaults(suiteName: "group.FewCrypto.Fewcher")!.integer(forKey: "usd")
    let date = UserDefaults(suiteName: "group.FewCrypto.Fewcher")!.string(forKey: "date")
    
    @FocusState private var focus: Bool
    
    @State private var isShowingField = false
    @State private var btcAdd: String = "+++"
    
    @ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
        Form {
            Text("Updated: " + (date ?? "never"))
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
                    Button("+"){
                        isShowingField.toggle()
                    }
                }
                

                
                if isShowingField {
                    //TextField("+++")
                    TextField("?", text: $btcAdd)
                        .transition(.slide) // gotta find good transition effect. maybe .opacity
                }
            }
            
            Section {
                HStack {
                    Text("$ ")
                    //Text("\(usd)")
//                usd = Int((Double(bitcoin) ?? 0) * Double(results.bitcoin.usd))
//                //привожу к int чтобы убрать десятичные
                    //Text(Int((Double(bitcoin) ?? 0) * Double(usd)))

                    let usdBitcoin = Int((Double(bitcoin) ?? 0) * Double(usd))
                    Text("\(usdBitcoin)")
                    // мне не нравится как это выглядит, но хз чо еще придумать
                    // мне не нравится что умножение на лету, но я хз как убрать
                }
                
                Text("1 BTC = \(usd) usd")
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .opacity(0.5)
            }
            
            Section {
                HStack {
                    Text("₽ ")
            
                    let rubBitcoin = Int((Double(bitcoin) ?? 0) * Double(rub))
                    Text("\(rubBitcoin)")
                    // rub = Int((Double(bitcoin) ?? 0) * Double(results.bitcoin.rub))
                }
                
                Text("1 BTC = \(rub) rub")
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .opacity(0.5)
            }
            

            
            Button("Update") {
                //self.networkManager.fetchData()
                networkManager.fetchData { usd in } // хз почему это работает
                
                UserDefaults(suiteName: "group.FewCrypto.Fewcher")!.set(bitcoin, forKey: "bitcoin")
                print(bitcoin)
                
                WidgetCenter.shared.reloadAllTimelines() // reload all widgets
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
