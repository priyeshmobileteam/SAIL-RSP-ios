//
//  OrderListViewController.swift
//  SAIL Bokaro
//
//  Created by HICDAC on 22/02/24.
//
import UIKit
import SwiftUI



class TrackerController: UIViewController {
    var position: Int!
    var arrData: [TrackerModel]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a UIHostingController with the SwiftUIContentView
        let hostingController = UIHostingController(rootView: ContentView(position: position, arrData: arrData))
        
        // Embed the UIHostingController in the UIKit view hierarchy
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        // Set constraints if needed
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
