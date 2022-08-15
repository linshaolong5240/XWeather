//
//  XWAppCommand.swift
//  XWeather
//
//  Created by teenloong on 2022/5/24.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI
import Combine
import WidgetKit
import XWeatherKit

protocol XWAppCommand {
    func execute(in store: XWStore)
}

struct InitActionCommand: XWAppCommand {
    func execute(in store: XWStore) {
        
    }
}

struct XWWeatherRequestCommand: XWAppCommand {
    let index: Int
    
    func execute(in store: XWStore) {
        let weather = store.appState.weather.weathers[index]
        
        guard let location = weather.location else {
            return
        }
        
//        let p1 = XW.weatherNow(location: location)
//        let p2 = XW.weatherMinutely(location: location)
//        let p3 = XW.weatherDaily(location: location, dailysteps: 5)
//        let com = Publishers.CombineLatest3(p1, p2, p3)
//        com.receive(on: RunLoop.main).sink { (weatherNow, weatherMinutely, weatherDaily) in
//            XWStore.shared.dispatch(.updateWeatherRequestDone(index: index, now: weatherNow, weatherMinutely, daily: weatherDaily))
//        }.store(in: &store.cancells)
        
        XWeather.requestPublisher(action: CYWeatherDetailAction(parameters: .init(token: XWAppConfig.cyweatherToken, longitude: location.longitude, latitude: location.latitude, hourlysteps: 24, dailysteps: 15, lang: Locale.current.identifier, unit: .metric))).sink { completion in
            if case .failure(let error) = completion {
                store.dispatch(.error(.error(error)))
            }
        } receiveValue: { responsne in
            let now = XWWeatherNow(responsne.result.realtime)
            let minutely = XWWeatherMinutely(responsne.result.minutely)
            let hourly = responsne.result.hourly.asHourly(step: 24)
            let daily = responsne.result.daily.asDaily(steps: 15)
            XWStore.shared.dispatch(.updateWeatherRequestDone(index: index, now: now, minutely: minutely, hourly: hourly, daily: daily))
        }
        .store(in: &store.cancells)

    }
}

struct WidgetReloadCommand: XWAppCommand {
    var kind: String? = nil
    
    func execute(in store: XWStore) {
        if let k = kind {
            WidgetCenter.shared.reloadTimelines(ofKind: k)
        }else {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
