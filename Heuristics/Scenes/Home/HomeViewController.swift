//
//  HomeViewController.swift
//  Heuristics
//
//  Created by Ahmed Hussien on 2/8/18.
//  Copyright © 2018 Heuristic Gang. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func followingTapped(_ sender: UIButton) {
    }
    
    @IBAction func followersTapped(_ sender: UIButton) {
        let followersVC = FollowViewController(nibName: "FollowViewController", bundle: nil)
        self.present(followersVC, animated: true, completion: nil)
    }
    
    @IBAction func logoutTapped(_ sender: UIButton) {
    }
    
    @IBAction func profileTapped(_ sender: UIButton) {
        let editProfileVC = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
        self.present(editProfileVC, animated: true, completion: nil)
    }
    
    @IBAction func messagesTapped(_ sender: UIButton) {
    }
    
    @IBAction func memoriesTapped(_ sender: UIButton) {
    }
    
    @IBAction func chatTapped(_ sender: UIButton) {
    }
    
    @IBAction func alertsTapped(_ sender: UIButton) {
    }
    
    @IBAction func searchTapped(_ sender: UIButton) {
    }
    
    @IBAction func requestsTapped(_ sender: UIButton) {
    }
    
    @IBAction func cameraTapped(_ sender: UIButton) {
    }
    
}
