//
//  SwiftUIHelper.swift
//  XWeather
//
//  Created by teenloong on 2022/4/30.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI

@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "use `View.alert(title:isPresented:presenting::actions:) instead.")
@available(macOS, introduced: 10.15, deprecated: 100000.0, message: "use `View.alert(title:isPresented:presenting::actions:) instead.")
@available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "use `View.alert(title:isPresented:presenting::actions:) instead.")
@available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "use `View.alert(title:isPresented:presenting::actions:) instead.")
@available(iOSApplicationExtension, unavailable)
extension Alert {
    #if canImport(UIKit)
    public static func systemAuthorization() {
        guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    public static let locationAuthorization: Alert = Alert(title: Text("Location Permissions"), message: Text("Location Authorization Desc"), primaryButton: .cancel(Text("Cancel")), secondaryButton: .default(Text("Go to Authorization"), action: { systemAuthorization() }))
    public static let photoLibraryAuthorization: Alert = Alert(title: Text("PhotoLibrary Permissions"), message: Text("PhotoLibrary Authorization Desc"), primaryButton: .cancel(Text("Cancel")), secondaryButton: .default(Text("Go to Authorization"), action: { systemAuthorization() }))
    public static let cameraAuthorization: Alert = Alert(title: Text("Camera Permissions"), message: Text("Camera Authorization Desc"), primaryButton: .cancel(Text("Cancel")), secondaryButton: .default(Text("Go to Authorization"), action: { systemAuthorization() }))
    #endif
}
