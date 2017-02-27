//
//  ViewController.swift
//  tipCalculator
//
//  Created by Arthur Yu on 2/24/17.
//  Copyright © 2017 Arthur Yu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var tipAmount: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Redundant, but practicing adding observer
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: PICKER_SELECTED_NOTIFICATION), object: nil, queue: nil) {
            notification in
            self.tipControl.selectedSegmentIndex = percentages.index(of: self.loadUserDefault(key: tipKey))!
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UISetup()
        updateTipAndTotal()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: AnyObject) {
        updateTipAndTotal()
    }
    
    func loadUserDefault(key: String) -> String {
        if let value = defaults.object(forKey: key) {
            return value as! String
        } else {
            return percentages[0]
        }
    }
    
    func UISetup() {
        self.tipAmount.textColor = UIColor.black
        self.totalAmount.textColor = UIColor.black
        self.tipControl.tintColor = UIColor.black
        UIView.animate(withDuration: 0.8) {
            self.tipAmount.textColor = UIColor.white
            self.totalAmount.textColor = UIColor.white
            self.tipControl.tintColor = UIColor.white
            self.view.backgroundColor = UIColor(red: 0/255, green: 178/255, blue: 0/255, alpha: 1)
        }
        
        self.tipControl.selectedSegmentIndex = 0
        UIView.animate(withDuration: 4) {
            self.tipControl.selectedSegmentIndex = percentages.index(of: self.loadUserDefault(key: tipKey))!
        }
    }
    
    func updateTipAndTotal() {
        let bill = Double(billField.text!) ?? 0
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        tipAmount.text = String(format: "$%.2f", tip)
        totalAmount.text = String(format: "$%.2f", total)
    }
}

