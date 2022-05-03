//
//  CryptoWidget.swift
//  CryptoWidget
//
//  Created by Fewcher on 21.04.2022.
//

import WidgetKit
import SwiftUI
import Intents


struct Provider: IntentTimelineProvider {
    //An IntentTimelineProvider performs the same function as _TimelineProvider_,
    //but it also incorporates user-configured details into timeline entries. (могу кастомизировать)
    
    var networkManager = NetworkManager()
    //не находил этот класс, пока не добавил в target membership
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),configuration: ConfigurationIntent(), usd: 10)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, usd: 11)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        networkManager.fetchData { usd in
            var entries: [SimpleEntry] = []

            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            for hourOffset in 0 ..< 5 { // не понимаю как это работает, но обновляет каждые 4 часа
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, configuration: configuration, usd: UserDefaults(suiteName: "group.FewCrypto.Fewcher")!.integer(forKey:"usd"))
                    // если указать `usd: usd` то ничего не будет
                entries.append(entry)
            }

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent // нужно для кастомизации (которой сейчас у тебя и нет)
    let usd: Int
}

struct CryptoWidgetEntryView : View {
    var entry: Provider.Entry
    let bitcoin = UserDefaults(suiteName: "group.FewCrypto.Fewcher")!.string(forKey: "bitcoin") ?? "nope"
    let rub = UserDefaults(suiteName: "group.FewCrypto.Fewcher")!.integer(forKey: "rub")
    
    //@AppStorage("bitcoin") private var bitcoin = "0"
    
    var body: some View {
        VStack (alignment: .leading) {
        //Text(entry.date, style: .time)
            HStack {
                Text("₿ ")
                //Text("0.0123")
                //Text(bitcoin)
                
                Text(bitcoin)
            }
            
            //Spacer()
            //Divider()
            Text("")
            
            HStack {
                Text("$ ")
                //let usd = UserDefaults(suiteName: "group.FewCrypto.Fewcher")!.integer(forKey:"usd")
                //Text("\(entry.usd)")
                
                let usdBitcoin = Int((Double(bitcoin) ?? 0) * Double(entry.usd))
                Text("\(usdBitcoin)")
            }

            HStack {
                Text("₽ ")
                
                //Text("\(rub)")
                let rubBitcoin = Int((Double(bitcoin) ?? 0) * Double(rub))
                Text("\(rubBitcoin)")
            }
            
            //Text("21 April 15:23")
            let releaseDate = Date()
            //let dateStr = "Updated: " + String(Date.now.formatted(date: .long, time: .shortened))
            Text(releaseDate, format: Date.FormatStyle().month().day().hour().minute())
                //.font(.subheadline) // just a little smaller
                .foregroundColor(.secondary)
                //.padding() // way too big
                .font(.caption) // is smaller than .footnote
                .opacity(0.5)
            }
    }
}

@main
struct CryptoWidget: Widget {
    let kind: String = "CryptoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            CryptoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium, .systemSmall]) // БОЛЬШОЙ не нужон!
    }
}

struct CryptoWidget_Previews: PreviewProvider {
    static var previews: some View {
        CryptoWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), usd: 12))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
