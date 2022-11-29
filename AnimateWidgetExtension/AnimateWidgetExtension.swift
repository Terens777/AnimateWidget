//
//  AnimateWidgetExtension.swift
//  AnimateWidgetExtension
//
//  Created by Danylo Bulanov on 11/27/22.
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
        for hourOffset in 0 ..< 5 {
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

struct AnimateWidgetExtensionEntryView : View {
    var entry: Provider.Entry
    let size: CGSize = CGSize(width: 75, height: 75)
    
    var body: some View {
        return VStack {
            Circle()
                .fill(Color.blue)
                .frame(
                    width: size.width,
                    height: size.height
                )
        }
        .offset(x: 0, y: 0)
        ._clockHandRotationEffect(.custom(10), in: .current, anchor: .zero)
        .offset(x: -(size.height / 3), y: 0)
        ._clockHandRotationEffect(.custom(10), in: .current, anchor: .zero)
    }
}

@main
struct AnimateWidgetExtension: Widget {
    let kind: String = "AnimateWidgetExtension"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            AnimateWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct AnimateWidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        AnimateWidgetExtensionEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
