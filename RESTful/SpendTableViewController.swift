//
//  SpendTableViewController.swift
//  RESTful
//
//  Created by Jemiway on 2022/9/30.
//

import UIKit

class SpendTableViewController: UITableViewController {

    var spends = [Spend]() {
        
        didSet {
            Spend.saveSpends(spends)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = Spend.loadSpends() {
            self.spends = data
        }
    }

    @IBAction func unwindToSpendTableView(_ unwindSegue: UIStoryboardSegue) {
        
        if let source = unwindSegue.source as? AddTableViewController,
           let spend = source.spend {
            
            if let indexPath = tableView.indexPathForSelectedRow?.row {
                
                spends[indexPath] = spend
                tableView.reloadData()
                
            } else {
                spends.insert(spend, at: 0)
                tableView.reloadData()
            }
        }
    }
    
    @IBAction func countTotalMoney(_ sender: Any) {
        
        var totalMoney = 0
        
        for index in 0..<spends.count {
            
            totalMoney += spends[index].menoy
        }
        let controller = UIAlertController(title: "消費總金額",
                message: "目前你的消費總額為 : \(totalMoney)", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func delAllData(_ sender: Any) {
        
        let controller = UIAlertController(title: "刪除所有資料",
                message: "是否刪除所有資料 ?", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "好的", style: .default)
        {
            _
            in
            self.spends.removeAll()
            self.tableView.reloadData()
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    
    @IBSegueAction func editTable(_ coder: NSCoder) -> AddTableViewController? {
        
        let controller = AddTableViewController(coder: coder)
        
        if let row = tableView.indexPathForSelectedRow?.row {
            
            controller?.spend = spends[row]
        }
        
        return controller
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        spends.remove(at: indexPath.row)
//        tableView.reloadData()
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return spends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(SpendTableViewCell.self)", for: indexPath) as! SpendTableViewCell

        let spend = spends[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/M/d HH:mm"
        cell.dateLabel.text = dateFormatter.string(from: spend.date)
        
        cell.moneyLabel.text = String(spend.menoy)
        cell.typeLabel.text = spend.type
        cell.detailLabel.text = spend.detail
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
