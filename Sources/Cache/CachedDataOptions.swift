//
//  CachedDataOptions.swift
//  toolios
//
//  Created by Julien Maire on 12/04/2022.
//  Copyright © 2022 Dazz. All rights reserved.
//

import Foundation

public struct CachedDataOptions<DataType> {
    
    public var key: String
    public var defaultData: DataType
    public var userDefaults: UserDefaults = UserDefaults.standard
    
    public init(key: String, defaultData: DataType) {
        self.key = key
        self.defaultData = defaultData
    }
}
