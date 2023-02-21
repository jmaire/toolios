//
//  BaseLoader.swift
//  toolios
//
//  Created by Julien Maire on 11/04/2022.
//  Copyright © 2022 Dazz. All rights reserved.
//

import Foundation

open class BaseLoader<DataType>: NSObject {
    
    public typealias CompletionType = (Bool, Error?, DataType?) -> Void
    
    public typealias CompletersKey = AnyObject
    private let completers = LoaderCompleters<CompletersKey, DataType>()
    
    private var loading: Bool = false
    private var error: Error?
    private var data: DataType?
    
    private var cache: CachedData<DataType>?
    
    var lastState: Bool?
    
    //
    
    public override init() {
        super.init()
    }
    
    public init(completer: LoaderCompleter<DataType>) {
        super.init()
        self.completers.set(forKey: self, completer: completer)
    }
    
    convenience public init(completion: @escaping CompletionType) {
        self.init(completer: LoaderCompleter(completion: completion))
    }
    
    convenience public init(promise: Promise<DataType>) {
        self.init(completer: LoaderCompleter(promise: promise))
    }
    
    //
    
    public func isLoading() -> Bool {
        return loading
    }
    
    public func getError() -> Error? {
        return error
    }
    
    public func isErrorCaught() -> Bool {
        return nil != getError()
    }
    
    public func getData() -> DataType? {
        if let data = data {
            return data
        }
        if let cache = cache {
            return cache.get()
        }
        return data
    }
    
    //
    
    func setLoading(_ isLoading: Bool) {
        self.loading = isLoading
    }
    
    func setError(_ error: Error?) {
        self.error = error
    }

    public func setData(_ data: DataType?) {
        self.data = data
        if let cache = cache {
            if let data = data {
                cache.set(data)
            } else {
                cache.remove()
            }
        }
    }
    
    func set(isLoading: Bool, error: Error?, data: DataType?) {
        self.loading = isLoading
        self.error = error
        self.data = data
    }
    
    //
    
    public func setCallback(forKey key: CompletersKey, completer: LoaderCompleter<DataType>) {
        self.completers.set(forKey: key, completer: completer)
    }
    
    public func setCallback(forKey key: CompletersKey, completion: @escaping CompletionType) {
        setCallback(forKey: key, completer: LoaderCompleter(completion: completion))
    }
    
    @discardableResult
    public func setCallback(forKey key: CompletersKey, promise: Promise<DataType>) -> Promise<DataType> {
        setCallback(forKey: key, completer: LoaderCompleter(promise: promise))
        return promise
    }
    
    public func once(forKey key: CompletersKey = NSObject(), completer: LoaderCompleter<DataType>) {
        let onceCompleter = LoaderCompleter<DataType> { isLoading, error, data in
            completer.complete((isLoading, error, data))
            if !isLoading {
                self.removeCallback(forKey: key)
            }
        }
        setCallback(forKey: key, completer: onceCompleter)
    }
    
    public func once(forKey key: CompletersKey = NSObject(), completion: @escaping CompletionType) {
        once(forKey: key, completer: LoaderCompleter(completion: completion))
    }
    
    @discardableResult
    public func once(forKey key: CompletersKey = NSObject(), promise: Promise<DataType>) -> Promise<DataType> {
        once(forKey: key, completer: LoaderCompleter(promise: promise))
        return promise
    }
    
    public func removeCallback(forKey key: CompletersKey) {
        self.completers.remove(forKey: key)
    }
    
    public func removeAllCallbacks() {
        self.completers.removeAll()
    }
    
    //
    
    open func needLoad() -> Bool {
        return nil == getData()
    }
    
    public func get(completer: LoaderCompleter<DataType>) {
        if needLoad() {
            once(completer: completer)
            trigger()
            Logger.toolios.info("Loader \(self) getter triggering load")
        } else {
            completer.complete(getResult())
            Logger.toolios.info("Loader \(self) getter using stored data")
        }
    }
    
    public func get(completion: @escaping CompletionType) {
        get(completer: LoaderCompleter(completion: completion))
    }
    
    @discardableResult
    public func get(promise: Promise<DataType>) -> Promise<DataType> {
        get(completer: LoaderCompleter(promise: promise))
        return promise
    }
    
    //
    
    public func notifyAll() {
        completers.completeAll(data: getResult())
    }
    
    public func notify(forKey key: CompletersKey) {
        completers.complete(forKey: key, data: getResult())
    }
    
    public func notify(forKeys keys: Array<CompletersKey>) {
        completers.complete(forKeys: keys, data: getResult())
    }
    
    public func getResult() -> (Bool, Error?, DataType?) {
        return (isLoading(), getError(), getData())
    }
    
    //
    
    func trigger() {
        fatalError("trigger() has not been overridden")
    }
    
    //
    
    func prepareLoad() {
        setLoading(true)
        setError(nil)
        data = nil
        
        lastState = nil
        
        notifyAll()
    }
    
    public func success(_ data: DataType) {
        self.setLoading(false)
        self.setError(nil)
        self.setData(data)
        
        self.lastState = true
        
        notifyAll()
        Logger.toolios.info("Loader \(self) succeed with data \(data)")
    }
    
    public func fail(_ error: Error) {
        self.setLoading(false)
        self.setError(error)
        self.data = nil
        
        self.lastState = false
        
        notifyAll()
        Logger.toolios.info("Loader \(self) failed with error \(error)")
    }
    
    //
    
    public func setCache(options: CachedDataOptions<DataType>) {
        self.cache = CachedData(options: options)
    }
    
}
