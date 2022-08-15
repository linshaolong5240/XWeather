//
//  SwiftUIViewExport.swift
//  XWeather
//
//  Created by teenloong on 2022/5/22.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI
import XWeatherKit

struct SwiftUIViewExport<Content>: View where Content: View{
    struct EditModel: Equatable {
        var width: Int = 1024
        var height: Int = 1024
        var ratio: Double { Double(width) / Double(height) }
        
        var scaleSize: CGSize { CGSize(width: CGFloat(width) / ScreenHelper.mainScale, height: CGFloat(height) / ScreenHelper.mainScale) }
    }
    
    @State private var editModel = EditModel()
    @State private var showExporter = false
    @State private var showExporterButton = false
    @State private var exportImage: CrossImage?
    @State private var exportFileName = ""

    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            let size = editModel.scaleSize.adapterSize(to: geometry.size)

            ZStack {
                Color.clear
                content()
                    .frame(width: size.width, height: size.height, alignment: .center)
            }
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .fileExporter(isPresented: $showExporter, document: ImageFileDocument(image: exportImage), contentType: .png, defaultFilename: exportFileName) { result in
            switch result {
            case .success(let url):
                print("fileExporter success: \(url)")
            case .failure(let error):
                print("fileExporter failure: \(error.localizedDescription)")
            }
        }
        .toolbar {
            ToolbarItemGroup {
                HStack {
                    HStack {
                        Text("Width:")
                        TextField("Width", text: Binding(get: {
                            String(editModel.width)
                        }, set: { editModel.width = Int($0) ?? editModel.width }))
                        .frame(width: 100)
                        Text("Height:")
                        TextField("Height", text: Binding(get: {
                            String(editModel.height)
                        }, set: { editModel.height = Int($0) ?? editModel.height }))
                        .frame(width: 100)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    #if os(iOS)
                    .keyboardType(.numberPad)
                    #endif
                    .onChange(of: editModel) { newValue in
                        print(editModel.width)
                    }
                    Button {
                        exeport()
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                }
            }
        }
        .onAppear {
            #if canImport(UIKit)
            DispatchQueue.main.async {
                exeport()
            }
            #endif
        }
    }
    
    func exeport() {
        exportFileName =  Date().formatString("yyyyMMddHHmmss")
        exportImage = content()
            .frame(width: CGFloat(editModel.scaleSize.width), height: CGFloat(editModel.scaleSize.height))
            .snapshot()
        showExporter.toggle()

    }
}

struct SwiftUIViewExportDemo: View {
    var body: some View {
        SwiftUIViewExport {
            let weather = XWWeatherNow(description: "description", effectiveTemperature: XWTemperature(unit: .celsius, value: 27), humidity: 0.8, temperature: XWTemperature(unit: .celsius, value: 28), visibility: 0.9, weathType: .rain_showers_day, windInfo: .init(direct: .init(angle: 22.5), level: 2, speed: 60.5))
            ZStack {
                XWBackgroundView()
                XWWeatherNowView(weather: weather, minutely: XWWeatherMinutely(), temperatureUnit: .celsius)
                    .padding()
                    .padding()
                    .padding(.vertical)
                    .padding(.vertical)
                    .padding(.vertical)
                    .padding(.vertical)
                    .padding(.vertical)
                    .padding(.vertical)
            }
//            .padding(100)
        }
        .padding()
    }
}

#if DEBUG
struct SwiftUIViewExport_Previews: PreviewProvider {
    static var previews: some View {
//        NavigationView {
            SwiftUIViewExportDemo()
//        }
    }
}
#endif
