//
//  SyncPromise.swift
//  toolios
//
//  Created by Julien Maire on 11/04/2022.
//  Copyright © 2022 Dazz. All rights reserved.
//

import Foundation

public typealias SyncPromise<ResolveType> = BasePromise<Array<ResolveType>, Array<Error>>
