//
//  FollowViewController.swift
//  Heuristics
//
//  Created by Ahmed Hussien on 2/11/18.
//  Copyright © 2018 Heuristic Gang. All rights reserved.
//

import UIKit

class FollowViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let followCellReuseIdentifier = "FollowTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
    }
    
    
    func configTableView() {
        let followCell = UINib(nibName: followCellReuseIdentifier, bundle: Bundle.main)
        self.tableView.register(followCell, forCellReuseIdentifier: followCellReuseIdentifier)
    }
}

extension FollowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

extension FollowViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: followCellReuseIdentifier, for: indexPath) as! FollowTableViewCell
        return cell
    }
}
