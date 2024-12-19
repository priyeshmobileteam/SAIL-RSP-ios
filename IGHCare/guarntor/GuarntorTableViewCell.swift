//
//  GuarntorTableViewCell.swift
//  SAIL Bokaro
//
//  Created by HICDAC on 21/11/23.
//

import UIKit
class GuarntorTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var crLbl: UILabel!
    @IBOutlet weak var guarantorStatusLbl: UILabel!
    
    @IBOutlet weak var admNoLbl: UILabel!
    @IBOutlet weak var billAmtLbl: UILabel!
    
override func awakeFromNib() {
    super.awakeFromNib()
}

override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
}

}

