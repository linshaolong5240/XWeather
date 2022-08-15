//
//  XWLocationManager.swift
//  XWeather
//
//  Created by teenloong on 2022/4/30.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
import Combine
import CoreLocation
import Contacts.CNPostalAddress

public class XWLocationManager: NSObject, ObservableObject {
    static let shared = XWLocationManager()
    let clLocationManager: CLLocationManager
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentLocation: CLLocation?
    @Published var currentPlacemark: CLPlacemark?

    var didChangeAuthorizationHandler: ((CLAuthorizationStatus) -> Void)?
    
    @Published var showGoToSystemAuthorizationAlert: Bool = false
    
    override init() {
        clLocationManager = CLLocationManager()
        
        super.init()
        
        clLocationManager.delegate = self
    }
}
extension XWLocationManager {
    
    func requestAuthorization(authorizationHandler: ((CLAuthorizationStatus) -> Void)? = nil) {
        didChangeAuthorizationHandler = authorizationHandler
        clLocationManager.requestAlwaysAuthorization()
        clLocationManager.requestWhenInUseAuthorization()
    }
    
    func updateLocation() {
#if DEBUG
        print("location authorizationStatus: \(authorizationStatus.rawValue)")
#endif
        if authorizationStatus == .notDetermined {
            requestAuthorization()
            return
        }
        
        guard authorizationStatus != .denied && authorizationStatus != .restricted else {
            showGoToSystemAuthorizationAlert = true
            return
        }

        #if os(macOS)
        guard authorizationStatus == .authorizedAlways else {
            return
        }
        #else
        guard authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse else {
            return
        }
        #endif

        //        clLocationManager.desiredAccuracy
        clLocationManager.startUpdatingLocation()
    }
    
}

extension XWLocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        #if false
        print("didChangeAuthorization:\(status.rawValue)")
        #endif
        authorizationStatus = status
        didChangeAuthorizationHandler?(status)
        updateLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        guard let location = locations.last else {
            return
        }
        #if false
        print("didUpdateLocations: \(location)")
        #endif

        currentLocation = location
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: nil) {[weak self] placemarks, error in
            #if false
            print(placemarks)
            print(error)
            #endif
            if let placemark = placemarks?.first {
                self?.currentPlacemark = placemark
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
