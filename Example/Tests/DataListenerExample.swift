//
//  DataListenerExample.swift
//  toolios
//
//  Created by Julien Maire on 11/04/2022.
//  Copyright © 2022 Dazz. All rights reserved.
//

import Foundation
import toolios

class DataListenerExample: DataListener<String> {
    
    override func listenAction() -> DataListener<String>.ListenerDetacherType {
        DispatchQueue.main.async {
            self.success("Success result")
        }
        
        return { }
    }
    
}
