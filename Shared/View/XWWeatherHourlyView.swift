//
//  XWWeatherHourlyView.swift
//  XWeather
//
//  Created by teenloong on 2022/8/9.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI
import XWeatherKit

struct XWWeatherHourlyView: View {
    let temperatureUnit: XWTemperature.Unit
    let weatherHourly: XWWeatherHourly
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(Image(systemName: "clock")) \("%@ hours forecast".localizeWithFormat(arguments: "24"))")
//            Text(weatherHourly.description)
            Divider()
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(Array(weatherHourly.hourly.enumerated()), id: \.0) { index, item in
                        XWWeatherHourlyColumnView(index: index, hourly: item, temperatureUnit: temperatureUnit)
                            .frame(width: 60)
                    }
                }
                .fixedSize()
            }
        }
        .foregroundColor(.secondaryText)
        .padding()
        .background(XWPanelView())
        .padding(.horizontal)
    }
}

#if DEBUG
struct XWWeatherHourlyView_Previews: PreviewProvider {
    static var previews: some View {
        XWWeatherHourlyView(temperatureUnit: .celsius, weatherHourly: XWDEBUGData.weatherHourly)
    }
}
#endif

fileprivate struct XWWeatherHourlyColumnView: View {
    let index: Int
    let hourly: XWWeatherHourly.Hourly
    let temperatureUnit: XWTemperature.Unit

    var body: some View {
        VStack(spacing: 8) {
            if index == 0 {
                Text("Now")
                    .font(.system(size: 14, weight: .medium))
            } else if let date = hourly.updateDate {
                Text(date.formatString("HH", localized: true))
                    .font(.system(size: 14, weight: .medium))
            }
            Text(Image(systemName: hourly.weatherType.systemImageName))
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.mainText)
            Text(LocalizedStringKey(hourly.weatherType.name))
                .font(.system(size: 14, weight: .medium))
            if let temperature = hourly.temperatureString(for: temperatureUnit) {
                HStack(alignment: .top, spacing: 0) {
                    Text(temperature)
                        .font(.system(size: 14, weight: .medium))
                    Text(temperatureUnit.symbol)                    .font(.system(size: 8, weight: .medium))
                }
            }
        }
    }
}
