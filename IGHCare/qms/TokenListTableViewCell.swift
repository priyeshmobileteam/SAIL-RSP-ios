//
//  TokenListTableViewCell.swift
//  IGHCare
//
//  Created by HICDAC on 01/10/24.
//

import UIKit

class TokenListTableViewCell: UITableViewCell {

    @IBOutlet weak var que_no_lbl: UILabel!
    @IBOutlet weak var que_no_title: UILabel!
    
    @IBOutlet weak var name_lbl: UILabel!
        
    @IBOutlet weak var hosp_name_lbl: UILabel!
    @IBOutlet weak var status_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
