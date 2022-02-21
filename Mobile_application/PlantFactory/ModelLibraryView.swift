//
//  ModelLibraryView.swift
//  upload
//
//  Created by 珏 on 2022/2/12.
//

import Foundation
import UIKit
import WebKit
import SafariServices

class ModelLibraryView: UIViewController, SFSafariViewControllerDelegate{
    


    var safariVC = SFSafariViewController(url: URL(string: "http://192.168.31.246/pictures/website/model.php")!)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewControllerAsChildViewController()
    }
    
    
    
    
        
    //firstVCIdentifier
    func addViewControllerAsChildViewController() {
        addChild(safariVC)
        self.view.addSubview(safariVC.view)
        safariVC.didMove(toParent: self)
        self.setUpConstraints()
    }
        
    func setUpConstraints() {
        self.safariVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.safariVC.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: -0).isActive = true
        self.safariVC.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,constant: 50).isActive = true
        self.safariVC.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.safariVC.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        // set bar color
        self.safariVC.preferredControlTintColor = UIColor.clear
        self.safariVC.preferredBarTintColor = UIColor.clear
        
        
    }
    
}

