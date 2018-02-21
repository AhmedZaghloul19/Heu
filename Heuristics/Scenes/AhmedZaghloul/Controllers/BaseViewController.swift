//
//  BaseViewController.swift
//  CafeSupreme
//
//  Created by Ahmed on 8/22/17.
//  Copyright © 2017 RKAnjel. All rights reserved.
//

import UIKit

/**
 Base View Controller For All Controllers of the app.
 ````
 @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
 
 lazy var errorView = ConnectionErrorView()
 
 ````
 
 - titleLabel: Outlet connected to a title UIlabel
 - activityIndicator: Outlet connected to an activity indicator when loading.
 - navigationBarView: Outlet connected to a navigation bar.
 
 ## Important Notes ##
 This controller is the base view controller For The APP.
 */

class BaseViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    lazy var errorView = ConnectionErrorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.constructConnectionErrorView()
        getData()
    }
    
    func getData() {
        self.errorView.isHidden = true
        self.activityIndicator?.startAnimating()
    }
    
    func constructConnectionErrorView() {
        if !self.view.subviews.contains(errorView){
            errorView.frame = self.view.frame
            self.view.addSubview(errorView)
            self.errorView.tryAgainBtn.addTarget(self, action: #selector(reload), for: .touchUpInside)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
