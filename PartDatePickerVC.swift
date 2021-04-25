//
//  PartDatePickerVC.swift
//  employee
//
//  Created by Ahmed on 3/17/21.
//

import UIKit

/// protocol to trasfer date in unixtimestamp fromate to parent view controller
protocol PartDatePickerDelegate{
    func getDate(value: Int64?)
}

/// types of the generated list 
enum dateListTypes{
    case years, monthes
}


/// create of custom date lists with out days
class PartDatePickerVC: UIViewController {

    //MARK:- variables
    var delegate: PartDatePickerDelegate?
    var years = [String]()
    var month = [String]()
    
    /// set the selected month from date and initiate it with current month
    var selectedMonth = "\(Calendar.current.component(.month, from: Date()))".getDateString(currentFormate: "M", expectedFormate: "MMMM")
    
    /// set the selected year from date and initiate it with current year
    var selectedYear = "\(Calendar.current.component(.year, from: Date()))"

    //MARK:- outlets
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var containerBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIPickerView!
    
    //MARK:- view
    override func viewDidLoad() {
        super.viewDidLoad()
        UI()
    }
    
    //MARK:- functions
    /// begin animation for list view in two cases
    func begin(){
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [self] (_) in
            UIView.animate(withDuration: 0.3) {
                containerBottomContraint.constant = 0
                view.layoutIfNeeded()
            }
        }
    }
    
    /// end the animation with ecuted scope and its optional
    /// - Parameter scope: the scope that will ecute after the animation ended
    func end(scope: (() -> Void)? = nil){
        UIView.animate(withDuration: 0.3) { [self] in
            self.containerBottomContraint.constant = -180
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [self] (_) in
                DispatchQueue.main.async {
                    self.dismiss(animated: false){
                        scope?()
                    }
                }
            }
            self.view.layoutIfNeeded()
        }
        
    }
    
    func UI(){
        container.setCurveToCorners(topLeft: true, topRight: true)
        setUpUIPickerViewData()
        begin()
        let swipeGeaster = UISwipeGestureRecognizer(target: self, action: #selector(DatePickerVC.backAction(_:)))
        swipeGeaster.direction = .down
        container.addGestureRecognizer(swipeGeaster)
    }
    
    func setUpUIPickerViewData(){
        datePicker.contentMode = .scaleToFill
        years = getList(type: .years)
        month = getList(type: .monthes)
        datePicker.reloadAllComponents()
        datePicker.selectRow(month.count-1, inComponent: 0, animated: false)
        datePicker.selectRow(years.count-1, inComponent: 1, animated: false)
    }
    
    /// generate list of types { years or monthes }
    /// - Parameter type: type of the wnated list
    /// - Returns: return list of names of the types { years or monthes }
    func getList(type: dateListTypes) -> [String]{
        
        /// start of the current year
        let startOfCurrentYear = "1/1/\(Calendar.current.component(.year, from: Date()))"
        
        /// the start of the period that i want claculate the years from to now
        let startDateString:String  = type == .years ? "1/1/2000":startOfCurrentYear

        //formate the date to readable formate with localized language
        let dateFormtter = DateFormatter()
        dateFormtter.dateFormat = "dd/MM/yyyy"
        dateFormtter.locale = NSLocale(localeIdentifier: "en") as Locale
        let endDateString:String = dateFormtter.string(from: Date())
        dateFormtter.locale = NSLocale(localeIdentifier: app_lang) as Locale

        let startDate = startDateString.getDate(currentFormate: "dd/MM/yyyy", from: "en")
        let endDate = endDateString.getDate(currentFormate: "dd/MM/yyyy", from: "en")

        var arrYears = [String]()
        dateFormtter.dateFormat = type == .years ? "yyyy":"MMMM"
        
        //check wich list will be returned
        if type == .years{
            for i in (startDate.Year())...(endDate.Year())  {
                let monthWithYear = "\(i)"
                arrYears.append(monthWithYear)
            }

        }else{
            for i in (startDate.Month())...(endDate.Month()) {
                let month = "\(i)".getDate(currentFormate: "M", from: "en")
                dateFormtter.dateFormat = "MMMM"
                arrYears.append(dateFormtter.string(from: month))
            }
        }

        return arrYears
    }

    
    //MARK:- actions
    @IBAction func backAction(_ sender: UIButton) {
        end()
    }
    
    @IBAction func confirmAction(_ sender: UIButton) {
        
        end {
            let date = "\(self.selectedMonth)-\(self.selectedYear)".getDate(currentFormate: "MMMM-yyyy", from: "en")
            self.delegate?.getDate(value: date.TotimeStamp())
        }
    }
}
