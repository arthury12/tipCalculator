//
//  ViewController.swift
//  tipCalculator
//
//  Created by Arthur Yu on 2/24/17.
//  Copyright © 2017 Arthur Yu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var tipAmount: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    let utility = Utility()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpBillField()
        if let lightTheme = utility.defaults.object(forKey: userLightTheme) as? Bool {
            UISetup(lightTheme: lightTheme)
        } else {
            UISetup(lightTheme: true)
        }
        updateTipAndTotal()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 6
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: AnyObject) {
        updateTipAndTotal()
    }
    
    func loadUserDefault(key: String) -> String {
        if let value = utility.defaults.object(forKey: key) {
            return value as! String
        } else {
            return percentages[0]
        }
    }
    
    func UISetup(lightTheme: Bool) {
        if lightTheme {
            UIView.animate(withDuration: 0.8) {
                self.tipLabel.textColor = UIColor.black
                self.billLabel.textColor = UIColor.black
                self.totalLabel.textColor = UIColor.black
                self.tipAmount.textColor = UIColor.black
                self.totalAmount.textColor = UIColor.black
                self.tipControl.tintColor = UIColor.black
                self.view.backgroundColor = UIColor(red: 0/255, green: 230/255, blue: 0/255, alpha: 1)
            }
            
            self.tipControl.selectedSegmentIndex = 0
            UIView.animate(withDuration: 4) {
                self.tipControl.selectedSegmentIndex = percentages.index(of: self.loadUserDefault(key: tipKey))!
            }
        } else {
            UIView.animate(withDuration: 0.8) {
                self.tipLabel.textColor = UIColor.white
                self.billLabel.textColor = UIColor.white
                self.totalLabel.textColor = UIColor.white
                self.tipAmount.textColor = UIColor.white
                self.totalAmount.textColor = UIColor.white
                self.tipControl.tintColor = UIColor.white
                self.view.backgroundColor = UIColor(red: 0/255, green: 150/255, blue: 60/255, alpha: 1)
            }
            
            self.tipControl.selectedSegmentIndex = 0
            UIView.animate(withDuration: 4) {
                self.tipControl.selectedSegmentIndex = percentages.index(of: self.loadUserDefault(key: tipKey))!
            }
        }
    }
    
    func updateTipAndTotal() {
        let bill = Double(billField.text!) ?? 0
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        utility.setNumberFormatterCurrency()
        tipAmount.text = utility.numberFormatter.string(from: NSNumber(value: tip))!
        totalAmount.text = utility.numberFormatter.string(from: NSNumber(value: total))!
    }
    
    func storeBillAmount() {
        utility.setUserDefault(key: billAmountKey, value: billField.text!)
        utility.setUserDefault(key: backgroundTimeKey, value: NSDate().timeIntervalSince1970)
    }
    
    func restoreBillAmount(appTerminated: Bool) {
        if let timeKeySaved = utility.defaults.object(forKey: backgroundTimeKey) as? TimeInterval {
            let timeDelta = NSDate().timeIntervalSince1970 - timeKeySaved
            debugPrint ("Time since app was backgrounded: \(timeDelta) seconds")
            if timeDelta <= tenMinutes {
                billField.text = utility.defaults.object(forKey: billAmountKey) as! String?
            } else {
                billField.text = ""
            }
        }
    }
    
    func setObservers() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: APP_BACKGROUND_NOTIFICATION), object: nil, queue: nil) {
            notification in
            self.storeBillAmount()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: APP_FOREGROUND_NOTIFICATION), object: nil, queue: nil) {
            notification in
            self.restoreBillAmount(appTerminated: false)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: APP_TERMINATE_NOTIFICATION), object: nil, queue: nil) {
            notification in
            self.storeBillAmount()
        }
    }
    
    func setUpBillField() {
        billField.becomeFirstResponder()
        billField.delegate = self
        restoreBillAmount(appTerminated: true)
    }
}

