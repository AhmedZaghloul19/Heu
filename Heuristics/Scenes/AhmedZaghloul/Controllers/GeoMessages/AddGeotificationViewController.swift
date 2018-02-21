//
//  Memory.swift
//  Heuristics
//
//  Created by Ahmed Zaghloul on 2/11/18.
//  Copyright © 2018 Heuristic Gang. All rights reserved.
//

import UIKit
import MapKit
import Firebase

protocol AddGeotificationsViewControllerDelegate {
    func addGeotificationViewController(controller: AddGeotificationViewController, didAddCoordinate coordinate: CLLocationCoordinate2D,
                                        radius: Double, identifier: String, note: String, eventType: EventType,senderName:String)
}

class AddGeotificationViewController: UITableViewController ,MessageUsersDelegate{
    
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var zoomButton: UIBarButtonItem!
    @IBOutlet weak var eventTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var radiusTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var receiverTitleLabel:UILabel!
    
    var delegate: AddGeotificationsViewControllerDelegate?
    var receiver:User?
    private lazy var locationMsgsRef: DatabaseReference = Database.database().reference().child("location_messages")

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [addButton, zoomButton]
        addButton.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BrowseUsersVC {
            vc.delegate = self
        }
    }
    
    func didSelected(user: User) {
        self.receiverTitleLabel.text = "Message To: " + user.name!
        self.receiverTitleLabel.textColor = .black
        self.receiver = user
    }
    
    @IBAction func textFieldEditingChanged(sender: UITextField) {
        addButton.isEnabled = !radiusTextField.text!.isEmpty && !noteTextField.text!.isEmpty
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func onAdd(sender: AnyObject) {
        if receiver == nil {
            let coordinate = mapView.centerCoordinate
            let radius = Double(radiusTextField.text!) ?? 0
            let identifier = NSUUID().uuidString
            let note = noteTextField.text
            let eventType: EventType = (eventTypeSegmentedControl.selectedSegmentIndex == 0) ? .onEntry : .onExit
            delegate?.addGeotificationViewController(controller: self, didAddCoordinate: coordinate, radius: radius, identifier: identifier, note: note!, eventType: eventType, senderName: "")
        }else{
            let eventType: EventType = (eventTypeSegmentedControl.selectedSegmentIndex == 0) ? .onEntry : .onExit
            let messageRef = self.locationMsgsRef.child((receiver?.userId!)!).childByAutoId()
            let messageItem:[String:Any] = [
                "lng": mapView.centerCoordinate.longitude,
                "lat": mapView.centerCoordinate.latitude,
                "radius": Double(radiusTextField.text!) ?? 0,
                "identifier": messageRef.key,
                "note": noteTextField.text!,
                "eventType": eventType.rawValue,
                "sender_name": (CURRENT_USER?.name!)!,
                "sender_id":(CURRENT_USER?.userId!)!,
                ]
            
            messageRef.setValue(messageItem, withCompletionBlock: { (error, ref) in
                if error == nil {
                    let alert = UIAlertController(title: "Success", message: "Your Message has been set successfully", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction private func onZoomToCurrentLocation(sender: AnyObject) {
        mapView.zoomToUserLocation()
    }
}
