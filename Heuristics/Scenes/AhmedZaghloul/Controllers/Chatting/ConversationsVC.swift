//
//  ConversationsVC.swift
//  ClinicSystem
//
//  Created by Ahmed Zaghloul on 2/8/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//
import UIKit
import Firebase
import Kingfisher
import JSQSystemSoundPlayer

class ConversationsVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView:UITableView!
    
    private lazy var channelRef: DatabaseReference = Database.database().reference().child("channels")
    private lazy var unreadedMessagesRef: DatabaseReference = Database.database().reference().child("unreaded_messages")

    private var channelRefHandle: DatabaseHandle?

    var senderDisplayName = ""
    var channels :[Channel] = []
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        observeChannels()
        Timer.scheduledTimer(timeInterval: 5, target: self,   selector: (#selector(ConversationsVC.observeUnreadedMessages)), userInfo: nil, repeats: false)
        senderDisplayName = (CURRENT_USER?.name!)!
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
//        // 1
//        let itemRef = channelRef.child("1001").child("messages").childByAutoId()
//
//        // 2
//        let messageItem = [
//            "senderId": (CURRENT_USER?.unique_id!)!,
//            "senderName": (CURRENT_USER?.name!)!,
//            "text": "Hey!",
//            ]
//
//        // 3
//        itemRef.setValue(messageItem)
//        channelRef.child("1001").child("last_message").setValue("Hey")
//        channelRef.child("1001").child("date").setValue(Date().getStringFromDate())
//        channelRef.child("1001").child("name").setValue((CURRENT_USER?.name!)!)
//
////        unreadedMessagesRef.child((channelRef.key)).removeValue()
//        let unreadedContent = [
//            "\((CURRENT_USER?.unique_id!)!)": true,
//            "last_message": "Hey!",
//            ] as [String : Any]
//        unreadedMessagesRef.child("1001").setValue(unreadedContent)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tableView.layoutIfNeeded()
        }
    }
    
    deinit {
        if let _ = channelRefHandle {
            channelRef.removeAllObservers()
            unreadedMessagesRef.removeAllObservers()
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let channel = sender as? Channel {
            let chatVc = segue.destination as! ChatViewController
            
            chatVc.senderDisplayName = senderDisplayName
            chatVc.channel = channel
            chatVc.channelRef = channelRef.child(channel.id)
        }
    }
    
    // MARK: Firebase related methods
    private func observeChannels() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in // 1
            print(snapshot.value)
            let channelData = snapshot.value as! Dictionary<String, AnyObject> // 2
            let id = snapshot.key
            if let name = channelData["name"] as! String!, name.count > 0 { // 3
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                let dateStr = (channelData["date"] as? String) ?? Date().getStringFromDate()
                guard let date = dateFormatter.date(from: dateStr) else {
                    return
                }
                self.channels.append(Channel(id: id, name: name,image: (channelData["image"] as? String) ?? "",date: date.getElapsedInterval(),lastMessage:(channelData["last_message"] as? String) ?? ""))
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("Error! Could not decode channel data")
            }
        })
        
//        channelRef.observe(.value, with: { (snapshot) in
//            for child in snapshot.children {
//                let channelSnap = child as? DataSnapshot // 2
//                let channelData = (channelSnap?.value) as? NSDictionary
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
//                let dateStr = (channelData?.getValueForKey(key: "date", callback: Date().getStringFromDate()))
//                guard let date = dateFormatter.date(from: dateStr ?? "") else {
//                    return
//                }
//                let chnl = Channel(id: (channelSnap?.key) ?? "", name: (channelData?.getValueForKey(key: "name", callback: ""))!, image: (channelData?.getValueForKey(key: "image", callback: ""))!, date: date.getElapsedInterval(), lastMessage: (channelData?.getValueForKey(key: "last_message", callback: ""))!)
//                let changedIndex = self.indexFor(channel: chnl)
//                if changedIndex != -1 {
//                    self.channels[changedIndex] = chnl
//                    DispatchQueue.main.async {
//                        let index = IndexPath(row: changedIndex, section: 0)
//                        self.tableView.reloadRows(at: [index], with: .automatic)
////                        let cell = self.tableView.cellForRow(at: index) as! ReservationCell
////                        cell.titleLabel.font =  UIFont.boldSystemFont(ofSize: cell.titleLabel.font.pointSize)
////                        cell.clinicLabel.textColor = appColor
//                        JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
//                    }
//
//                }
//            }
//
//        })
    }
    
    func indexFor(channel:Channel) -> Int {
        var index = -1
        let _ = self.channels.enumerated().contains { (indx,chnl) -> Bool in
            if channel.id == chnl.id {
                index = indx
                return true
            }
            return false
        }
        return index
    }
    
    @objc private func observeUnreadedMessages(){
        
        unreadedMessagesRef.observe(.value, with: { (snapshot) in
            for child in snapshot.children {
                let channelSnap = child as? DataSnapshot // 2
                let data = channelSnap?.value as! NSDictionary
                print(data)
                let changedChannel = Channel(id: (channelSnap?.key)!, name: "", image: "", date:"" , lastMessage: "",have_unread:true)
                let changedIndex = self.indexFor(channel: changedChannel)
                if changedIndex != -1 {
                    self.channels[changedIndex].have_unread = !(channelSnap?.hasChild((CURRENT_USER?.userId!)!))!
                    self.channels[changedIndex].lastMessage = data.getValueForKey(key: "last_message", callback: "")
                    let index = IndexPath(row: changedIndex, section: 0)
                    self.tableView.reloadRows(at: [index], with: .automatic)
                }
            }
        })

    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = channels[(indexPath as NSIndexPath).row]
//        let cell = tableView.cellForRow(at: indexPath) as! ReservationCell
//        cell.titleLabel.font = UIFont.systemFont(ofSize: cell.titleLabel.font.pointSize)
//        cell.clinicLabel.textColor = .darkGray
        self.performSegue(withIdentifier: "ShowChannel", sender: channel)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ConversationCell
        cell.titleLabel.text = channels[indexPath.row].name
        cell.subtitleLabel.text = channels[indexPath.row].lastMessage
        cell.timeLabel.text = channels[indexPath.row].date
        cell.titleLabel.font = channels[indexPath.row].have_unread! ? UIFont(name: "System  Bold", size: 15.0) : UIFont(name: "System", size: 15.0)
        cell.timeLabel.textColor = channels[indexPath.row].have_unread! ? appColor : UIColor.darkGray
        let url = URL(string: URL_IMAGE_PREFIX + "profiles/" + (channels[indexPath.row].image))
        cell.userImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Logo"), options: [.transition(ImageTransition.fade(1))], progressBlock: { receivedSize, totalSize in
        }, completionHandler: { image, error, cacheType, imageURL in
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 10.0
    }

}

