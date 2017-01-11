//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Braden Gray on 10/27/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    var error: Bool {
        return accumulator.isNaN || accumulator.isInfinite ? true : false
    }
    
    var isPartialResult : Bool {
        get {
            return pending != nil
        }
    }
    
    var description : String = ""
    
    lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 6
        return formatter
    }()
    
    func setOperand(operand : Double) {
        if !isPartialResult { description = "" }
        description = description == "" ? description + formatter.string(for: operand)! : description + " \(formatter.string(for: operand)!)"
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    func setOperand(variableName: String) {
        accumulator = variableValues[variableName] ?? 0.0
        description = description + " \(variableName)"
        internalProgram.append(variableName as AnyObject)
    }
    
    var variableValues = [String: Double]()
    
    func clear() {
        pending = nil
        accumulator = 0
        description = ""
        internalProgram.removeAll()
    }
    
    func clearVariables() {
        variableValues.removeAll()
    }
    
    func undo() {
        internalProgram.remove(at: internalProgram.count - 1)
        program = internalProgram as CalculatorBrain.PropertyList
    }
    
    private var operations: Dictionary<String,Operation> = [
            "π" : Operation.Constant(M_PI),
            "e" : Operation.Constant(M_E),
            "√" : Operation.UnaryOperation(sqrt),
            "cos" : Operation.UnaryOperation(cos),
            "sin" : Operation.UnaryOperation(sin),
            "tan" : Operation.UnaryOperation(tan),
            "x2" : Operation.UnaryOperation({$0 * $0}),
            "×" : Operation.BinaryOperation({$0 * $1}),
            "÷" : Operation.BinaryOperation({$0 / $1}),
            "+" : Operation.BinaryOperation({$0 + $1}),
            "-" : Operation.BinaryOperation({$0 - $1}),
            "+/-" : Operation.UnaryOperation({-$0}),
            "%" : Operation.UnaryOperation({$0/100}),
            "=" : Operation.Equals,
            "rand" : Operation.NullOperation({Double(arc4random()) / Double(UINT32_MAX)})
        ]
    
    private enum Operation {
        case Constant(Double)
        case NullOperation(()->Double)
        case UnaryOperation((Double)->Double)
        case BinaryOperation((Double, Double)->Double)
        case Equals
    }
    
    func performOperation(symbol : String) {
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
                description = description == "" ? description + "\(symbol)" : description + " \(symbol)"
            case .NullOperation(let function):
                accumulator = function()
                description = description == "" ? description + "\(symbol)" : description + " \(symbol)"
            case .UnaryOperation(let function):
                if !isPartialResult {
                   description = String(format: "%@(%@)", symbol, description)
                } else {
                    let character = description.characters.last
                    description = description.substring(to: description.index(before: description.endIndex))
                    description = description + "\(symbol)(\(character!))"
                }
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                description = description + " \(symbol)"
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            let character = String(description.characters.last!)
            if Double(character) != nil {
                if pending!.firstOperand == accumulator && Double(character) != accumulator {
                    description = description + " \(formatter.string(for: accumulator)!)"
                }
            }
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double)->Double
        var firstOperand: Double
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalProgram as CalculatorBrain.PropertyList
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                    } else if let operation = op as? String {
                        if let _ = variableValues[operation] {
                            setOperand(variableName: operation)
                        } else {
                            performOperation(symbol: operation)
                        }
                    }
                }
            }
        }
    }
    
    var result : Double {
        return accumulator
    }
}
