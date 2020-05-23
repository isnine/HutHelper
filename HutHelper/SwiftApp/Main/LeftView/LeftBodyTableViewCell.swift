//
//  LeftBodyTableViewCell.swift
//  Dream-Seeker
//
//  Created by 张驰 on 2019/1/30.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class LeftBodyTableViewCell: UITableViewCell {

    @IBOutlet weak var bodyImg: UIImageView!
    @IBOutlet weak var bodyLab: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(icon: String, label: String) {
        self.backgroundColor = .clear
        self.bodyImg.image = UIImage(named: icon)
        self.bodyLab.text = label
    }
}
