//
//  LandingViewController.swift
//  Heuristics
//
//  Created by Ahmed Hussien on 2/7/18.
//  Copyright © 2018 Heuristic Gang. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    @IBOutlet weak var signinButton: GradientButton!
    @IBOutlet weak var signUpButton: DesignableButton!
    @IBOutlet weak var logoStackView: UIStackView!
    
    var firstTimeFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        if firstTimeFlag == false {
            firstTimeFlag = true
            setupView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAnimations()
    }
    
    func setupView() {
        let logoStackViewSpace = self.view.center.y - logoStackView.center.y
        logoStackView.transform = CGAffineTransform(translationX: 0, y: logoStackViewSpace)
        signinButton.transform = CGAffineTransform(translationX: 0, y: 200)
        signUpButton.transform = CGAffineTransform(translationX: 0, y: 300)
    }
    
    func setupAnimations() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            UIView.animate(withDuration: 1, animations: { [weak self] in
                self?.logoStackView.transform = CGAffineTransform.identity
                self?.signinButton.transform = CGAffineTransform.identity
                self?.signUpButton.transform = CGAffineTransform.identity
            })
        })
    }
}
