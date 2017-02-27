//
//  SettingsViewController.swift
//  tipCalculator
//
//  Created by Arthur Yu on 2/26/17.
//  Copyright © 2017 Arthur Yu. All rights reserved.
//

import UIKit

let percentages = ["15%", "18%", "20%", "25%"]
let defaults = UserDefaults.standard
let tipKey = "tipPercentage"

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var percentagePickerView: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        percentagePickerView.delegate = self
        percentagePickerView.dataSource = self
        
        self.view.backgroundColor = UIColor(red: 0/255, green: 178/255, blue: 0/255, alpha: 1)
        tipPercentLabel.text = loadUserDefault(key: tipKey)
        percentagePickerView.selectRow(percentages.index(of: loadUserDefault(key: tipKey))!, inComponent: 0, animated: true)
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tipPercentLabel.text = percentages[row]
        setUserDefault(key: tipKey, value: percentages[row])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func setUserDefault(key: String, value:String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    func loadUserDefault(key: String) -> String {
        if let value = defaults.object(forKey: key) {
            return value as! String
        } else {
            return "15%"
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
