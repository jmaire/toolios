//
//  SyncPromise.swift
//  toolios
//
//  Created by Julien Maire on 11/04/2022.
//  Copyright © 2022-2025 Julien Maire
//

import Foundation

public typealias SyncPromise<ResolveType> = BasePromise<Array<ResolveType>, Array<Error>>
