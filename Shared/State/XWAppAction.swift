//
//  XWAppAction.swift
//  XWeather
//
//  Created by teenloong on 2022/5/24.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
import SwiftUI
import WidgetKit
import XWeatherKit

enum XWAppAction {
    case initAction
    case error(XWAppError)
    case addWeather(weather: XWWeather)
    case deleteWeather(index: Int)
    case updateWeather(weather: XWWeather, index: Int)
    case updateWeatherTemperatureUnit(unit: XWTemperature.Unit, index: Int)
    case updateWeatherRequest(index: Int)
    case updateWeatherRequestDone(index: Int, now: XWWeatherNow, minutely: XWWeatherMinutely, hourly: XWWeatherHourly, daily: XWWeatherDaily)
    case updateWeatherLocation(location: XWWeatherLocation)
    case moveWeather(fromOffsets: IndexSet, toOffset: Int)
    case widgetReload(kind: String? = nil)
}
