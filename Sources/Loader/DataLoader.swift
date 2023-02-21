//
//  DataLoader.swift
//  toolios
//
//  Created by Julien Maire on 11/04/2022.
//  Copyright © 2022 Dazz. All rights reserved.
//

import Foundation

open class DataLoader<DataType>: BaseLoader<DataType> {
    
    private let mutex = DispatchSemaphore(value: 1)
    
    //
    
    // TO OVERRIDE
    open func loadAction() throws -> Void {
        fatalError("loadAction() has not been overridden")
    }
    
    override func trigger() {
        load()
    }
    
    public func load() {
        mutex.wait()
        defer { mutex.signal() }
        
        guard !isLoading() else { return }
        prepareLoad()
        do {
            try loadAction()
        } catch {
            fail(error)
        }
    }
    
}
