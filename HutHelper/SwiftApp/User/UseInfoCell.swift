//
//  UseInfoCell.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/12.
//  Copyright © 2020 张驰. All rights reserved.
//

import UIKit

class UseInfoCell: UITableViewCell {

    @IBOutlet weak var headLab: UILabel!
    @IBOutlet weak var infoLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(headlab:String,infolab:String) {
        headLab.text = headlab
        infoLab.text = infolab
    }
    
}
