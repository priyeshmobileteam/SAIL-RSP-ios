//
//  TrackDownloadTableViewCell.swift
//  SAIL Bokaro
//
//  Created by HICDAC on 22/02/24.
//

import Foundation
import UIKit
class TrackDownloadTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTestNAme: UILabel!
    
    @IBOutlet weak var lblReqNumber: UILabel!
    
    @IBOutlet weak var lblReportDate: UILabel!
    
    
    @IBOutlet weak var rowCellSTK: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
       // setupBorder()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setupBorder() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 8.0
    }
    
}
