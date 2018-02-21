//
//  MemoriesVC.swift
//  Heuristics
//
//  Created by Ahmed Zaghloul on 2/11/18.
//  Copyright © 2018 Heuristic Gang. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import CoreLocation
import MobileCoreServices

class MemoriesVC: BaseViewController , UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postTextView: UITextView!

    var memories = [Memory]()
    private lazy var memoryRef: DatabaseReference = Database.database().reference().child("memories").child("1001")
    private var memoryRefHandle: DatabaseHandle?

    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        tableView.estimatedRowHeight = 120
        postTextView.text = "New Memory"
        postTextView.textColor = UIColor.lightGray
    }
    
    override func getData() {
        super.getData()
        observeMemories()
    }
    
    deinit {
        if let refHandle = memoryRefHandle {
            memoryRef.removeObserver(withHandle: refHandle)
        }
    }
    
    // MARK: Firebase related methods
    private func observeMemories() {
        // Use the observe method to listen for new
        
        memoryRefHandle = memoryRef.observe(.childAdded, with: { (snapshot) -> Void in // 1
            self.activityIndicator.startAnimating()
            if let memoryData = snapshot.value as? NSDictionary  {
                let memory = Memory(data:memoryData as AnyObject)
                self.memories.append(memory)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            }else {
                DispatchQueue.main.async {
                    self.errorView.isHidden = false
                }
            }
        })
        
    }
    
    // MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier = "MemoryCell"
        if memories[indexPath.row].image == "" {
            identifier = "MemoryWithoutImageCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MemoryCell
        
        cell.locationLabel.text = memories[indexPath.row].location?.name!
        cell.timeLabel.text = memories[indexPath.row].time!
        cell.memoryDescriptionLabel.text = memories[indexPath.row].status!
        
        let url = URL(string: URL_IMAGE_PREFIX + (memories[indexPath.row].image)! + "?alt=media")
        cell.memoryImageView?.loadImageFrom(url: url!, placeholder: #imageLiteral(resourceName: "Logo"))

        return cell
    }
}
