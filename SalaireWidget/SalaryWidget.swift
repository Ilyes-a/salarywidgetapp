//
//  SalaryWidget.swift
//  SalaireWidgetApp
//
//  Created by Ilyes Achaq on 13/04/2025.
//

import WidgetKit
import SwiftUI

struct SalaryWidgetEntryView: View {
    var entry: SalaryEntry

    var body: some View {
        let earnedText = String(format: "%.2f", entry.earned)

        VStack(alignment: .leading) {
            Text("Salaire : \(earnedText) €")
                .font(.headline)
            Text(entry.date, style: .time)
                .font(.caption)
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget) // Fix du warning iOS 17+
    }
}



@main
struct SalaireWidget: Widget {
    let kind: String = "SalaireWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SalaryWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryRectangular])
        .configurationDisplayName("Salaire en temps réel")
        .description("Suivez votre salaire minute par minute.")
    }
}
