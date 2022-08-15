//
//  XWBackgroundView.swift
//  XWeather
//
//  Created by teenloong on 2022/5/22.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI

struct XWBackgroundView: View {
    var body: some View {
        LinearGradient(colors: [Color(#colorLiteral(red: 0.9607945085, green: 0.9610412717, blue: 0.968652308, alpha: 1)), Color(#colorLiteral(red: 0.8548126221, green: 0.8590049744, blue: 0.8666983247, alpha: 1))], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
    }
}

#if DEBUG
struct XWBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        XWBackgroundView()
    }
}
#endif
