//
//  XWWeatherLocationPicker.swift
//  XWeather
//
//  Created by teenloong on 2022/4/30.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI
import Foundation
import Combine
import CoreLocation
import Contacts.CNPostalAddress
import XWeatherKit

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class XWWeatherLocationPickerViewModel: ObservableObject {
    private var cancells = Set<AnyCancellable>()
    
    var locationManager = XWLocationManager.shared
    @Published var searchKey = ""
    @Published var result = [XWWeatherLocation]()
    @Published var popularCities = [XWWeatherLocation]()
    @Published var showPupularCities: Bool = true
    
    @Published var currentLocation: XWWeatherLocation?
    
    var isShowPupularCitiesValid: AnyPublisher<Bool, Never> {
        $searchKey.map { $0.isEmpty }.eraseToAnyPublisher()
    }
    
    init() {
        isShowPupularCitiesValid.assign(to: \.showPupularCities, on: self).store(in: &cancells)
        $searchKey.throttle(for: 2, scheduler: RunLoop.main, latest: true).filter({ $0.count > 0 }).sink { complete in
            
        } receiveValue: {[weak self] key in
            guard let weakSelf = self else { return }
            weakSelf.requestSearchCities(searchKey: key)
        }.store(in: &cancells)
        locationManager.$currentPlacemark.compactMap({ $0 }).sink(receiveValue: { [weak self] placemark in
            guard let weakSelf = self else { return}
            weakSelf.currentLocation = XWWeatherLocation(placemark: placemark)
        }).store(in: &cancells)
        requestPopularCities()
    }
    
    func myLocation() {
        locationManager.updateLocation()
    }
    
    private func requestPopularCities() {
        XWeather.debug().requestPublisher(action: QWeatherTopCititesAction(parameters: .init(range: Locale.current.regionCode?.lowercased(), lang: Locale.current.languageCode, key: XWAppConfig.qweatherkey)))
            .sink(receiveCompletion: { completion in

            }, receiveValue: { [weak self] response in
                guard let weakSelf = self else {
                    return
                }
                
                weakSelf.popularCities = response.topCityList.map({ XWWeatherLocation(latitude: $0.lat, longitude: $0.lon, name: $0.name)})
            })
            .store(in: &cancells)
    }
    
    private func requestSearchCities(searchKey: String) {
#if DEBUG
        print("requestSearchCities: \(searchKey)")
#endif
        XWeather.requestPublisher(action: QWeatherSearchCityAction(parameters: .init(searchKey: searchKey, range: Locale.current.regionCode?.lowercased(), lang: Locale.current.languageCode, key: XWAppConfig.qweatherkey)))
            .sink(receiveCompletion: { completion in

            }, receiveValue: { [weak self] response in
                guard let weakSelf = self else {
                    return
                }
                
                weakSelf.result = response.location.map({ XWWeatherLocation(latitude: $0.lat, longitude: $0.lon, name: $0.name)})
            })
            .store(in: &cancells)
    }
}

struct XWWeatherLocationPicker<LocationContent, Content>: View where LocationContent: View, Content: View {
    @Binding var selection: XWWeatherLocation?
    let locationContent: (XWWeatherLocation?) -> LocationContent
    let content: (XWWeatherLocation) -> Content
    
    init(selection: Binding<XWWeatherLocation?>, @ViewBuilder locationContent: @escaping (XWWeatherLocation?) -> LocationContent, @ViewBuilder content: @escaping (XWWeatherLocation) -> Content) {
        self._selection = selection
        self.locationContent = locationContent
        self.content = content
    }
    
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var viewModel = XWWeatherLocationPickerViewModel()
    @State private var showPopularCities = true
    
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray)
                        .frame(height: 32)
                        .overlay(
                            HStack {
                                Image(systemName: "magnifyingglass")
                                TextField(LocalizedStringKey("Enter the name of the city"), text: $viewModel.searchKey)
                                Spacer()
                            }
                                .font(.system(size: 14))
                                .foregroundColor(.secondaryText)
                                .padding(.horizontal)
                        )
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondaryText)
                    }
                }.padding(.horizontal)
                let columns: [GridItem] =
                Array(repeating: .init(.flexible()), count: 3)
                LazyVGrid(columns: columns, spacing: 13) {
                    Button {
                        if let current = viewModel.currentLocation {
                            selection = current
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            viewModel.myLocation()
                        }
                    } label: {
                        locationContent(viewModel.currentLocation)
                    }
                    ForEach(viewModel.showPupularCities ? viewModel.popularCities : viewModel.result) { item in
                        Button {
                            selection = item
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            content(item)
                        }
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
            .padding(.vertical)
        }
        #if canImport(UIKit)
        .navigationBarHidden(true)
        .alert(isPresented: $viewModel.locationManager.showGoToSystemAuthorizationAlert
        ) {
            .locationAuthorization
        }
        #endif
        .onAppear {
            viewModel.locationManager.updateLocation()
        }
    }
}

#if DEBUG
struct XWWeatherLocationPickerDemo: View {
    @State private var selection: XWWeatherLocation? = XWWeatherLocation(latitude: "39.90498", longitude: "116.40528", name: Optional("北京"))
    @State private var showPicker: Bool = true
    
    var body: some View {
        VStack {
            Text(selection?.name ?? "Unknown")
            Button {
                showPicker.toggle()
            } label: {
                Text("show pciker")
            }
        }
        .sheet(isPresented: $showPicker) {
            XWWeatherLocationPicker(selection: $selection) { location in
                XWPanelView()
                    .frame(height: 30)
                    .overlay(
                        HStack {
                            Image(systemName: "location")
                            Text(LocalizedStringKey(location?.name ?? "-"))
                                .font(.system(size: 14))
                                .foregroundColor(.mainText)
                        }
                    )
            } content: { item in
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
        .onChange(of: selection) { newValue in
//            #if DEBUG
//            print(newValue)
//            #endif
        }
    }
}

struct XWWeatherLocationPicker_Previews: PreviewProvider {
    static var previews: some View {
        XWWeatherLocationPickerDemo()
    }
}
#endif
