//
//  XWWeatherDailyView.swift
//  XWeather
//
//  Created by teenloong on 2022/7/19.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI
import XWeatherKit

struct XWWeatherDailyView: View {
    let weathetDaily: XWWeatherDaily
    @Binding var tempratureUnit: XWTemperature.Unit
    
    init(weathetDaily: XWWeatherDaily, temperatureUnit: Binding<XWTemperature.Unit>) {
        self.weathetDaily = weathetDaily
        self._tempratureUnit = temperatureUnit
    }
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 10) {
            Text("\(Image(systemName: "calendar")) \("%@ days forecast".localizeWithFormat(arguments: "15"))")
            Divider()
            ForEach(weathetDaily.daily.indices, id: \.self) { index in
                XWeatherDailyRowView(daily: weathetDaily.daily[index], temperatureUnit: tempratureUnit)
            }
        }
        .foregroundColor(.secondaryText)
        .padding()
        .background(XWPanelView())
        .padding(.horizontal)
    }
}

#if DEBUG
struct XWWeatherDailyView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            XWWeatherDailyView(weathetDaily: XWDEBUGData.weatherDaily, temperatureUnit: .constant(.celsius))
        }
    }
}
#endif

fileprivate struct XWeatherDailyRowView: View {
    let daily: XWWeatherDaily.Daily
    let temperatureUnit: XWTemperature.Unit
    
    var body: some View {
        HStack {
            if let date = daily.updateDate {
                Group {
                    if date.isToday {
                        Text(date.relativeDateString(dateStyle: .short, timeStyle: .none))
                            .font(.system(size: 18, weight: .medium))
                    } else {
                        Text(date.formatString("EE", localized: true))
                            .font(.system(size: 18, weight: .medium))
                    }
                }
                Text(date.formatString("MM/dd"))
            }
            Text(Image(systemName: daily.weatherType.systemImageName))
                .font(.system(size: 30, weight: .bold))
                .frame(width: 60)
                .foregroundColor(.mainText)
            Text(LocalizedStringKey(daily.weatherType.name))
                .font(.system(size: 14, weight: .medium))
                .frame(width: 60, alignment: .leading)
            HStack(alignment: .top, spacing: 2) {
                if let min = daily.temperatureMinString(for: temperatureUnit) {
                    Text(min)
                        .font(.system(size: 16, weight: .medium))
                    Text(temperatureUnit.symbol)
                        .font(.system(size: 8, weight: .medium))
                }
                Spacer()
                if let max = daily.temperatureMinString(for: temperatureUnit) {
                    Text(max)
                        .font(.system(size: 16, weight: .medium))
                    Text(temperatureUnit.symbol)
                        .font(.system(size: 8, weight: .medium))
                }
            }
        }
        .foregroundColor(.secondaryText)
    }
}
