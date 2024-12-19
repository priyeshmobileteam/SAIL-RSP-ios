//
//  CreateAbhaViewController.swift
//  e-Sushrut HMIS SAIL Bokaro
//
//  Created by HICDAC on 15/08/22.
//

import UIKit
import iOSDropDown

class CreateAbhaViewController: UIViewController {

    
   
    @IBOutlet weak var consent_tv: UITextView!
    @IBOutlet weak var agree: UIButton!
    // declare bool
    @IBOutlet weak var submitBtn: UIButton!
    var unchecked = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
}

    @IBAction func agree(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
   
    @IBAction func submitBtnAction(_ sender: Any) {
        
    }
}
