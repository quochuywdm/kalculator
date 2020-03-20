//
//  ViewController.swift
//  Kalkulator
//
//  Created by Nguyễn Quốc Huy on 19.03.2020.
//  Copyright © 2019 Nguyễn Quốc Huy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // Exemplar variables
    @IBOutlet weak var display: UILabel!
    //Buttons
    @IBOutlet weak var piButton: UIButton!
    @IBOutlet weak var squareRootButton: UIButton!
    @IBOutlet weak var percentButton: UIButton!
    @IBOutlet weak var quadratButton: UIButton!
    @IBOutlet weak var divideButton: UIButton!
    @IBOutlet weak var multiplyButton: UIButton!
    @IBOutlet weak var subtractionButton: UIButton!
    @IBOutlet weak var additionButton: UIButton!
    @IBOutlet weak var dotButton: UIButton!
    @IBOutlet weak var leftKlammButton: UIButton!
    @IBOutlet weak var rightKlammButton: UIButton!
    @IBOutlet weak var backSpaceButton: UIButton!
    
    
    @IBOutlet weak var changeSignButton: UIButton!
    
    @IBOutlet weak var equalButton: UIButton!
    @IBOutlet weak var ClearButton: UIButton!
    
    @IBOutlet weak var expressionLabel: UILabel!
    
    
    var userIsInTheMiddleOfTyping = false
    
    
    // Biến gồm hàm để lấy và set giá trị trên màn hình
    var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set{
            // Double to Int (2.0 to 2)
            if newValue.truncatingRemainder(dividingBy: 1) == 0 {
                let valueInInt:Int = Int(newValue)
                display.text = String(valueInInt)
            }
            else {
                display.text = String(newValue)
            }
        }
    }
    
    // Action nhấn nút số
    @IBAction func touchDigit(_ sender: UIButton) {
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
        default:
            expressionLabel.text! += sender.currentTitle!
        }
    }
    
    // ClearButton clicked
    @IBAction func clearButtonClicked(_ sender: Any) {
        display.text = "0"
        userIsInTheMiddleOfTyping = false
        expressionLabel.text = "No input🐽"
    }
    
    @IBAction func equalButtonClicked(_ sender: Any) {
        var expressionInString = expressionLabel.text
        
        //Replace unknown operations such as ÷ to /
        let symbolReplacement:[String:String] = ["⨉":"*", "÷":"/", "π":String(Double.pi), "√":"sqrt", "%": "/100", "²":"**2"]
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
            
            
        }	catch {
            display.text = "Invalid input 🐷"
        }
    }
    
    override func viewDidLoad() {
        //changeUIColor
        let leichtGreen = UIColor(red: 0.8196, green: 0.9294, blue: 0.651, alpha: 1.0) /* #d1eda6 */
        let veryPink = UIColor(red: 0.9569, green: 0.5294, blue: 0.5098, alpha: 1.0) /* #f48782 */
        let pink = UIColor(red: 0.9569, green: 0.698, blue: 0.6706, alpha: 1.0) /* #f4b2ab */
        let littlePink = UIColor(red: 0.949, green: 0.8431, blue: 0.8353, alpha: 1.0) /* #f2d7d5 */
        
        display.backgroundColor = pink
        
        piButton.backgroundColor = littlePink
        squareRootButton.backgroundColor = littlePink
        percentButton.backgroundColor = littlePink
        quadratButton.backgroundColor = littlePink
        dotButton.backgroundColor = littlePink
        leftKlammButton.backgroundColor = littlePink
        rightKlammButton.backgroundColor = littlePink
        changeSignButton.backgroundColor = littlePink
        
        divideButton.backgroundColor = veryPink
        multiplyButton.backgroundColor = veryPink
        subtractionButton.backgroundColor = veryPink
        additionButton.backgroundColor = veryPink

        equalButton.backgroundColor = leichtGreen
        ClearButton.backgroundColor = leichtGreen
        backSpaceButton.backgroundColor = leichtGreen
        
    }
    
    @IBAction func equalButtonClicked2(_ sender: Any) {
                var expressionInString = expressionLabel.text
    
        //Replace unknown operations such as ÷ to /
        let symbolReplacement:[String:String] = ["⨉":"*", "÷":"/", "π":String(Double.pi), "√":"sqrt", "%": "/100", "²":"**2"]
        for (index, keyValue) in symbolReplacement {
            expressionInString = expressionInString!.replacingOccurrences(of: index, with: keyValue)
        }
        // Calculate arithmetic expression
        let expression = NSExpression(format: expressionInString!)
        if let result = expression.toFloatingPoint().expressionValue(with: nil, context: nil) as? Double {
            expressionInString! += " ="
            // Convert .0 decimal (1.0 to 1)
            if result.truncatingRemainder(dividingBy: 1.0) == 0.0{
                display.text = String(Int(result))
            }
            else{
            display.text = String(result)}
            
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


