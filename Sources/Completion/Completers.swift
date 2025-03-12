//
//  Completers.swift
//  toolios
//
//  Created by Julien Maire on 13/04/2022.
//  Copyright © 2022-2025 Julien Maire
//

import Foundation

public class Completers<KeyType: AnyObject, CompletionType> {
    
    private let completers = NSMapTable<KeyType, Completer<CompletionType>>(keyOptions: .weakMemory, valueOptions: .strongMemory)

    public init() {
    }
    
    public func set(forKey key: KeyType, completer: Completer<CompletionType>) {
        completers.setObject(completer, forKey: key)
    }
    
    public func chain(forKey key: KeyType, completer: Completer<CompletionType>) {
        if let currentCompleter = completers.object(forKey: key) {
            currentCompleter.chain(completer)
        } else {
            set(forKey: key, completer: completer)
        }
    }
    
    public func remove(forKey key: KeyType) {
        completers.removeObject(forKey: key)
    }
    
    public func removeAll() {
        completers.removeAllObjects()
    }
    
    public func complete(forKey key: KeyType, data: CompletionType) {
        if let completer = completers.object(forKey: key) {
            completer.complete(data)
        }
    }
    
    public func complete(forKeys keys: Array<KeyType>, data: CompletionType) {
        for key in keys {
            complete(forKey: key, data: data)
        }
    }
    
    public func completeAll(data: CompletionType) {
        let enumerator = completers.objectEnumerator()
        while let completer: Completer<CompletionType> = enumerator?.nextObject() as? Completer<CompletionType> {
            completer.complete(data)
        }
    }
    
}
