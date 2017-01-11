//
//  ViewController.swift
//  Calculator
//
//  Created by Braden Gray on 10/26/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    @IBAction func backSpaceTouched(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            if (display.text?.characters.count)! > 1 {
                display.text = display.text?.substring(to: (display.text?.index(before: (display.text?.endIndex)!))!)
            } else {
                displayValue = 0
                userIsInTheMiddleOfTyping = false
            }
        } else {
            brain.undo()
            displayResult()
            displayDescription()
        }
    }
    
    @IBAction func clearButtonTouched(_ sender: UIButton) {
        brain.clear()
        displayResult()
        descriptionLabel.text = brain.description
        brain.clearVariables()
        userIsInTheMiddleOfTyping = false
    }
    
    @IBAction private func digitTouched(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if digit == "." && textCurrentlyInDisplay .contains(digit) { return }
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    var lastVariable: String?
    
    @IBAction func variableTouched(_ sender: UIButton) {
        let variable = sender.currentTitle!
        brain.setOperand(variableName: variable)
        lastVariable = variable
    }
    
    @IBAction func setVariableTouched(_ sender: UIButton) {
        if let variable = lastVariable {
            save()
            brain.variableValues[variable] = displayValue
            restore()
            userIsInTheMiddleOfTyping = false
        }
    }
    
    private var displayValue : Double? {
        get {
            if let double = Double(display.text!) {
                return double;
            }
            return nil
        }
        set {
            if newValue != nil {
                display.text = brain.formatter.string(for: newValue)
            } else {
                display.text = ""
            }
        }
    }
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayResult()
        }
    }
    
    private var brain = CalculatorBrain()
    
    private func displayDescription() {
        descriptionLabel.text = brain.description + (brain.isPartialResult ? " ..." : " =")
    }
    
    private func displayResult() {
        if brain.error {
            display.text = "Error"
        } else {
            displayValue = brain.result
        }
    }

    @IBAction private func operationTouched(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue!)
            userIsInTheMiddleOfTyping = false
        }
        if let mathmaticalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathmaticalSymbol)
        }
        displayResult()
        displayDescription()
    }
}

