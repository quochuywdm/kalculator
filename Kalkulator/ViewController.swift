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
    @IBOutlet weak var decimalButton: RoundButton!
    var userIsInTheMiddleOfTyping = false
    @IBOutlet var hauptView: UIView!
    

    
    override func viewWillAppear(_ animated: Bool){
        decimalButton.setTitle(String(Locale.current.decimalSeparator!), for: [])
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background9.jpg")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        hauptView.insertSubview(backgroundImage, at: 0)
    }
    
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
        case "π":
            if let lastChar: Character = expressionLabel.text?.last{
                if (lastChar.isNumber || lastChar == ")" || lastChar == "²" || lastChar == "%") {
                    expressionLabel.text! += "⨉"
                }
            }
            expressionLabel.text! += sender.currentTitle!
            
        case "(":
            if let lastChar: Character = expressionLabel.text?.last{
                if (lastChar.isNumber || lastChar == ")" || lastChar == "²" || lastChar == "%") {
                    expressionLabel.text! += "⨉"
                }
            }
            expressionLabel.text! += sender.currentTitle!
            
        case ")":
            let expressionInArray = Array(expressionLabel.text!)
            var countOpenBrackets = 0
            var countClosedBrackets = 0
            
            for character in expressionInArray{
                if (character == "("){
                    countOpenBrackets += 1
                }
                if(character == ")"){
                    countClosedBrackets += 1
                }
                print(countOpenBrackets)
                print(countClosedBrackets)
            }
            if (countOpenBrackets == countClosedBrackets){
                expressionLabel.text = "(" + expressionLabel.text! + ")"
            }
            else{
                expressionLabel.text! += sender.currentTitle!
            }
            
        case ".", ",":
            expressionLabel.text! += sender.currentTitle!
            
        default:
            expressionLabel.text! += sender.currentTitle!
            
            expressionLabel.text = formattedSuffixNumberInString(expressionInString: expressionLabel.text!)
        }
        calculate(printIfUnvalid: false)
        beep()
    }
    
    // ClearButton clicked
    @IBAction func clearButtonClicked(_ sender: Any) {
        display.text = "0"
        userIsInTheMiddleOfTyping = false
        expressionLabel.text = " "
        beep()
    }
    
    // EqualButton clicked
    @IBAction func equalButtonClicked(_ sender: Any) {
        calculate(printIfUnvalid: true)
        beep()
    }
    
    // Keyboard sound
    func beep(){
        AudioServicesPlayAlertSound(SystemSoundID(1104))
    }
    
    // Calculate the arithmetic expression
    func calculate(printIfUnvalid : Bool){
        var expressionInString = convertDecimalSymbol(expressionInString: expressionLabel.text)
        
        //Replace unknown operations such as ÷ to /
        var symbolReplacement:[String:String] = ["⨉":"*", "÷":"/", "π":String(Double.pi), "√":"sqrt", "%": "/100", "²":"**2", "±":"-"]
        for (index, keyValue) in symbolReplacement {
            expressionInString = expressionInString!.replacingOccurrences(of: index, with: keyValue)
        }
        
        // Calculate
        do{
            try ObjC.catchException {
                let expression = NSExpression(format: expressionInString!)
                
                let result = expression.toFloatingPoint().expressionValue(with: nil, context: nil) as? Double
                
                expressionInString! += " ="
                // Convert .0 decimal (1.0 to 1)
                if result!.truncatingRemainder(dividingBy: 1.0) == 0.0{
                    var text = String(result!)
                    text = String(text.dropLast(2))
                }
                // 50000 to 50,000
                let formattedNumber = self.formattedNumberInString(number: result!)
                self.display.text = formattedNumber
                
            }
        }    catch {
            if printIfUnvalid {
                AudioServicesPlayAlertSound(SystemSoundID(1105))
                display.text = "Invalid input 🐷"
            }
        }
    }
    
    // Convert the whole Expression in proper form of decimal based on chosen language of device
    func convertDecimalSymbol(expressionInString : String?) -> String?{
        var resultExpression = expressionInString
        let decimalSeparator = Locale.current.decimalSeparator!
        if (decimalSeparator == ",") {
            resultExpression = resultExpression!.replacingOccurrences(of: ".", with: "")
            resultExpression = resultExpression!.replacingOccurrences(of: ",", with: ".")
        }
        else {
            resultExpression = expressionInString!.replacingOccurrences(of: ",", with: "")
        }
        return resultExpression
    }
    
    // 50000 to 50,000
    func formattedNumberInString(number : Double) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 10
        let formattedNumber = formatter.string(from: NSNumber(value: number))
        
        return String(formattedNumber!)
    }
    
    //Get suffix number from Expression and format the suffix number
    func formattedSuffixNumberInString(expressionInString : String) -> String{
        let groupingSeparatorSymbol = Locale.current.groupingSeparator!
        var str = expressionInString
        let strArray = Array(expressionInString)
        var length = expressionInString.count - 1
        let numberAndDot: [Character] = ["0","1","2","3","4","5","6","7","8","9",".",Character(groupingSeparatorSymbol)]
        var suffixNumber = ""
        
        while ( length >=  0 && numberAndDot.contains(strArray[length]))
        {
            suffixNumber = String(strArray[length]) + suffixNumber
            length -= 1
            str = String(str.dropLast())
        }
        var suffixNumberInForm = ""
        if (suffixNumber != "") {
            suffixNumber = suffixNumber.replacingOccurrences(of: groupingSeparatorSymbol, with: "")
            let suffixNumberInDouble = Double(suffixNumber)!
            suffixNumberInForm = formattedNumberInString(number: suffixNumberInDouble)
        }
        
        return str + suffixNumberInForm
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


