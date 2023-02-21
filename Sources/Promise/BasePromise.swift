//
//  Promise.swift
//  toolios
//
//  Created by Julien Maire on 08/04/2022.
//  Copyright © 2022 Dazz. All rights reserved.
//

import Foundation

open class BasePromise<ResolveType, RejectType> {
    
    public typealias ResolveCallback = (ResolveType) -> Void
    public typealias RejectCallback = (RejectType) -> Void

    private var resolveCallback: ResolveCallback?
    private var rejectCallback: RejectCallback?
    
    private(set) var resolvedValue: ResolveType?
    private(set) var rejectedValue: RejectType?
    
    private(set) var state: PromiseState = .pending
    
    private let mutex = DispatchSemaphore(value: 1)
    
    private var child: BasePromise<ResolveType, RejectType>?
    
    public init(resolve: ResolveCallback? = nil, reject: RejectCallback? = nil) {
        self.resolveCallback = resolve
        self.rejectCallback = reject
    }
    
    func isResolved() -> Bool {
        return state == .resolved
    }
    
    func isRejected() -> Bool {
        return state == .rejected
    }
    
    func isDone() -> Bool {
        return isResolved() || isRejected()
    }
    
    public func resolve(_ value: ResolveType) {
        mutex.wait()
        defer { mutex.signal() }
        
        state = .resolved
        resolvedValue = value
        rejectedValue = nil
        
        resolveCallback?(value)
        Logger.toolios.info("Promise \(self) resolve with value \(value)")
        
        child?.resolve(value)
    }
    
    public func reject(_ value: RejectType) {
        mutex.wait()
        defer { mutex.signal() }
        
        state = .rejected
        resolvedValue = nil
        rejectedValue = value
        
        rejectCallback?(value)
        Logger.toolios.info("Promise \(self) reject with value \(value)")
        
        child?.reject(value)
    }
    
    public func chain(_ promise: BasePromise<ResolveType, RejectType>) {
        if let child = self.child {
            child.chain(promise)
        } else {
            self.child = promise
        }
    }
    
//    func unchain() {
//        if let parent = self.parent, let child = self.child {
//            parent.chain(child: child)
//        }
//    }
}


extension BasePromise {
    convenience public init(complete: @escaping () -> Void) {
        self.init(resolve: { (_) in
            complete()
        }) { (_) in
            complete()
        }
    }
    
    convenience public init(success: @escaping (Bool) -> Void) {
        self.init(resolve: { (_) in
            success(true)
        }) { (_) in
            success(false)
        }
    }
    
    convenience public init(common: @escaping (ResolveType?) -> Void) {
        self.init(resolve: { (value) in
            common(value)
        }) { (_) in
            common(nil)
        }
    }
}

