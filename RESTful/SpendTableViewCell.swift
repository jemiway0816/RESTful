//
//  SpendTableViewCell.swift
//  RESTful
//
//  Created by Jemiway on 2022/9/30.
//

import UIKit

class SpendTableViewCell: UITableViewCell {

    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var moneyLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
