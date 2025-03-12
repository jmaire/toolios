//
//  LoaderCompleter.swift
//  toolios
//
//  Created by Julien Maire on 13/04/2022.
//  Copyright © 2022-2025 Julien Maire
//

import Foundation

public class LoaderCompleter<DataType>: Completer<(Bool, Error?, DataType?)> {
    
    public typealias CompletionType = (Bool, Error?, DataType?) -> Void

    public init(completion: @escaping CompletionType) {
        super.init{ result in
            let (isLoading, error, data) = result
            completion(isLoading, error, data)
        }
    }
    
    convenience public init(promise: Promise<DataType>) {
        self.init { isLoading, error, data in
            guard !isLoading else { return }
            if let error = error {
                promise.reject(error)
            } else if let data = data {
                promise.resolve(data)
            } else {
                promise.reject(NSError.unknownPromiseResultError)
            }
        }
    }
    
}
