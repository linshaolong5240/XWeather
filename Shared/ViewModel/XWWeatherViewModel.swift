//
//  XWWeatherViewModel.swift
//  XWeather
//
//  Created by teenloong on 2022/5/29.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
import Combine
import CoreLocation
import Contacts.CNPostalAddress
import XWeatherKit

class XWWeatherViewModel: ObservableObject {
    var cancells = Set<AnyCancellable>()
    
    let index: Int
    @Published var weather: XWWeather
    @Published var temperatureUnit: XWTemperature.Unit = .celsius

    init(weather: XWWeather, index: Int) {
        self.index = index
        self.weather = weather
        if weather.isCurrentLocation {
            XWLocationManager.shared.$currentPlacemark.compactMap({ $0 }).sink { [weak self] placemark in
                self?.weather.location = XWWeatherLocation(placemark: placemark)
//                self?.request(force: true)
            }.store(in: &cancells)
        }
    }
    
//    func request(force: Bool = false) {
//        if let date = weather.now.updateDate, !force {
//            print(Date(), date)
//            if Date().timeIntervalSince1970 - date.timeIntervalSince1970 < 5 * 60 {
//                return
//            }
//        }
//        guard let location = weather.location else {
//            return
//        }
//        let p1 = XW.weatherNow(location: location)//.assign(to: \.weather.now, on: self).store(in: &cancells)
//        let p2 = XW.weatherMinutely(location: location)//.assign(to: \.weather.minutely, on: self).store(in: &cancells)
//        let p3 = XW.weatherDaily(location: location).map({ items in
//            Array(items[0..<5])
//        })//.assign(to: \.weather.daily, on: self).store(in: &cancells)
//        let com = Publishers.CombineLatest3(p1, p2, p3)
//        com.sink {[weak self] (weatherNow, weatherMinutely, weatherDaily) in
//            self?.updateWeather(weatherNow: weatherNow, weatherMinutely: weatherMinutely, weatherDaily: weatherDaily)
//        }.store(in: &cancells)
////        $weather.sink { weather in
////            XWStore.shared.dispatch(.updateWeather(weather: weather))
////        }.store(in: &cancells)
//    }
    
    func updateWeather(weatherNow: XWWeatherNow, weatherMinutely: XWWeatherMinutely, weatherDaily: XWWeatherDaily) {
        var temp = weather
        temp.now = weatherNow
        temp.minutely = weatherMinutely
        temp.daily = weatherDaily
        weather = temp
        XWStore.shared.dispatch(.updateWeather(weather: weather, index: index))
    }
    
    func updateLocation() {
        XWLocationManager.shared.updateLocation()
    }
}
