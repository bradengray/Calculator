//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Braden Gray on 10/26/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

import XCTest
@testable import Calculator

class CalculatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDescriptionLabel () {
        let brain = CalculatorBrain ()
        var display : String {
            get {
               return brain.description + (brain.isPartialResult ? " ..." : " =")
            }
        }
        
        var result : Double {
            get {
                return brain.result
            }
        }
        
        //A
        brain.setOperand(operand: 7)
        brain.performOperation(symbol: "+")
        XCTAssertEqual(display, "7 + ...")
        XCTAssertEqual(result, 7)
        
        //B
        brain.setOperand(operand: 9)
        XCTAssertEqual(result, 9)
        
        //C
        brain.performOperation(symbol: "=")
        XCTAssertEqual(result, 16)
        
        //D
        XCTAssertEqual(display, "7 + 9 =")
        brain.performOperation(symbol: "√")
        XCTAssertEqual(display, "√(7 + 9) =")
        XCTAssertEqual(result, 4)
        
        //E
        brain.setOperand(operand: 7)
        brain.performOperation(symbol: "+")
        brain.setOperand(operand: 9)
        brain.performOperation(symbol: "√")
        XCTAssertEqual(display, "7 + √(9) ...")
        XCTAssertEqual(result, 3)
        
        //F
        brain.performOperation(symbol: "=")
        XCTAssertEqual(display, "7 + √(9) =")
        XCTAssertEqual(result, 10)
        
        //G
        brain.setOperand(operand: 7)
        brain.performOperation(symbol: "+")
        brain.setOperand(operand: 9)
        brain.performOperation(symbol: "=")
        brain.performOperation(symbol: "+")
        brain.setOperand(operand: 6)
        brain.performOperation(symbol: "+")
        brain.setOperand(operand: 3)
        brain.performOperation(symbol: "=")
        XCTAssertEqual(display, "7 + 9 + 6 + 3 =")
        XCTAssertEqual(result, 25)
        
        //H
        brain.setOperand(operand: 7)
        brain.performOperation(symbol: "+")
        brain.setOperand(operand: 9)
        brain.performOperation(symbol: "=")
        brain.performOperation(symbol: "√")
        brain.setOperand(operand: 6)
        brain.performOperation(symbol: "+")
        brain.setOperand(operand: 3)
        brain.performOperation(symbol: "=")
        XCTAssertEqual(display, "6 + 3 =")
        XCTAssertEqual(result, 9)
        
        //I
        //not testing
        
        //J
        brain.setOperand(operand: 7)
        brain.performOperation(symbol: "+")
        brain.performOperation(symbol: "=")
        XCTAssertEqual(display, "7 + 7 =")
        XCTAssertEqual(result, 14)
        
        //K
        brain.setOperand(operand: 4)
        brain.performOperation(symbol: "×")
        brain.performOperation(symbol: "π")
        brain.performOperation(symbol: "=")
        XCTAssertEqual(display, "4 × π =")
        XCTAssertEqual(result, 12.5663706143592)
        
        //L
        brain.setOperand(operand: 4)
        brain.performOperation(symbol: "+")
        brain.setOperand(operand: 5)
        brain.performOperation(symbol: "×")
        brain.setOperand(operand: 3)
        brain.performOperation(symbol: "=")
        XCTAssertEqual(display, "4 + 5 × 3 =")
        XCTAssertEqual(result, 27)
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
