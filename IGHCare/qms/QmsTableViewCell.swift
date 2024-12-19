//
//  CustomTableViewCell.swift
//  IGHCare
//
//  Created by HICDAC on 18/09/24.
//
import UIKit

// Define the delegate protocol
protocol QmsTableViewCellDelegate: AnyObject {
    func didTapImage(in cell: QmsTableViewCell,modeval:Int)
}

class QmsTableViewCell: UITableViewCell {
    @IBOutlet weak var serviceTypeBtn: UIButton!
    @IBOutlet weak var qrImageView: UIImageView!
    // Delegate property - make sure it's weak to avoid retain cycles
        weak var delegate: QmsTableViewCellDelegate?
    override func awakeFromNib() {
            super.awakeFromNib()
            
        
        serviceTypeBtn.isUserInteractionEnabled = true
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(serviceTypeBtnTapped))
        serviceTypeBtn.addGestureRecognizer(tapGesture1)
        
        qrImageView.isUserInteractionEnabled = true
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        qrImageView.addGestureRecognizer(tapGesture2)
        
        }

       
    @objc func serviceTypeBtnTapped() {
        delegate?.didTapImage(in: self,modeval: 1)
    }
    // Method to handle tap
    @objc func imageTapped() {
        delegate?.didTapImage(in: self,modeval: 2)
    }
}


