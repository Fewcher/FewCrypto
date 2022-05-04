//
//  ContentView.swift
//  FewCrypto
//
//  Created by Fewcher on 15.04.2022.
//

import SwiftUI
import WidgetKit // need this to refresh the widget by pressing the button

struct ContentView: View {
    
        @AppStorage("bitcoin") private var bitcoin = "0"
//      @State private var bitcoin = UserDefaults(suiteName: "group.FewCrypto.Fewcher")!.string(forKey: "bitcoin") ?? "0.11"
//     при загрузке формы вариант со @state userdefaults показывает опциональное значение
    
//      @State private var usd = UserDefaults(suiteName: "group.FewCrypto.Fewcher")!.integer(forKey: "usd")
//      @State private var rub = UserDefaults(suiteName: "group.FewCrypto.Fewcher")!.integer(forKey: "rub")
//      @State private var date = UserDefaults(suiteName: "group.FewCrypto.Fewcher")!.string(forKey: "date")
//     не обновляет данные при таком объявлении
//     еще бы убрал умножение на лету
    
//      dateStr = "Updated: " + String(Date.now.formatted(date: .long, time: .shortened))

    let defaults = UserDefaults(suiteName: "group.FewCrypto.Fewcher") // экономия места
    
    @FocusState private var focus: Bool // чтобы убирать клаву
    
    @State private var isShowingField = false
    @State private var btc1: String = "first"
    @State private var btc2: String = "second"
    
    @ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
        Form {
            let date = defaults!.string(forKey: "date")
            Text("Updated: " + (date ?? "never"))
                .font(.footnote)
                .foregroundColor(.gray)
            
            Section {
                HStack {
                    Text("₿ ")
                    TextField("0", text: $bitcoin) // need $ (binding) to read AND write data and update UI
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
                    HStack {
                        TextField("0", text: $btc1)
                            //.transition(.slide) // gotta find good transition effect: maybe .opacity
                            // BUT it does not seem to be working with Sections
                        
                        Divider()
                        
                        TextField("0", text: $btc2)
                    }

                }
            }
            // MARK: upper field has to be computed property with bitcoin variable going to first lower field and
            
            Section {
                HStack {
                    Text("$ ")
                
                    let usd = defaults!.integer(forKey: "usd")
                    let usdBitcoin = Int((Double(bitcoin) ?? 0) * Double(usd))
                    // привожу к int чтобы убрать десятичные
                    Text("\(usdBitcoin)")
                }
            } footer: {
                let usd = defaults!.integer(forKey: "usd")
                Text("1₿ = $\(usd) ")
            }
            
            Section {
                HStack {
                    Text("₽ ")
                    let rub = defaults!.integer(forKey: "rub")
                    let rubBitcoin = Int((Double(bitcoin) ?? 0) * Double(rub))
                    Text("\(rubBitcoin)")
                }
            } footer: {
                let rub = defaults!.integer(forKey: "rub")
                Text("1₿ = \(rub) ₽")
            }
            
            Button("Update") {
                //self.networkManager.fetchData()
                networkManager.fetchData { usd in } // хз почему это работает
                
                defaults!.set(bitcoin, forKey: "bitcoin")
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
