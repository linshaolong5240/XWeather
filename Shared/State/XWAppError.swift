//
//  XWAppError.swift
//  XWeather
//
//  Created by teenloong on 2022/5/24.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

enum XWAppError: Error, Identifiable {
    var id: String { localizedDescription }
    case error(Error)
}

extension Error {
    func asAppError() -> XWAppError {
        self as? XWAppError ?? XWAppError.error(self)
    }
}


extension XWAppError {
    var localizedDescription: String {
        switch self {
        case .error(let error): return "\(error.localizedDescription)"
        }
    }
}
