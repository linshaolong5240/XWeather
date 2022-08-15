//
//  XWTemperatureView.swift
//  XWeather
//
//  Created by teenloong on 2022/8/9.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI
import XWeatherKit

struct XWTemperatureView: View {
    let unit: XWTemperature.Unit
    let value: Int
    let fontSize: CGFloat
    @State private var temperatureValue: Int = 0

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            XWRollingNumber(font: .system(size: fontSize, weight: .bold), value: $temperatureValue)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        temperatureValue = value
                    }
                }
                .id(value)
            Text(unit.symbol)
                .font(.system(size: CGFloat(Int(fontSize / 3)), weight: .bold))
        }
    }
}

#if DEBUG
struct XWTemperatureView_Previews: PreviewProvider {
    static var previews: some View {
        XWTemperatureView(unit: .celsius, value: 29, fontSize: 60)
    }
}
#endif
