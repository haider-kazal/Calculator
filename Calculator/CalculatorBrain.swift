//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Haider Ali Kazal on 10/2/16.
//  Copyright © 2016 Haider Ali Kazal. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private enum Operation {
        case constant(Double)
        case unary((Double) -> Double)
        case binary((Double, Double) -> Double)
        case equals
    }
    
    struct PendingBinaryOperationInfo {
        var binaryOperation: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    private let operations: Dictionary<String, Operation> = [
        "π": Operation.constant(M_PI),
        "e": Operation.constant(M_E),
        "±": Operation.unary({ -$0 }),
        "√": Operation.unary(sqrt),
        "sin": Operation.unary(sin),
        "cos": Operation.unary(cos),
        "tan": Operation.unary(tan),
        "+": Operation.binary({ $0 + $1 }),
        "-": Operation.binary({ $0 - $1 }),
        "×": Operation.binary({ $0 * $1 }),
        "÷": Operation.binary({ $0 / $1 }),
        "=": Operation.equals
    ]
    
    private var pending: PendingBinaryOperationInfo?
    
    private var accumulator = 0.0
    var result: Double {
        get {
            return accumulator
        }
    }
    
    func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unary(let function):
                accumulator = function(accumulator)
            case .binary(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryOperation: function, firstOperand: accumulator)
            case .equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    func resetBrain() {
        accumulator = 0.0
        pending = nil
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryOperation(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
}
