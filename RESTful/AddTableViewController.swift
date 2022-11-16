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
        
        // 依spendy資料更新顯示畫面
        updateUI()
        
        addDetailTextView.delegate = self
        addDetailTextView.returnKeyType = UIReturnKeyType.done
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // 輸入框不能為空
        if text == "\n" {
            self.view.endEditing(false)
            return false
        }
        return true
    }
 
    // 按畫面其他位置結束編輯，收起鍵盤
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(false)
    }
    
    
    func updateUI() {
        
        // 初始化滾輪位置
        numberOfRow = typeList.count * aNumber  // 根據typeList數量乘以1000為總範圍值
        var position = numberOfRow / 2          // 取中間的位置值
        pickerview.selectRow(position, inComponent: 0, animated: true)  // 設定滾輪位置
        
        // spend有資料
        if spend != nil {
            
            // 將之前儲存的資料顯示在畫面上
            addMoneyTextField.text = String(spend.menoy)
            addDate.date = spend.date
            addDetailTextView.text = spend.detail
            
            // 計算滾輪位置
            for (index, value) in typeList.enumerated() {
                
                // 找出spend.type的字串在typeList裡的index位置 (index為反向)
                if value == spend.type {
                    
                    // 設定滾輪顯示的字串
                    typeListDidSelect = value
                    
                    // 依index計算滾輪位置
                    position = (typeList.count-index) * aNumber
                }
            }
            // 設定滾輪位置
            pickerview.selectRow(position, inComponent: 0, animated: true)
            
        } else {
            // spend無資料，顯示default值
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

// MARK: - PickerView

extension AddTableViewController:UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        
        // 傳回滾輪的總範圍值
        return numberOfRow
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        // 傳回滾輪位置相對應的字串
        return typeList[row % typeList.count]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
        
        // 計算滾輪位置，若position值太小滾輪上半部會不顯示，故用(總範圍值/2)再加上滾輪值
        let position = (numberOfRow / 2) + (row % typeList.count)
        
        // 設定滾輪位置
        pickerview.selectRow(position, inComponent: 0, animated: false)
        
        // 設定滾輪顯示的字串
        typeListDidSelect = typeList[row % typeList.count]
    }
}
