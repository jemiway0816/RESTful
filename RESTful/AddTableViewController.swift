//
//  AddTableViewController.swift
//  RESTful
//
//  Created by Jemiway on 2022/9/30.
//

import UIKit

class AddTableViewController: UITableViewController, UITextViewDelegate {
    
    @IBOutlet var addDate: UIDatePicker!
    @IBOutlet var addMoneyTextField: UITextField!
    @IBOutlet var addDetailTextView: UITextView!
    @IBOutlet weak var pickerview: UIPickerView!
    
    var spend:Spend!

    let typeList = ["吃飯", "買衣服", "住宿", "交通費", "學習", "娛樂" , "其他"]
    let aNumber = 1000
    var numberOfRow = 0
    var typeListDidSelect = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerview.layer.borderWidth = 0.2
        pickerview.layer.borderColor = UIColor(red: 87/255, green: 115/255, blue: 153/255, alpha: 1).cgColor
        
        addDetailTextView.layer.borderWidth = 0.2
        addDetailTextView.layer.borderColor = UIColor(red: 87/255, green: 115/255, blue: 153/255, alpha: 1).cgColor
        
        updateUI()
        
        addDetailTextView.delegate = self
        addDetailTextView.returnKeyType = UIReturnKeyType.done
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            self.view.endEditing(false)
            return false
        }
        return true
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(false)
    }
    
    func updateUI() {
        
        numberOfRow = typeList.count * aNumber
        var position = numberOfRow / 2
        pickerview.selectRow(position, inComponent: 0, animated: true)
        
        if spend != nil {
            
            // 將之前儲存的資料顯示在畫面上
            addMoneyTextField.text = String(spend.menoy)
            addDate.date = spend.date
            addDetailTextView.text = spend.detail
            
            // 計算滾輪位置
            for (index, value) in typeList.enumerated() {
                
                if value == spend.type {
                    typeListDidSelect = value
                    position = (typeList.count-index) * aNumber
                }
            }
            pickerview.selectRow(position, inComponent: 0, animated: true)
            
        } else {
            typeListDidSelect = "吃飯"
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        // 消費金額沒輸入不能按確定
        if addMoneyTextField.text?.isEmpty == false {
            return true
        }else {
            return false
        }
    }
    
    // MARK: - Table view data source
    
    @IBAction func typeEndExit(_ sender: Any) {
    }
  
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // 準備回上一頁的資料
        let backMoney = Int(addMoneyTextField.text!) ?? 0
        let backDetail = addDetailTextView.text!
        let backType = typeListDidSelect
        spend = Spend(date: addDate.date, menoy: backMoney,
                      detail: backDetail, type: backType)
    }
}

// 滾輪設定
extension AddTableViewController:UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return numberOfRow
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return typeList[row % typeList.count]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
        
        let position = (numberOfRow / 2) + (row % typeList.count)
        pickerview.selectRow(position, inComponent: 0, animated: false)
        typeListDidSelect = typeList[row % typeList.count]
    }
}
