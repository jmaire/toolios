//
//  NSError.swift
//  toolios
//
//  Created by Julien Maire on 11/04/2022.
//  Copyright © 2022-2025 Julien Maire
//

import Foundation

extension NSError {
    
    static let tooliosDomain = "toolios"
    
    static let unknownError = NSError(code: -1, userInfo: [NSLocalizedDescriptionKey: "An unknown error has occurred"])
    
    static let unknownPromiseResultError = NSError(code: 1, userInfo: [NSLocalizedDescriptionKey: "Unknown promise result error"])

    convenience init(code: Int, userInfo: [String : Any]?) {
        self.init(domain: NSError.tooliosDomain, code: code, userInfo: userInfo)
    }
    
}
