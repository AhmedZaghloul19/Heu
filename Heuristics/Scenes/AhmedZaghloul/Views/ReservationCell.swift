//
//  ReservationCell.swift
//  ClinicSystem
//
//  Created by Sherif Ahmed on 1/28/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {

    @IBOutlet weak var userImageView:UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var holderView:UIView!
    
    var ID:Int?
    var unreaded:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.userImageView.layer.cornerRadius = self.userImageView.frame.height / 2
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
