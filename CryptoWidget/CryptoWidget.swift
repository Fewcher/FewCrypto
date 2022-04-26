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
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 { // не понимаю как это работает, но обновляет каждые 4 часа
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct CryptoWidgetEntryView : View {
    var entry: Provider.Entry

    @AppStorage("bitcoin") private var bitcoin = "0"
    
    var body: some View {
        //Text(entry.date, style: .time)
        HStack {
            Text("₿ ")
            //Text("0.0123")
            Text(bitcoin)
        }
        
        HStack {
            Text("$ ")
            let usd = UserDefaults(suiteName: "group.FewCrypto.Fewcher")!.integer(forKey:"usd")
            Text("\(usd)")
        }

        HStack {
            Text("₽ ")
            let rub = UserDefaults(suiteName: "group.FewCrypto.Fewcher")!.integer(forKey: "rub")
            Text("\(rub)")
        }
        
        //Text("21 April 15:23")
        let releaseDate = Date()
        //let dateStr = "Updated: " + String(Date.now.formatted(date: .long, time: .shortened))
        Text(releaseDate, format: Date.FormatStyle().month().day().hour().minute())
        

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
        CryptoWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
