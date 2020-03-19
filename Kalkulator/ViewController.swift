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
    private var brain = CalculatorBrain()
    @IBOutlet weak var display: UILabel!
    //Buttons
    @IBOutlet weak var piButton: UIButton!
    @IBOutlet weak var squareRootButton: UIButton!
    @IBOutlet weak var cosButton: UIButton!
    
    @IBOutlet weak var divideButton: UIButton!
    @IBOutlet weak var multiplyButton: UIButton!
    @IBOutlet weak var subtractionButton: UIButton!
    @IBOutlet weak var additionButton: UIButton!
    
    @IBOutlet weak var dotButton: UIButton!
    @IBOutlet weak var changeSignButton: UIButton!
    
    @IBOutlet weak var equalButton: UIButton!
    
    
    var userIsInTheMiddleOfTyping = false
    
    
    // Biến gồm hàm để lấy và set giá trị trên màn hình
    var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    // Action nhấn nút số
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping
        {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        }
        else{
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }

    
    // Action nhấn nút operations
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping{
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle{    // if currentTitlel != nil
            brain.performOperation(mathematicalSymbol)
        }
        
        if let result = brain.result{                       // if result != nil
            displayValue = result
        }
    }
    
    // DotButton clicked
    @IBAction func DotButtonClicked(_ sender: UIButton) {
        if let text = display.text{
            if !text.contains("."){
                display.text = text + "."
            }
        }
    }
    
    override func viewDidLoad() {
        //changeUIColor
        let starkPinkColor = UIColor(red: 0.9569, green: 0.5294, blue: 0.5098, alpha: 1.0) /* #f48782 */
        let leichtPinkColor = UIColor(red: 0.9647, green: 0.6745, blue: 0.6392, alpha: 1.0) /* #f6aca3 */
        
        display.backgroundColor = starkPinkColor
        
        display.backgroundColor = starkPinkColor
        
        piButton.backgroundColor = leichtPinkColor
        squareRootButton.backgroundColor = leichtPinkColor
        cosButton.backgroundColor = leichtPinkColor
         
        divideButton.backgroundColor = leichtPinkColor
        multiplyButton.backgroundColor = leichtPinkColor
        subtractionButton.backgroundColor = leichtPinkColor
        additionButton.backgroundColor = leichtPinkColor
        
        dotButton.backgroundColor = leichtPinkColor
        changeSignButton.backgroundColor = leichtPinkColor
        
        equalButton.backgroundColor = starkPinkColor
        
    }
    


    
}


