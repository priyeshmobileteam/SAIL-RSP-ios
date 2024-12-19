//
//  ValueTableViewCell.swift
//  SAIL Bokaro
//
//  Created by HICDAC on 28/02/24.
//

import UIKit

class ValueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stack1: UIStackView!
    @IBOutlet weak var stack2: UIStackView!
    @IBOutlet weak var testDateLbl: UILabel!
    
    @IBOutlet weak var resultLbl: UILabel!
    
    @IBOutlet weak var bioRefRangeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
