//
//  SpendTableViewController.swift
//  RESTful
//
//  Created by Jemiway on 2022/9/30.
//

import UIKit

class SpendTableViewController: UITableViewController {

    var spends = [Spend]()  {
        
        didSet {
            // 儲存資料
            Spend.saveSpends(spends)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 畫面一開始讀入資料
        if let data = Spend.loadSpends() {
            self.spends = data
        }
    }

    // 從 Add 畫面返回後執行
    @IBAction func unwindToSpendTableView(_ unwindSegue: UIStoryboardSegue) {
        
        // 取得由 Add 畫面傳回的 spend
        if let source = unwindSegue.source as? AddTableViewController,
           let spend = source.spend {
            
            if let indexPath = tableView.indexPathForSelectedRow?.row {
                
                // 先前是由點選儲存格的方式進下一頁
                spends[indexPath] = spend
                tableView.reloadData()
                
            } else {
                
                // 先前是由新增按鈕的方式進下一頁
                spends.insert(spend, at: 0)
                tableView.reloadData()
            }
        }
    }
    
    // 計算總消費
    @IBAction func countTotalMoney(_ sender: Any) {
        
        var totalMoney = 0
        for index in 0..<spends.count {
            
            totalMoney += spends[index].menoy
        }
        
        // 產生訊息框
        let controller = UIAlertController(title: "消費總金額",
                message: "目前你的消費總額為 : \(totalMoney)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    // 刪除所有資料
    @IBAction func delAllData(_ sender: Any) {
        
        // 產生確認框
        let controller = UIAlertController(title: "刪除所有資料",
                message: "是否刪除所有資料 ?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default) {
            _
            in
            // 刪除所有紀錄
            self.spends.removeAll()
            self.tableView.reloadData()
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    // 跳到下一頁
    @IBSegueAction func editTable(_ coder: NSCoder) -> AddTableViewController? {
        
        let controller = AddTableViewController(coder: coder)
        
        if let row = tableView.indexPathForSelectedRow?.row {
            controller?.spend = spends[row]
        }
        return controller
    }
    
    // 刪除紀錄
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        spends.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(SpendTableViewCell.self)", for: indexPath) as! SpendTableViewCell
        let spend = spends[indexPath.row]
        
        // 設定日期格式
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/M/d HH:mm"
        cell.dateLabel.text = dateFormatter.string(from: spend.date)
        
        cell.moneyLabel.text = String(spend.menoy)
        cell.typeLabel.text = spend.type
        cell.detailLabel.text = spend.detail
        return cell
    }
}
