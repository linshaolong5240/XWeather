//
//  XWWeatherMiutelyView.swift
//  XWeather
//
//  Created by teenloong on 2022/8/3.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI
import XWeatherKit

struct XWWeatherMiutelyView: View {
    let minutely: XWWeatherMinutely
    
    var body: some View {
        VStack {
            Text("\(Image(systemName: "clock"))Hello, World!")
        }
        .foregroundColor(.secondaryText)
    }
}

#if DEBUG
struct XWWeatherMiutelyView_Previews: PreviewProvider {
    static var previews: some View {
        XWWeatherMiutelyView(minutely: XWDEBUGData.weatherMinutely)
    }
}
#endif
