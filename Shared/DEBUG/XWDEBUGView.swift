//
//  XWDEBUGView.swift
//  XWeather
//
//  Created by teenloong on 2022/4/30.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI
import Combine

#if false
class XWDEBUGViewModel: ObservableObject {
    let qwclient = QWeatherAPI(key: XWAppConfig.qweatherkey)
    let cywclient = CYWAPI(token: XWAppConfig.cyweatherToken)
    let location = XWDEBUGData.location

    func requestTopCities() {
        qwclient.request(action: QWeatherTopCititesAction()) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestCYWeatherNow() {
        cywclient.request(action: CYWeatherNowAction(longitude: location.longitude, latitude: location.latitude)) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestQWeatherNow() {
        qwclient.request(action: QWeatherNowAction(longitude: location.longitude, latitude: location.latitude)) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestCYWWeatherMinutely() {
        cywclient.request(action: CYWeatherMinutelyAction(longitude: location.longitude, latitude: location.latitude)) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestCYWWeatherHourly() {
        cywclient.request(action: CYWeatherHourlyAction(longitude: location.longitude, latitude: location.latitude)) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestCYWWeatherDaily() {
        cywclient.request(action: CYWeatherDailyAction(longitude: location.longitude, latitude: location.latitude)) { result in
            switch result {
            case .success(let response):
                print(response?.asXWWeatherDaily())
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct XWDEBUGView: View {
    @ObservedObject private var viewModel = XWDEBUGViewModel()
    
    var body: some View {
        VStack {
            Button {
                viewModel.requestTopCities()
            } label: {
                Text("Request Top Cities")
            }
            Button {
                viewModel.requestQWeatherNow()
            } label: {
                Text("Request Weather Now")
            }
            
            Button {
                viewModel.requestCYWeatherNow()
            } label: {
                Text("Request CaiYunWeather Now")
            }
            
            Button {
                viewModel.requestCYWWeatherMinutely()
            } label: {
                Text("Request CaiYunWeather Minutely")
            }
            
            Button {
                viewModel.requestCYWWeatherDaily()
            } label: {
                Text("Request CaiYunWeather Daily")
            }
        }
    }
}

struct XWDEBUGView_Previews: PreviewProvider {
    static var previews: some View {
        XWDEBUGView()
    }
}
#endif
