//
//  XWeatherWidget.swift
//  XWeatherWidget
//
//  Created by teenloong on 2022/8/11.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents
import XWeatherKit

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> XWWeatherEntry {
        XWWeatherEntry(date: Date(), configuration: XWConfigurationIntent(), weather: .sample)
    }

    func getSnapshot(for configuration: XWConfigurationIntent, in context: Context, completion: @escaping (XWWeatherEntry) -> ()) {
        let entry = XWWeatherEntry(date: Date(), configuration: configuration, weather: .sample)
        completion(entry)
    }

    func getTimeline(for configuration: XWConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [XWWeatherEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let requestFailedDate = currentDate + 5 * 60
        let refreshDate = Calendar.current.nextHour(for: currentDate)
        guard let location = configuration.location, let longitude = location.longitude, let latitude = location.latitude else {
            entries.append(XWWeatherEntry(date: currentDate, configuration: configuration, weather: XWWeather()))
            let timeline = Timeline(entries: entries, policy: .after(requestFailedDate))
            completion(timeline)
            return
        }
        
        let weatherLocation = XWWeatherLocation(latitude: latitude, longitude: longitude, name: location.name)
        
        XWeather.request(action: CYWeatherDetailAction(parameters: .init(token: XWAppConfig.cyweatherToken, longitude: longitude, latitude: latitude, hourlysteps: 24, dailysteps: 15, lang: Locale.current.identifier, unit: .metric))) { result in
            switch result {
            case .success(let response):
                let weather = XWWeather(isCurrentLocation: false, location: weatherLocation, unit: .celsius, response: response)
                entries.append(XWWeatherEntry(date: currentDate, configuration: configuration, weather: weather))
                let timeline = Timeline(entries: entries, policy: .after(refreshDate))
                completion(timeline)
            case .failure(let error):
                #if DEBUG
                print(error.localizedDescription)
                #endif
                entries.append(XWWeatherEntry(date: currentDate, configuration: configuration, weather: XWWeather()))
                let timeline = Timeline(entries: entries, policy: .after(requestFailedDate))
                completion(timeline)
            }
        }
    }
}

struct XWWeatherEntry: TimelineEntry {
    let date: Date
    let configuration: XWConfigurationIntent
    let weather: XWWeather
}

struct XWeatherWidgetEntryView : View {
    @Environment(\.widgetFamily) private var family: WidgetFamily
    
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            XWBackgroundView()
//            switch WidgetFamily.systemLarge {
            switch family {
            case .systemSmall:
                XWeatherWidgetSmallView(weather: entry.weather)
                    .foregroundColor(.mainText)
            case .systemMedium:
                XWeatherWidgetMediumView(weather: entry.weather)
                    .foregroundColor(.secondaryText)
            case .systemLarge:
                XWeatherWidgetLargeView(unit: entry.weather.unit, weather: entry.weather)
            case .systemExtraLarge:
                Text("systemExtraLarge")
            @unknown default:
                Text("@unknown default")
            }
        }
        .foregroundColor(.secondaryText)
    }
}

struct XWeatherWidgetSmallView : View {
    let weather: XWWeather
    
    private var now: XWWeatherNow { weather.now }
    private var unit: XWTemperature.Unit { weather.unit }
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            HStack(alignment: .top) {
                Text(Image(systemName: now.weatherType.systemImageName))
                    .font(.system(size: 50, weight: .medium))
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top, spacing: 0) {
                        Text(now.temperatureString(for: unit))
                            .font(.system(size: 30, weight: .bold))
                        Text(unit.symbol)
                            .font(.system(size: 15, weight: .bold))
                    }
                    .fixedSize()
                }
            }
            if let name = weather.location?.name {
                HStack {
                    Text(name)
                        .font(.system(size: 18, weight: .medium))
                    if weather.isCurrentLocation {
                        Text(Image(systemName: "location.fill"))
                    }
                }
            }
            Text(LocalizedStringKey(now.weatherType.name))
        }
        .modifier(XWShadowModifer())
    }
}

struct XWeatherWidgetMediumView : View {
    let weather: XWWeather
    
    private var unit: XWTemperature.Unit { weather.unit }
    private var daily: XWWeatherDaily { weather.daily }

