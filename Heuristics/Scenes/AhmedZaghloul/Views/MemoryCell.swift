//
//  MemoryCell.swift
//  Heuristics
//
//  Created by Ahmed Zaghloul on 2/11/18.
//  Copyright © 2018 Heuristic Gang. All rights reserved.
//

import UIKit

class MemoryCell: UITableViewCell {

    @IBOutlet weak var locationLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var memoryDescriptionLabel:UILabel!
    
    @IBOutlet weak var memoryImageView:UIImageView!
    @IBOutlet weak var holderView:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
