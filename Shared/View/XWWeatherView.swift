//
//  XWWeatherView.swift
//  XWeather
//
//  Created by teenloong on 2022/5/29.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI
import XWeatherKit

struct XWWeatherView: View {
    let weather: XWWeather
    let index: Int
    @StateObject private var locationManager = XWLocationManager.shared
    @State private var temperatureUnitSwitch: Bool
    @State private var temperatureUnit: XWTemperature.Unit
    @State private var showDeleteAlert: Bool = false
    @State private var showCurrentLocationDeleteAlert: Bool = false
    @State private var selection: XWWeatherLocation? = nil
    @State private var showLocationPicker: Bool = false
    @State private var showManager: Bool = false
    
    init(weather: XWWeather, index: Int) {
        self.weather = weather
        self.index = index
        self._temperatureUnitSwitch = State(initialValue: weather.unit == .celsius ? false : true)
        self._temperatureUnit = State(initialValue: weather.unit)
    }
    
    var body: some View {
        ZStack {
            XWBackgroundView()
            #if canImport(UIKit)
            Color.clear
                .alert(isPresented: $locationManager.showGoToSystemAuthorizationAlert
                ) {
                    .locationAuthorization
                }
            #endif
            Color.clear
                .alert(isPresented: $showCurrentLocationDeleteAlert) {
                    Alert(title: Text("Cannot delete current location！"))
                }
            Color.clear
                .alert(isPresented: $showDeleteAlert) {
                    Alert(title: Text("Delete?"), message: Text("Sure to delete location?"), primaryButton: .destructive(Text("Delete"), action: {
                        XWStore.shared.dispatch(.deleteWeather(index: index))
                    }), secondaryButton: .cancel())
                }
            
//            NavigationLink(isActive: $showManager, destination: {
//                XWWeatherManagerView()
//            }, label: {
//                EmptyView()
//            })
//
            VStack(spacing: 20) {
                HStack {
                    Text(weather.location?.name ?? "-")
                        .font(.title)
                        .bold()
                    if weather.isCurrentLocation {
                        Button {
                            XWLocationManager.shared.updateLocation()
                        } label: {
                            Text(Image(systemName: "location.fill"))
                                .bold()
                        }
                    }
                }
                .frame(height: 44)
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        HStack {
                            Text("°C")
                                .bold()
                                .foregroundColor(.white)
                                .padding(4)
                                .background(Circle().foregroundColor(temperatureUnitSwitch ? .secondary : .mainText))
                            let tintColor: Color = Color(#colorLiteral(red: 0.8705878854, green: 0.8705884814, blue: 0.8834975362, alpha: 1))
                            Toggle(isOn: $temperatureUnitSwitch) {
                                Text("Unit")
                            }
                            .labelsHidden()
                            .toggleStyle(SwitchToggleStyle(tint: tintColor))
                            .fixedSize()
                            .onChange(of: temperatureUnitSwitch) { newValue in
                                temperatureUnit = newValue ? .fahrenheit : .celsius
                                XWStore.shared.dispatch(.updateWeatherTemperatureUnit(unit: temperatureUnit, index: index))
                            }
                            Text("°F")
                                .bold()
                                .foregroundColor(.white)
                                .padding(4)
                                .background(Circle().foregroundColor(temperatureUnitSwitch ? .mainText : .secondary))
                            Spacer()
                            Button {
                                XWStore.shared.dispatch(.updateWeatherRequest(index: index))
                            } label: {
                                Text(Image(systemName: "arrow.triangle.2.circlepath"))
                                    .bold()
//                                    .frame(width: 44, height: 44)
                            }
                            .contentShape(Rectangle())
                            if !weather.isCurrentLocation {
                                Button {
                                    guard !weather.isCurrentLocation else {
                                        showCurrentLocationDeleteAlert = true
                                        return
                                    }
                                    showDeleteAlert = true
                                } label: {
                                    Text(Image(systemName: "minus"))
                                        .bold()
//                                        .frame(width: 44, height: 44)
                                }
                                .contentShape(Rectangle())
                            }
                            Button {
                                showLocationPicker.toggle()
                            } label: {
                                Text(Image(systemName: "plus"))
                                    .bold()
//                                    .frame(width: 44, height: 44)
                            }
                            .contentShape(Rectangle())
                            .sheet(isPresented: $showLocationPicker) {
                                XWWeatherLocationPicker(selection: $selection) { location in
                                    XWPanelView()
                                        .frame(height: 30)
                                        .overlay(
                                            HStack {
                                                Image(systemName: "location")
                                                Text(LocalizedStringKey(location?.name ?? "My location"))
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.mainText)
                                            }
                                        )
                                } content: { item in
                                    Button {
                                        XWStore.shared.dispatch(.addWeather(weather: XWWeather(location: item)))
                                    } label: {
                                        XWPanelView()
                                            .frame(height: 30)
                                            .overlay(
                                                HStack {
                                                    Text(item.name ?? "Unknown")
                                                        .font(.system(size: 14))
                                                }
                                                    .foregroundColor(.mainText)
                                            )
                                    }
                                }
#if os(macOS)
                                .frame(width: 400, height: 300)
#endif
                            }
                            if weather.isCurrentLocation {
                                Button {
                                    showManager.toggle()
                                } label: {
                                    Text(Image(systemName: "list.bullet"))
                                        .bold()
//                                        .frame(width: 44, height: 44)
                                }
                                .contentShape(Rectangle())
                                .sheet(isPresented: $showManager) {
                                    XWWeatherManagerView()
#if os(macOS)
                                        .frame(width: 400, height: 300)
#endif
                                }
                            }
                        }
                        .padding(.horizontal)
                        XWWeatherNowView(weather: weather.now, minutely: weather.minutely, temperatureUnit: temperatureUnit)
                        XWWeatherHourlyView(temperatureUnit: temperatureUnit, weatherHourly: weather.hourly)
                        XWWeatherDailyView(weathetDaily: weather.daily, temperatureUnit: $temperatureUnit)
                        Spacer()
                    }
                }
            }
        }
        .foregroundColor(.mainText)
        .onAppear {
            if weather.isCurrentLocation && weather.location == nil {
                locationManager.updateLocation()
            }
            if weather.isUpdateValid(timeInterval: 5 * 60) {
                XWStore.shared.dispatch(.updateWeatherRequest(index: index))
            }
        }
    }
}

#if DEBUG
struct XWWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        XWWeatherView(weather: XWWeather.sample, index: 0)
    }
}
#endif
