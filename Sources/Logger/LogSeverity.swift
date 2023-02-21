//
//  LogSeverity.swift
//  toolios
//
//  Created by Julien Maire on 10/05/2022.
//  Copyright © 2022 Dazz. All rights reserved.
//

import Foundation

public enum LogSeverity: Int {
    
    case critical = 5
    case error = 4
    case warning = 3
    case info = 2
    case debug = 1
    
    var label: String {
        switch self {
        case .critical:
            return "CRITICAL"
        case .error:
            return "ERROR"
        case .warning:
            return "WARNING"
        case .info:
            return "INFO"
        case .debug:
            return "DEBUG"
        }
    }
    
    var shortLabel: String {
        switch self {
        case .critical:
            return "CRT"
        case .error:
            return "ERR"
        case .warning:
            return "WRN"
        case .info:
            return "INF"
        case .debug:
            return "DBG"
        }
    }
}

extension LogSeverity: Comparable {
    public static func < (lhs: LogSeverity, rhs: LogSeverity) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
