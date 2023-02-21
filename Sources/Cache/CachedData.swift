//
//  CachedData.swift
//  toolios
//
//  Created by Julien Maire on 12/04/2022.
//  Copyright © 2022 Dazz. All rights reserved.
//

import Foundation

open class CachedData<DataType> {
        
    private var localData: DataType?
    private let defaultData: DataType
    
    private let key: String
    
    private let userDefaults: UserDefaults
    
    public init(options: CachedDataOptions<DataType>) {
        self.key = options.key
        self.defaultData = options.defaultData
        self.userDefaults = options.userDefaults
    }
    
    func getCachedData() -> DataType? {
        return userDefaults.object(forKey: key) as? DataType
    }
    
    public func get() -> DataType {
        if let localData = self.localData {
            return localData
        }
        
        if let cachedData = getCachedData() {
            self.localData = cachedData
            return cachedData
        }
        
        return defaultData
    }
    
    public func set(_ data: DataType) {
        self.localData = data
        userDefaults.set(data, forKey: key)
        Logger.toolios.info("Set cached value for key \(key) to data \(data)")
    }
    
    public func remove() {
        localData = nil
        userDefaults.removeObject(forKey: key)
        Logger.toolios.info("Removing cache for key \(key)")
    }
}