    var body: some View {
        let items = daily.daily.count >= 5 ? Array(daily.daily[0..<5]) : daily.daily
        
        let columns: [GridItem] =
                Array(repeating: .init(.flexible()), count: 5)
        VStack(alignment: .leading) {
            HStack {
                Text("\(Image(systemName: "calendar")) \("%@ days forecast".localizeWithFormat(arguments: "5"))")
                Spacer()
                if let name = weather.location?.name {
                    HStack {
                        Text(name)
                            .fontWeight(.medium)
                        if weather.isCurrentLocation {
                            Text(Image(systemName: "location.fill"))
                        }
                    }
                }
            }
            Divider()
            LazyVGrid(columns: columns) {
                ForEach(items.indices, id: \.self) { index in
                    XWWeatherWidgetDailyColumnView(daily: items[index], unit: unit)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct XWeatherWidgetLargeView : View {
    let unit: XWTemperature.Unit
    let weather: XWWeather

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            let columns: [GridItem] =
                    Array(repeating: .init(.flexible()), count: 5)
            let hourly = weather.hourly.hourly.count >= 5 ? Array(weather.hourly.hourly[0..<5]) : weather.hourly.hourly
            let daily = weather.daily.daily.count >= 5 ? Array(weather.daily.daily[0..<5]) : weather.daily.daily
            HStack(alignment: .top, spacing: 20) {
                VStack(alignment: .leading) {
                    HStack(alignment: .top, spacing: 0) {
                        Text(Image(systemName: weather.now.weatherType.systemImageName))
                            .font(.system(size: 40, weight: .bold))
                        Text(weather.now.temperatureString(for: unit))
                            .font(.system(size: 20, weight: .bold))
                        Text(unit.symbol)
                            .font(.system(size: 10, weight: .bold))
                    }
                    if let description = weather.minutely.description {
                        Text(description)
                            .font(.system(size: 10, weight: .medium))
                    }
                }
                VStack(alignment: .leading, spacing: 7) {
                    HStack {
                        if let name = weather.location?.name {
                            Text(name)
                                .fontWeight(.medium)
                            if weather.isCurrentLocation {
                                Text(Image(systemName: "location.fill"))
                            }
                        }
                        Text(LocalizedStringKey(weather.now.weatherType.name))
                    }
                    Text("Air Quality %@".localizeWithFormat(arguments: weather.now.aqiString))
                    Text(weather.now.aqiLevelDescription.localized)
                    Text("Updated on %@".localizeWithFormat(arguments: weather.now.updateTimeString))
                }
                .font(.system(size: 12, weight: .medium))
            }
            .foregroundColor(.mainText)
//            Text(("%@ hours forecast".localizeWithFormat(arguments: "24")))
            Divider()
            LazyVGrid(columns: columns) {
                ForEach(hourly.indices, id: \.self) { index in
                    XWWeatherWidgetHourlyColumnView(index: index, hourly: hourly[index], unit: unit)
                }
            }
//            Text("\(Image(systemName: "calendar")) \("%@ days forecast".localizeWithFormat(arguments: "5"))")
            Divider()
            LazyVGrid(columns: columns) {
                ForEach(daily.indices, id: \.self) { index in
                    XWWeatherWidgetDailyColumnView(daily: daily[index], unit: unit)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct XWWeatherWidgetHourlyColumnView: View {
    let index: Int
    let hourly: XWWeatherHourly.Hourly
    let unit: XWTemperature.Unit

    var body: some View {
        VStack(spacing: 8) {
            if index == 0 {
                Text("Now")
                    .font(.system(size: 12, weight: .medium))
            } else if let date = hourly.updateDate {
                Text(date.formatString("HH", localized: true))
                    .font(.system(size: 12, weight: .medium))
            }
            Text(Image(systemName: hourly.weatherType.systemImageName))
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.mainText)
            Text(LocalizedStringKey(hourly.weatherType.name))
                .font(.system(size: 12, weight: .medium))
            if let temperature = hourly.temperatureString(for: unit) {
                HStack(alignment: .top, spacing: 0) {
                    Text(temperature)
                        .font(.system(size: 12, weight: .medium))
                    Text(unit.symbol)
                        .font(.system(size: 6, weight: .medium))
                }
            }
        }
    }
}

struct XWWeatherWidgetDailyColumnView: View {
    let daily: XWWeatherDaily.Daily
    let unit: XWTemperature.Unit
    
    var body: some View {
        VStack(spacing: 6) {
            if let date = daily.updateDate {
                if date.isToday {
                    Text(date.relativeDateString(dateStyle: .short, timeStyle: .none))
                        .font(.system(size: 12, weight: .medium))
                } else {
                    Text(date.formatString("EE", localized: true))
                        .font(.system(size: 12, weight: .medium))
                }
            }
            Text(Image(systemName: daily.weatherType.systemImageName))
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.mainText)
            Text(LocalizedStringKey(daily.weatherType.name))
                .font(.system(size: 12, weight: .medium))
            HStack(alignment: .top, spacing: 2) {
                if let min = daily.temperatureMinString(for: unit) {
                    HStack(alignment: .top, spacing: 0) {
                        Text(min)
                            .font(.system(size: 12, weight: .medium))
                        Text("°")
                            .font(.system(size: 6, weight: .medium))
                    }
                }
                Spacer()
                if let max = daily.temperatureMinString(for: unit) {
                    HStack(alignment: .top, spacing: 0) {
                        Text(max)
                            .font(.system(size: 12, weight: .medium))
                        Text("°")
                            .font(.system(size: 6, weight: .medium))
                    }
                }
            }
        }
    }
}

@main
struct XWeatherWidget: Widget {
    let kind: String = "XWeatherWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: XWConfigurationIntent.self, provider: Provider()) { entry in
            XWeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct XWeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        XWeatherWidgetEntryView(entry: XWWeatherEntry(date: Date(), configuration: XWConfigurationIntent(), weather: .sample))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
