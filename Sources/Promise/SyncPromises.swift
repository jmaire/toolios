//
//  SyncPromises.swift
//  toolios
//
//  Created by Julien Maire on 08/04/2022.
//  Copyright © 2022-2025 Julien Maire
//

import Foundation

public class SyncPromises<ResolveType, RejectType> {
    
    public typealias Promise = BasePromise<ResolveType, RejectType>
    public typealias SyncPromise = BasePromise<Array<ResolveType>, Array<RejectType>>
    
    private var promises: Array<Promise> = []
    
    public init(_ promises: Array<Promise> = []) {
        self.promises.append(contentsOf: promises)
    }
    
    public func append(_ newPromise: Promise) {
        promises.append(newPromise)
    }
    
    @discardableResult
    private func sync(_ promise: SyncPromise, syncAction: @escaping (SyncPromise) -> Bool) -> SyncPromise {
        var done: Bool = false
        let mutex = DispatchSemaphore(value: 1)
        
        let childPromise = Promise(complete: {
            completeIfDone()
        })

        func completeIfDone() {
            mutex.wait()
            defer { mutex.signal() }
            
            guard !done else { return }
            done = syncAction(promise)
        }
        
        for _promise in promises {
            _promise.chain(childPromise)
        }
        completeIfDone()
        
        return promise
    }
    
    // Once all promises are done, resolve if all have resolved, else reject
    @discardableResult
    public func all(_ promise: SyncPromise) -> SyncPromise {
        return sync(promise) { (promise) in
            if self.promises.contains(where: { promise in return !promise.isDone() }) {
                return false
            }
            
            let rejectedPromises = self.promises.filter({ promise in return promise.isRejected() })
            if !rejectedPromises.isEmpty {
                var rejectedValues: Array<RejectType> = []
                
                for promise in rejectedPromises {
                    guard let rejectedValue = promise.rejectedValue else { continue }
                    rejectedValues.append(rejectedValue)
                }
                
                promise.reject(rejectedValues)
                return true
            }
            
            var resolvedValues: Array<ResolveType> = []
            for promise in self.promises {
                guard let resolvedValue = promise.resolvedValue else { continue }
                resolvedValues.append(resolvedValue)
            }
            promise.resolve(resolvedValues)
            return true
        }
    }
    
    // Once all promises are done, resolve
    @discardableResult
    public func allSettled(_ promise: SyncPromise) -> SyncPromise {
        return sync(promise) { (promise) in
            if self.promises.contains(where: { promise in return !promise.isDone() }) {
                return false
            }
            
            var resolvedValues: Array<ResolveType> = []
            for promise in self.promises {
                guard let resolvedValue = promise.resolvedValue else { continue }
                resolvedValues.append(resolvedValue)
            }
            promise.resolve(resolvedValues)
            return true
        }
    }
    
    // Once all promises are done, resolve if any has resolved, else reject
    @discardableResult
    public func any(_ promise: SyncPromise) -> SyncPromise {
        return sync(promise) { (promise) in
            if self.promises.contains(where: { promise in return !promise.isDone() }) {
                return false
            }
            
            let resolvedPromises = self.promises.filter({ promise in return promise.isResolved() })
            if !resolvedPromises.isEmpty {
                var resolvedValues: Array<ResolveType> = []

                for promise in resolvedPromises {
                    guard let resolvedValue = promise.resolvedValue else { continue }
                    resolvedValues.append(resolvedValue)
                }
                
                promise.resolve(resolvedValues)
                return true
            }
            
            var rejectedValues: Array<RejectType> = []
            for promise in self.promises {
                guard let rejectedValue = promise.rejectedValue else { continue }
                rejectedValues.append(rejectedValue)
            }
            promise.reject(rejectedValues)
            return true
        }
    }
    
    
}
