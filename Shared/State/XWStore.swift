//
//  XWStore.swift
//  XWeather
//
//  Created by teenloong on 2022/5/24.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
import Combine
import WidgetKit
import XWeatherKit

public class XWStore: ObservableObject {
    var cancells = Set<AnyCancellable>()
    public static let shared = XWStore()
    @Published var appState = XWAppState()
    
    init() {
        XWLocationManager.shared.$currentPlacemark.compactMap({ $0 }).sink { placemark in
            XWStore.shared.dispatch(.updateWeatherLocation(location: XWWeatherLocation(placemark: placemark)))
        }.store(in: &cancells)
    }
    
    func dispatch(_ action: XWAppAction) {
        #if DEBUG
        print("[ACTION]: \(action)")
        #endif
        let result = reduce(state: appState, action: action)
        appState = result.0
        if let appCommand = result.1 {
            #if DEBUG
            print("[COMMAND]: \(appCommand)")
            #endif
            appCommand.execute(in: self)
        }
    }
    
    func reduce(state: XWAppState, action: XWAppAction) -> (XWAppState, XWAppCommand?) {
        var appState = state
        var appCommand: XWAppCommand? = nil
        switch action {
        case .initAction:
            appCommand = InitActionCommand()
        case .error(let error):
            appState.error = error
        case .addWeather(let weather):
            appState.weather.weathers.append(weather)
            appCommand = XWWeatherRequestCommand(index: appState.weather.weathers.count - 1)
        case .deleteWeather(let index):
            appState.weather.weathers.remove(at: index)
        case .updateWeather(let weather, let index):
            appState.weather.weathers[index] = weather
        case .updateWeatherTemperatureUnit(let unit, let index):
            appState.weather.weathers[index].unit = unit
        case .updateWeatherRequest(let index):
            appCommand = XWWeatherRequestCommand(index: index)
        case .updateWeatherRequestDone(let index, let now , let minutely, let hourly, let daily):
            appState.weather.weathers[index].now = now
            appState.weather.weathers[index].minutely = minutely
            appState.weather.weathers[index].hourly = hourly
            appState.weather.weathers[index].daily = daily
        case .updateWeatherLocation(let location):
            appState.weather.weathers[0].location = location
            appCommand = XWWeatherRequestCommand(index: 0)
        case .moveWeather(let  fromOffsets, let toOffset):
            appState.weather.weathers.move(fromOffsets: fromOffsets, toOffset: toOffset)
        case .widgetReload(let kind):
            appCommand = WidgetReloadCommand(kind: kind)
        }
        
        return (appState, appCommand)
    }
}
