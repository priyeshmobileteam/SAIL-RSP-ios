//
//  NadfTableViewCell.swift
//  SAIL Bokaro
//
//  Created by HICDAC on 22/11/23.
//

import UIKit

class NadfTableViewCell: UITableViewCell {

    @IBOutlet weak var itemLbl: UILabel!
    @IBOutlet weak var seqDateLbl: UILabel!
    @IBOutlet weak var qtyLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
