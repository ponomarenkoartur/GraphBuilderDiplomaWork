//
//  SerialPositionTests.swift
//  GraphBuilderDiplomaWorkTests
//
//  Created by Artur on 22.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import XCTest


class SerialPositionTests: XCTestCase {
    
    func testSerialPositionCreation() {
        let array0 = Array(repeating: 0, count: 10)
        
        let position0 = SerialPosition.get(forIndex: 0, in: array0)
        let position1 = SerialPosition.get(forIndex: 9, in: array0)
        let position2 = SerialPosition.get(forIndex: 3, in: array0)
        let position3 = SerialPosition.get(forIndex: -2, in: array0)
        let position4 = SerialPosition.get(forIndex: 10, in: array0)
        
        let array1: [Int] = []
        
        let position5 = SerialPosition.get(forIndex: 0, in: array1)
        
        XCTAssertEqual(position0, .first)
        XCTAssertEqual(position1, .last)
        XCTAssertEqual(position2, .middle)
        XCTAssertEqual(position3, nil)
        XCTAssertEqual(position4, nil)
        XCTAssertEqual(position5, nil)
    }
}
