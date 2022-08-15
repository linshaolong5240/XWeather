//
//  XWWeatherNowView.swift
//  XWeather
//
//  Created by teenloong on 2022/5/22.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI
import XWeatherKit

struct XWWeatherNowView: View {
    let weather: XWWeatherNow
    let minutely: XWWeatherMinutely
    let temperatureUnit: XWTemperature.Unit

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(spacing: 20) {
                Text(Image(systemName: weather.weatherType.systemImageName))
                    .font(.system(size: 80, weight: .medium))
//                    .background(Color.red)
                if let description = minutely.description {
                    Text(description)
//                        .lineSpacing(6)
                        .font(.system(size: 12, weight: .medium))
                        .padding(.horizontal)
                }
            }
            .modifier(XWShadowModifer())
            .frame(maxWidth: .infinity)
//            .background(Color.blue)
            VStack(alignment: .leading) {
                XWTemperatureView(unit: temperatureUnit, value: Int(weather.temperature(for: temperatureUnit) ?? 0), fontSize: 60)
                VStack(alignment: .leading, spacing: 10) {
                    Text(LocalizedStringKey(weather.weatherType.name))
                    Text("Air Quality %@".localizeWithFormat(arguments: weather.aqiString))
                    Text(weather.aqiLevelDescription.localized)
                    Text("Updated on %@".localizeWithFormat(arguments: weather.updateTimeString))
//                    Text(String(format: NSLocalizedString("Updated on %@", comment: ""), weather.updateTimeString))
                        .foregroundColor(.secondaryText)
                }
                .font(.system(size: 12, weight: .medium))
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .modifier(XWShadowModifer())
        }
        .foregroundColor(.mainText)
        .padding(.vertical, 30)
        .padding(.horizontal)
        .background(XWPanelView())
        .padding(.horizontal)
        .overlay(
            HStack {
                Divider().padding(.vertical, 30)
            }
        )
    }
}

#if DEBUG
struct XWWeatherNowView_Previews: PreviewProvider {
    static var previews: some View {
        let weather = XWDEBUGData.weatherNow
        ZStack {
            XWBackgroundView()
            VStack {
                XWWeatherNowView(weather: weather, minutely: XWWeatherMinutely(), temperatureUnit: .celsius)
            }
        }
        .environment(\.locale, Locale(identifier: "zh"))
    }
}
#endif
