//
//  IntentHandler.swift
//  XWeatherIntent
//
//  Created by teenloong on 2022/8/11.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Intents
import XWeatherKit

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}

extension IntentHandler: XWConfigurationIntentHandling {
//    func provideLocationOptionsCollection(for intent: XWConfigurationIntent, with completion: @escaping (INObjectCollection<WidgetLocation>?, Error?) -> Void) {
//
//    }
    
    func provideLocationOptionsCollection(for intent: XWConfigurationIntent) async throws -> INObjectCollection<WidgetLocation> {
        let locations = XWWidgetDataSource.weathers.compactMap({$0.location}).enumerated().map { index, item -> WidgetLocation in
            let location = WidgetLocation(identifier: String(index), display: index == 0 ? "My location" : (item.name ?? "Unknown"), subtitle: nil, image: nil)
            location.longitude = item.longitude
            location.latitude = item.latitude
            location.name = item.name
            return location
        }
        return INObjectCollection(sections: [INObjectSection(title: "Your location", items: locations)])
    }
    
    
}
