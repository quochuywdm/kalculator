//
//  CalculatorBrain.swift
//  Kalkulator
//
//  Created by Nguyễn Quốc Huy on 19.03.2020.
//  Copyright © 2019 Nguyễn Quốc Huy. All rights reserved.
//

import Foundation

// STRUCT CHÍNH
struct CalculatorBrain{
    private var accumulator: Double?                        // Lưu trữ số hiện thị tạm thời
    private var resultIsPending = false
    var description:String = ""
    private enum Operation{
        case constant(Double)                               //Double này sẽ liên kết với Dict (như trong Prolog)
        case unaryOperation((Double) -> Double)             // Function take a Double, return a double
        case binaryOperation((Double, Double) -> Double)    // Function take 2 Double, return a double
        case equals
    }
    // Dictionary map String của Operation với một Function
    private var operationsDict: Dictionary<String, Operation> = [
        //constant
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        //unary
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "sin" : Operation.unaryOperation(sin),
        "±" : Operation.unaryOperation({ -$0 }),
        "%" : Operation.unaryOperation({$0/100}),
        "x²" : Operation.unaryOperation({$0*$0}),
        //binary
        "+" : Operation.binaryOperation({ $0 + $1 }),       // Trong ngoặc là function nhận 2 Param $0 $1 và return trong ngoặc
        "-" : Operation.binaryOperation({ $0 - $1 }),
        "⨉" : Operation.binaryOperation({ $0 * $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        //đưa kết quả
        "=" : Operation.equals
    ]
    
    // Được Controller gọi khi nhấn nút -> gọi hàm performOperation ở Controller -> gọi hàm này qua biến Brain
    mutating func performOperation(_ symbol:String){
        if let constant = operationsDict[symbol] {          // operationsDict[symbol] sẽ đưa ra giá trị được map (là doible)
            switch constant {
            case .constant(let value):                  // khai báo value với giá trị có typ constant map với symbol
                accumulator = value
                description = symbol
            case .unaryOperation(let function):             // tên function được lưu và 1 biến, và dùng biến đó để gọi function luôn
                if accumulator != nil{
                    description = symbol + "(" + String(accumulator!) + ")"
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil{
                    resultIsPending = true;
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!) // đưa vào trạng thái chờ Operand2, gửi thông tin phép tính và Operand1 để lưu
                    accumulator = nil
                    description += symbol
                }
                
            case .equals:
                performPendingBinaryOperation()
                resultIsPending = false;
            }
        }
        /* switch symbol {
         case "π":
         accumulator = Double.pi
         case "√":
         if let operand = accumulator{
         accumulator = sqrt(operand)
         
         }
         default:
         break
         }
         */
    }
    
    // Set toán hạng (1 con số trong máy tính. Vd nhập 12 + 33 thì toán hạng là 12 và 33)
    mutating func setOperand(_ operand: Double){
        accumulator = operand
    }
    
    // Khai báo biến read only bằng cách ko có hàm set
    var result: Double?{
        get{
            return accumulator
        }
    }
    
    // Thực hiện khi nhấn nút "="
    private mutating func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil{
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)       //gọi hàm perform trong biến pendingBinaryOperation
            pendingBinaryOperation = nil
        }
    }
    
    
    private var pendingBinaryOperation: PendingBinaryOperation? // Một biến để lưu pendingBinaryOperation
    
    private struct PendingBinaryOperation{
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double{
            // with là tên để nhập vào khi gọi hàm vd: perform(with 5.0)
            return function(firstOperand, secondOperand)
        }
    }

}

