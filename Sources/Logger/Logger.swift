//
//  Logger.swift
//  toolios
//
//  Created by Julien Maire on 10/05/2022.
//  Copyright © 2022-2025 Julien Maire
//

import Foundation

public class Logger {
    
    public static let toolios = Logger(domain: "toolios")
    
    public let domain: String
    
    public var minSeverity: LogSeverity = .debug
    
    public var displayInConsole: Bool = true
    
    public init(domain: String) {
        self.domain = domain
    }
    
    public func log(severiy: LogSeverity, _ messages: Any..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        guard displayInConsole, severiy >= minSeverity else { return }
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let dateString = dateFormatter.string(from: Date())
        
        let fileName: String = file.split(separator: "/").last?.description ?? file.description
        let fileString = "\(function)@\(fileName):\(line):\(column)"
        
        for message in messages {
            print("\(dateString) \(domain) [\(severiy.shortLabel)]: \(message) - {\(fileString)}")
        }
    }
    
    //
    
    public func info(_ messages: Any..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        log(severiy: .info, messages, file: file, function: function, line: line, column: column)
    }
    
    public func debug(_ messages: Any..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        log(severiy: .debug, messages, file: file, function: function, line: line, column: column)
    }
    
    public func warning(_ messages: Any..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        log(severiy: .warning, messages, file: file, function: function, line: line, column: column)
    }
    
    public func error(_ messages: Any..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        log(severiy: .error, messages, file: file, function: function, line: line, column: column)
    }
    
    public func critical(_ messages: Any..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        log(severiy: .critical, messages, file: file, function: function, line: line, column: column)
    }
}
