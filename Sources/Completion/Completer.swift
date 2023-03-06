//
//  Completer.swift
//  toolios
//
//  Created by Julien Maire on 13/04/2022.
//  Copyright © 2022 Dazz. All rights reserved.
//

import Foundation

public class Completer<CompletionType>: NSObject {
    
    public typealias Completion = (CompletionType) -> Void
    
    private let completion: Completion
    
    private var child: Completer<CompletionType>?
    
    public init(_ completion: @escaping Completion) {
        self.completion = completion
        super.init()
    }

    public func complete(_ data: CompletionType) {
        completion(data)
        child?.complete(data)
    }
    
    public func chain(_ completer: Completer<CompletionType>) {
        guard completer != self else { return }
        
        if let child = self.child  {
            child.chain(completer)
        } else {
            self.child = completer
        }
    }
}
