//
//  PartDatePickerVC + picker delegate.swift
//  employee
//
//  Created by Ahmed on 3/4/21.
//

import UIKit

extension PartDatePickerVC:  UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return month.count
        }else{
            return years.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return month[row]
        }else{
            return years[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 {
            selectedYear = years[row]
            if row == years.count-1{
                month = getList(type: .monthes)
            }else{
                month = Calendar.current.monthSymbols
            }
            pickerView.reloadComponent(0)
            
        }else{
            selectedMonth = month[row]
        }
    }
}
