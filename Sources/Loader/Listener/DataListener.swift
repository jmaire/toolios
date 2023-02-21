//
//  DataLoader.swift
//  toolios
//
//  Created by Julien Maire on 11/04/2022.
//  Copyright © 2022 Dazz. All rights reserved.
//

import Foundation

open class DataListener<DataType>: BaseLoader<DataType> {
    
    public typealias ListenerDetacherType = () -> Void
    
    private var listenerDetacher: ListenerDetacherType?
    
    private let mutex = DispatchSemaphore(value: 1)
    
    //
    
    deinit {
        stopListening()
    }
    
    // TO OVERRIDE
    open func listenAction() throws -> ListenerDetacherType {
        fatalError("listenAction() has not been overridden")
    }
    
    override func trigger() {
        listen()
    }
    
    public func isListening() -> Bool {
        return nil != listenerDetacher
    }
    
    public func stopListening() {
        mutex.wait()
        defer { mutex.signal() }
        
        listenerDetacher?()
        listenerDetacher = nil
    }
    
    private func tryListen() -> DataListenerStatus {
        mutex.wait()
        defer { mutex.signal() }
        
        if isListening() {
            return .alreadyOn
        } else {
            prepareLoad()
            do {
                listenerDetacher = try listenAction()
                return .success
            } catch {
                fail(error)
                return .fail
            }
        }
    }
    
    public func listen() {
        let res = tryListen()
        if res == .alreadyOn {
            notifyAll()
        }
    }
    
    @available(*, deprecated, message: "Use listen(forKey: completer:)")
    public func listen(forKey key: CompletersKey) {
        let res = tryListen()
        if res == .alreadyOn {
            notify(forKey: key)
        }
    }
    
    @available(*, deprecated, message: "Use listen(forKey: completer:)")
    public func listen(forKeys keys: Array<CompletersKey>) {
        let res = tryListen()
        if res == .alreadyOn {
            notify(forKeys: keys)
        }
    }
    
    public func listen(forKey key: CompletersKey, completer: LoaderCompleter<DataType>) {
        setCallback(forKey: key, completer: completer)
        let res = tryListen()
        if res == .alreadyOn {
            notify(forKey: key)
        }
    }
    
    public func listen(forKey key: CompletersKey, completion: @escaping CompletionType) {
        listen(forKey: key, completer: LoaderCompleter(completion: completion))
    }
    
    public func listen(forKey key: CompletersKey, promise: Promise<DataType>) {
        listen(forKey: key, completer: LoaderCompleter(promise: promise))
    }
}
