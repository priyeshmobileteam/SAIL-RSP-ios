//
//  CenteredLabelCollectionViewCell.swift
//  SAIL Bokaro
//
//  Created by HICDAC on 27/02/24.
//

import UIKit

class CenteredLabelCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBorder()
    }
    
    func setupBorder() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 8.0
    }
    func setSelectedState() {
        label.textColor = UIColor.systemBlue
        layer.borderColor = UIColor.systemBlue.cgColor
        layer.borderWidth = 2.0
    }
    
    func setDeselectedState() {
        label.textColor = UIColor.black
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 8.0
    }
    override var isSelected: Bool {
        didSet {
            if isSelected {
                setSelectedState()
            } else {
                setDeselectedState()
            }
        }
    }
}
