//
//  ViewController.swift
//  Kalkulator
//
//  Created by Nguyễn Quốc Huy on 19.03.2020.
//  Copyright © 2019 Nguyễn Quốc Huy. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var expressionLabel: UILabel!
    var userIsInTheMiddleOfTyping = false
    
    // Buttons clicked
    @IBAction func buttonTouched(_ sender: UIButton) {
        if !userIsInTheMiddleOfTyping{
            expressionLabel.text = ""
            userIsInTheMiddleOfTyping = true
        }
        switch sender.currentTitle! {
        case "√":
            expressionLabel.text! += "√("
        case "x²":
            expressionLabel.text! += "²"
        case "⇤":
            if expressionLabel.text!.count > 0 {
                expressionLabel.text = String(expressionLabel.text!.dropLast(1))
            }
        case "+","-","⨉", "÷":
            let operations = ["+","-","⨉", "÷"]
            for operation in operations{
                if (expressionLabel.text?.contains(operation))! {
                                calculate()
                }
            }

            expressionLabel.text! += sender.currentTitle!
        default:
            expressionLabel.text! += sender.currentTitle!
        }
        beep()
    }
    
    // ClearButton clicked
    @IBAction func clearButtonClicked(_ sender: Any) {
        display.text = "0"
        userIsInTheMiddleOfTyping = false
        expressionLabel.text = "No input🐽"
        beep()
    }
    
    // EqualButton clicked
    @IBAction func equalButtonClicked(_ sender: Any) {
        calculate()
        beep()
    }
    
    // Keyboard sound
    func beep(){
        AudioServicesPlayAlertSound(SystemSoundID(1104))
    }
    
    
    func calculate(){
        var expressionInString = expressionLabel.text
        
        //Replace unknown operations such as ÷ to /
        let symbolReplacement:[String:String] = ["⨉":"*", "÷":"/", "π":String(Double.pi), "√":"sqrt", "%": "/100", "²":"**2", "±":"-"]
        for (index, keyValue) in symbolReplacement {
            expressionInString = expressionInString!.replacingOccurrences(of: index, with: keyValue)
        }
        // Calculate arithmetic expression
        do{
            try ObjC.catchException {
                let expression = NSExpression(format: expressionInString!)
                
                let result = expression.toFloatingPoint().expressionValue(with: nil, context: nil) as? Double
                
                expressionInString! += " ="
                // Convert .0 decimal (1.0 to 1)
                if result!.truncatingRemainder(dividingBy: 1.0) == 0.0{
                    self.display.text = String(Int(result!))
                }
                else{
                    self.display.text = String(result!)}
                
            }
        }    catch {
            display.text = "Invalid input 🐷"
        }
    }

    
    
}

// Make NSExpression return a Double by replace all Int with Double
extension NSExpression {
    func toFloatingPoint() -> NSExpression {
        switch expressionType {
        case .constantValue:
            if let value = constantValue as? NSNumber {
                return NSExpression(forConstantValue: NSNumber(value: value.doubleValue))
            }
        case .function:
           let newArgs = arguments.map { $0.map { $0.toFloatingPoint() } }
           return NSExpression(forFunction: operand, selectorName: function, arguments: newArgs)
        case .conditional:
           return NSExpression(forConditional: predicate, trueExpression: self.true.toFloatingPoint(), falseExpression: self.false.toFloatingPoint())
        case .unionSet:
            return NSExpression(forUnionSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .intersectSet:
            return NSExpression(forIntersectSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .minusSet:
            return NSExpression(forMinusSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .subquery:
            if let subQuery = collection as? NSExpression {
                return NSExpression(forSubquery: subQuery.toFloatingPoint(), usingIteratorVariable: variable, predicate: predicate)
            }
        case .aggregate:
            if let subExpressions = collection as? [NSExpression] {
                return NSExpression(forAggregate: subExpressions.map { $0.toFloatingPoint() })
            }
        case .anyKey:
            fatalError("anyKey not yet implemented")
        case .block:
            fatalError("block not yet implemented")
        case .evaluatedObject, .variable, .keyPath:
            break // Nothing to do here
        @unknown default:
            break
        }
        return self
    }
}


