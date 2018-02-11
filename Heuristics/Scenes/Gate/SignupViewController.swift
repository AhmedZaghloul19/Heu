//
//  SignupViewController.swift
//  Heuristics
//
//  Created by Ahmed Hussien on 2/8/18.
//  Copyright © 2018 Heuristic Gang. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signinButtonTapped(_ sender: UIButton) {
        let homeViewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
        self.present(homeViewController, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
