//
//  SettingsViewController.swift
//  tipCalculator
//
//  Created by Arthur Yu on 2/26/17.
//  Copyright © 2017 Arthur Yu. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var tipPercentagelabel: UILabel!
    @IBOutlet weak var percentagePickerView: UIPickerView!
    @IBOutlet weak var lightThemeLabel: UILabel!
    @IBOutlet weak var themeLabel: UISwitch!
    let utility = Utility()
    
    @IBAction func themeSwitch(_ sender: UISwitch) {
        utility.setUserDefault(key: userLightTheme, value: sender.isOn)
        if sender.isOn {
            UISetup(lightTheme: true)
        } else {
            UISetup(lightTheme: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        percentagePickerView.delegate = self
        percentagePickerView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let lightTheme = utility.defaults.object(forKey: userLightTheme) as? Bool {
            UISetup(lightTheme: lightTheme)
        } else {
            UISetup(lightTheme: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return percentages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return percentages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: percentages[row], attributes: [NSForegroundColorAttributeName:UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tipPercentLabel.text = percentages[row]
        utility.setUserDefault(key: tipKey, value: percentages[row])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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
            self.themeLabel.setOn(true, animated: false)
            UIView.animate(withDuration: 1) {
                self.view.backgroundColor = UIColor(red: 0/255, green: 230/255, blue: 0/255, alpha: 1)
                self.tipPercentLabel.text = self.loadUserDefault(key: tipKey)
                self.tipPercentLabel.textColor = UIColor.black
                self.tipPercentagelabel.textColor = UIColor.black
                self.lightThemeLabel.textColor = UIColor.black
                
                self.percentagePickerView.selectRow(percentages.index(of: self.loadUserDefault(key: tipKey))!, inComponent: 0, animated: true)
            }
        } else {
            self.themeLabel.setOn(false, animated: false)
            UIView.animate(withDuration: 1) {
                self.view.backgroundColor = UIColor(red: 0/255, green: 150/255, blue: 60/255, alpha: 1)
                self.tipPercentLabel.text = self.loadUserDefault(key: tipKey)
                self.tipPercentLabel.textColor = UIColor.white
                self.tipPercentagelabel.textColor = UIColor.white
                self.lightThemeLabel.textColor = UIColor.white
                
                self.percentagePickerView.selectRow(percentages.index(of: self.loadUserDefault(key: tipKey))!, inComponent: 0, animated: true)
            }
        }
    }
}
