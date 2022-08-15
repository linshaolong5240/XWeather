//
//  XWWeatherManagerView.swift
//  XWeather
//
//  Created by teenloong on 2022/5/24.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI
import Combine
import XWeatherKit

struct XWWeatherManagerView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject private var store: XWStore
    @State private var showDeleteAlert: Bool = false
    @State private var indexToDelete: Int = 0
//#if os(iOS)
//    @State private var isEditMode: EditMode = .active
//#endif
    
    var body: some View {
        ZStack {
            XWBackgroundView()
            VStack(alignment: .trailing) {
                HStack {
                    #if os(iOS)
                    EditButton()
                    #endif
                    Spacer()
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .padding(.horizontal)
                makeList()
            }
            .padding(.vertical)
        }
        .foregroundColor(.mainText)
        .alert(isPresented: $showDeleteAlert) {
            Alert(title: Text("Delete?"), message: Text("Sure to delete location?"), primaryButton: .destructive(Text("Delete"), action: {
                XWStore.shared.dispatch(.deleteWeather(index: indexToDelete))
            }), secondaryButton: .cancel())
        }
        .onAppear {
            // Set the default to clear
#if canImport(UIKit)
            if #available(iOS 15.0, *) {
                // Fallback on earlier versions
            } else {
                UITableView.appearance().backgroundColor = .clear
            }
#endif
        }
//#if os(iOS)
//        .environment(\.editMode, self.$isEditMode)
//#endif
    }
    
    func makeListData() -> some DynamicViewContent {
        ForEach(Array(store.appState.weather.weathers.enumerated()), id: \.offset) { index, item in
            if index != 0 {
                XWWeatherLsitRowView(weather: item)
                .deleteDisabled(index == 0)
                .moveDisabled(index == 0)
            }
        }
        .onDelete { indexSet in
            guard let index = indexSet.first else {
                return
            }
            indexToDelete = index
            showDeleteAlert = true
        }
        .onMove { fromOffsets, toOffset in
            guard toOffset != 0 else {
                return
            }
            
            XWStore.shared.dispatch(.moveWeather(fromOffsets: fromOffsets, toOffset: toOffset))
        }
    }
    
    func makeList() -> some View {
        List {
            if #available(iOS 15.0, *) {
                makeListData()
                    .listRowBackground(Color.clear)
                #if os(iOS)
                    .listRowSeparatorTint(.orange)
                    .listRowSeparator(.hidden)
                #endif
            } else {
                makeListData()
            }
        }
        .listStyle(.plain)
    }
}

#if DEBUG
struct XWCitiesManagerView_Previews: PreviewProvider {
    static var previews: some View {
        XWWeatherManagerView()
            .environmentObject(XWStore.shared)
    }
}
#endif

fileprivate struct XWWeatherLsitRowView: View {
    let weather: XWWeather
    
    var body: some View {
        HStack(alignment: .center) {
            Text(weather.location?.name ?? "-")
                .font(.title3)
                .fontWeight(.medium)
            if weather.isCurrentLocation {
                Button {
                    XWLocationManager.shared.updateLocation()
                } label: {
                    Text(Image(systemName: "location.fill"))
                        .font(.caption)
                        .bold()
                }
            }
            Spacer()
            Text(LocalizedStringKey(weather.now.weatherType.name))
                .font(.title3)
                .fontWeight(.medium)
            Text(Image(systemName: weather.now.weatherType.systemImageName))
                .font(.system(size: 24, weight: .bold))
            let temperature = weather.now.temperature(for: weather.unit)?.rounded() ?? 0
            XWTemperatureView(unit: weather.unit, value: Int(temperature), fontSize: 30)
        }
        .padding(6)
        .background(XWPanelView())
    }
}
