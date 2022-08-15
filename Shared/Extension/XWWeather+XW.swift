//
//  XWWeather+XW.swift
//  XWeather
//
//  Created by teenloong on 2022/8/12.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
import XWeatherKit

extension XWWeather {
    public static let sample: XWWeather = XWWeather(location: XWWeatherLocation(latitude: "39.90498", longitude: "116.40528", name: Optional("北京")), now: XWDEBUGData.weatherNow, minutely: XWDEBUGData.weatherMinutely, hourly: XWDEBUGData.weatherHourly, daily: XWDEBUGData.weatherDaily)
}
