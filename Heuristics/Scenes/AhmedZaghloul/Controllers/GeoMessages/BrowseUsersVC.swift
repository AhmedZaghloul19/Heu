//
//  BrowseUsersVC.swift
//  Heuristics
//
//  Created by Ahmed Zaghloul on 2/20/18.
//  Copyright © 2018 Heuristic Gang. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

protocol MessageUsersDelegate:class {
    func didSelected(user:User)
}

class BrowseUsersVC: BaseViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView:UITableView!
    
    private lazy var usersRef: DatabaseReference = Database.database().reference().child("users")
    weak var delegate :MessageUsersDelegate?
    var users :[User] = []
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func getData() {
        super.getData()
        observeChannels()
    }
    
    // MARK: Firebase related methods
    private func observeChannels() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        usersRef.observeSingleEvent(of: .value, with: { (snapshot) -> Void in // 1
            print(snapshot.value)
            for child in snapshot.children {
                let userData = child as! DataSnapshot
                if let channelData = userData.value as? NSDictionary {// 2
                    self.users.append(User(data: channelData as AnyObject))
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorView.isHidden = false
                    }
                }
            }
        })
        
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[(indexPath).row]

        self.delegate?.didSelected(user: user)
        self.backTapped(nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ConversationCell
        cell.titleLabel.text = users[indexPath.row].name!
        cell.subtitleLabel.text = users[indexPath.row].email!
        cell.timeLabel.text = users[indexPath.row].username!
//        cell.titleLabel.font = channels[indexPath.row].have_unread! ? UIFont(name: "System  Bold", size: 15.0) : UIFont(name: "System", size: 15.0)
//        cell.timeLabel.textColor = channels[indexPath.row].have_unread! ? appColor : UIColor.darkGray
//        let url = URL(string: URL_IMAGE_PREFIX + "profiles/" + (channels[indexPath.row].image))
//        cell.userImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Logo"), options: [.transition(ImageTransition.fade(1))], progressBlock: { receivedSize, totalSize in
//        }, completionHandler: { image, error, cacheType, imageURL in
//        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 10.0
    }
    
}

