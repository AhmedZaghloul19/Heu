//
//  GeoMessagesVC.swift
//  Heuristics
//
//  Created by Ahmed Zaghloul on 2/20/18.
//  Copyright © 2018 Heuristic Gang. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import CoreLocation

class GeoMessagesVC: BaseViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView:UITableView!
    var locationManager = CLLocationManager()
    private lazy var locMsgsRef: DatabaseReference = Database.database().reference().child("location_messages")
    weak var delegate :MessageUsersDelegate?
    var geoMessages :[Geotification] = []
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestAlwaysAuthorization()
    }
    
    override func getData() {
        super.getData()
        observeMessages()
    }
    
    // MARK: Firebase related methods
    private func observeMessages() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        locMsgsRef.child((CURRENT_USER?.userId!)!).observe(.childAdded, with: { (snapshot) -> Void in // 1
            let userData = snapshot as DataSnapshot
            if let channelData = userData.value as? NSDictionary {// 2
                let type = EventType(rawValue: channelData.getValueForKey(key: "eventType", callback: "On Entry"))!
                let iden = channelData.getValueForKey(key: "identifier", callback: "")
                let lat = channelData.getValueForKey(key: "lat", callback: 0.0)
                let lng = channelData.getValueForKey(key: "lng", callback: 0.0)
                let co = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                let nt = channelData.getValueForKey(key: "note", callback: "")
                let rd = channelData.getValueForKey(key: "radius", callback: 100.0)
                let sender = channelData.getValueForKey(key: "sender_name", callback: "")
                
                let geo = Geotification(coordinate: co, radius:                     min(rd, (self.locationManager.maximumRegionMonitoringDistance)), identifier: iden, note: nt, eventType: type,senderName:sender)
                self.geoMessages.append(geo)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.startMonitoring(geotification: geo)
                    self.saveAllGeotificationMessages()
                }
            }else {
                DispatchQueue.main.async {
                    self.errorView.isHidden = false
                }
            }
        })
        
    }
    
    func region(withGeotification geotification: Geotification) -> CLCircularRegion {
        // 1
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        // 2
        region.notifyOnEntry = (geotification.eventType == .onEntry)
        region.notifyOnExit = !region.notifyOnEntry
        return region
    }
    
    func startMonitoring(geotification: Geotification) {
        // 1
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            showAlertWithTitle(title:"Error", message: "Geofencing is not supported on this device!")
            return
        }
        // 2
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            showAlertWithTitle(title:"Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.")
        }
        // 3
        let region = self.region(withGeotification: geotification)
        print(region.identifier)
        // 4
        locationManager.startMonitoring(for: region)
    }
    
    func stopMonitoring(geotification: Geotification) {
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == geotification.identifier else { continue }
            locationManager.stopMonitoring(for: circularRegion)
        }
    }
    
    func saveAllGeotificationMessages() {
        var items: [Data] = []
        for geotification in geoMessages {
            let item = NSKeyedArchiver.archivedData(withRootObject: geotification)
            items.append(item)
        }
        UserDefaults.standard.set(items, forKey: PreferencesKeys.receivedMessages)
    }
    
    // MARK: UITableViewDelegate
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let geoMessage = users[(indexPath).row]
//
//        self.delegate?.didSelected(user: user)
//        self.backTapped(nil)
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return geoMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ConversationCell
        cell.titleLabel.text = geoMessages[indexPath.row].senderName
        cell.subtitleLabel.text = geoMessages[indexPath.row].note
        cell.timeLabel.text = "Radius: \(geoMessages[indexPath.row].radius)m"
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
