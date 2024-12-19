//
//  ReportDetailChartTableViewCell.swift
//  SAIL Bokaro
//
//  Created by HICDAC on 26/02/24.
import Foundation
import UIKit
class ReportDetailChartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTestNAme: UILabel!
    
    @IBOutlet weak var lblReqNumber: UILabel!
    
    @IBOutlet weak var lblReportDate: UILabel!
    
    
    @IBOutlet weak var tvOutOfRange: UILabel!
    @IBOutlet weak var isHighOrLow: UIImageView!
    @IBOutlet weak var rowCellSTK: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}
