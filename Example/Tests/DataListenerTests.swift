//
//  DataListenerTests.swift
//  toolios
//
//  Created by Julien Maire on 11/04/2022.
//  Copyright © 2022 Dazz. All rights reserved.
//

import toolios
import XCTest

class DataListenerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let listener = DataListenerExample()
        listener.listen()
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
