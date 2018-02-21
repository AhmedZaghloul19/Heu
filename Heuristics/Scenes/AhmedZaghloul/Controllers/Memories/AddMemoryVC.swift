//
//  AddMemoryVC.swift
//  Heuristics
//
//  Created by Ahmed Zaghloul on 2/19/18.
//  Copyright © 2018 Heuristic Gang. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import MobileCoreServices

class AddMemoryVC: BaseViewController {
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var postImageView: UIImageView!
    var imagePicker = UIImagePickerController()
    
    var currentCoordinate:CLLocationCoordinate2D!
    var locationManager:CLLocationManager = CLLocationManager()
    var selectedImage : Data?
    
    private lazy var storageRef: StorageReference = Storage.storage().reference().child("images")
    private lazy var memoryRef: DatabaseReference = Database.database().reference().child("memories").child("1001")
    private var memoryRefHandle: DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTextView.text = "New Memory"
        postTextView.textColor = UIColor.lightGray
        
        getCurrentPlace()
    }
    
    override func getData() {
        self.errorView.isHidden = true
    }
    
    func getCurrentPlace() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.notDetermined
        {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        self.locationManager.startUpdatingLocation()
        self.currentCoordinate = locationManager.location?.coordinate
        
    }
    
    @IBAction func shareNewMemory(){
        if postTextView.text! != "" && selectedImage != nil {
            getAddressFromLocation(center: currentCoordinate)
        }
    }
    
    func getAddressFromLocation(center:CLLocationCoordinate2D){
        self.activityIndicator.startAnimating()
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        let ceo: CLGeocoder = CLGeocoder()
        var addressString = ""
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality!
                    }
                    
                    
                    let newMemoryRef = self.memoryRef.childByAutoId()
                    let messageItem: [String : Any] = ["location": ["lng": self.currentCoordinate.longitude,
                                                                    "lat": self.currentCoordinate.latitude,
                                                                    "name": addressString],
                                                       "status":self.postTextView.text!,
                                                       "time":Date().getStringFromDate(),
                                                       "image":"\(newMemoryRef.key).jpg",
                        "id":newMemoryRef.key
                    ]
                    if self.selectedImage != nil {
                        self.storageRef.child("\(newMemoryRef.key).jpg").putData(self.selectedImage!, metadata: nil) { (metadata, error) in
                            guard let _ = metadata else {
                                // Uh-oh, an error occurred!
                                return
                            }
                            self.postImageView.image = nil
                            newMemoryRef.setValue(messageItem)
                        }
                    }
                    
                    self.postTextView.text = ""
                    self.dismissKeyboard()
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.postTextView.text = "New Memory"
                        self.postTextView.textColor = UIColor.lightGray
                        self.backTapped(nil)
                    }
                    
                    print(addressString)
                }
        })
    }
    
}

extension AddMemoryVC : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "New Memory"
            textView.textColor = UIColor.lightGray
        }
    }
}

extension AddMemoryVC:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentCoordinate = locations.last?.coordinate
    }
}

//For Image Selection
extension AddMemoryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func chooseImageTapped(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.navigationBar.tintColor = appColor
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            if let jpegData = pickedImage.jpeg {
                selectedImage = jpegData
                DispatchQueue.main.async {
                    self.postImageView.image = pickedImage
                    self.postImageView.isHidden = false
                    self.postImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
                    self.postImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
                }
            }
        }else{
            self.dismiss(animated: true, completion: {
                self.showAlertWithTitle(title: "Failed", message: "Sorry,unsupported this image format")
            })
        }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

