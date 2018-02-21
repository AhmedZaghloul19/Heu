//
//  Extensions.swift
//  RKAnjel
//
//  Created by Ahmed Zaghloul .
//  Copyright © 2017 Ahmed Zaghloul. All rights reserved.
//

import UIKit
import MapKit

let URL_IMAGE_PREFIX = "https://firebasestorage.googleapis.com/v0/b/heuristics-194822.appspot.com/o/images%2F"
let SERVICE_URL_PREFIX = "https://www.rkanjel.com/clinicsystem/api/"
var ACCESS_TOKEN = ""
let imageCache = NSCache<AnyObject, AnyObject>()
var CURRENT_USER:User? {
    didSet{
        debugPrint("Set")
    }
}
//67 189 167
let appColor = UIColor(red: 238/255, green: 8/255, blue: 78/255, alpha: 1.0)

enum Gender:Int{
    case Male = 0
    case Female = 1
}

enum Status:Int{
    case Pending = 0
    case Approved = 1
    case Cancelled = 2
    case Attended = 3
    case Missed = 4
}

enum Role:Int{
    case Doctor = 1
    case Assistant = 2
    case Patient = 3
}
enum ReservationType:Int{
    case CheckOut = 0
    case FollowUp = 1
}

enum AttachmentType:Int {
    case Image = 0
    case PDF = 1
    case DOC = 2
}

let userData  = UserDefaults.standard

extension NSMutableURLRequest{
    func setBodyConfigrationWithMethod(method:String){
        self.httpMethod = method
        self.setValue("application/json",forHTTPHeaderField:"Accept")
//        self.setValue("application/json",forHTTPHeaderField:"Content-Type")
//        self.setValue("utf-8", forHTTPHeaderField: "charset")
        self.addValue("Bearer \(ACCESS_TOKEN)", forHTTPHeaderField: "Authorization")
        debugPrint(ACCESS_TOKEN)
    }
}

extension UIImageView {
    func loadImageFrom(url:URL,placeholder:UIImage) {
        self.image = placeholder
        if let cachedImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = cachedImage
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let res:HTTPURLResponse = response as? HTTPURLResponse {
                if (error != nil || res.statusCode != 200) {
                    return
                }
                
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data!) {
                        imageCache.setObject(downloadedImage, forKey: url as AnyObject)
                        self.image = UIImage(data: data!)
                        
                    }
                }
            }
            }.resume()
    }
}

extension UITableView {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.tableFooterView = UIView()
    }
}

func cacheUserData() {
//    userData.set(CURRENT_USER?.id!, forKey: "ID")
//    userData.set((CURRENT_USER?.name!)!, forKey: "name")
//    userData.set((CURRENT_USER?.image!)!, forKey: "image")
//    userData.set((CURRENT_USER?.mobile!)!, forKey: "mobile")
//    userData.set((CURRENT_USER?.address!)!, forKey: "address")
//    userData.set((CURRENT_USER?.birthday!)!, forKey: "birthday")
//    userData.set((CURRENT_USER?.role?.rawValue)!, forKey: "role")
//    userData.set((CURRENT_USER?.unique_id)!, forKey: "UID")
}

func userAlreadyExist() -> Bool{
//    if let id = userData.value(forKey: "ID") as? Int {
//        CURRENT_USER = User()
//        CURRENT_USER?.id = id
//        CURRENT_USER?.name = userData.string(forKey: "name") ?? ""
//        CURRENT_USER?.image = userData.string(forKey: "image") ?? ""
//        CURRENT_USER?.mobile = userData.string(forKey: "mobile") ?? ""
//        CURRENT_USER?.address = userData.string(forKey: "address") ?? ""
//        CURRENT_USER?.birthday = userData.string(forKey: "birthday") ?? ""
//        CURRENT_USER?.role = Role(rawValue: userData.integer(forKey: "role"))
//        CURRENT_USER?.unique_id = userData.string(forKey: "UID") ?? ""
//        return true
//    }
    return false
}

extension UIView{
    
    func dropShadow(scale: Bool = true) {
        DispatchQueue.main.async {
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.3
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowRadius = 1.5
            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        }
    }

    func performConstraintsWithFormat(format:String,views:UIView...) {
        
        var viewsDic = [String:UIView]()
        
        for (index,view) in views.enumerated(){
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDic["v\(index)"] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDic))
        
    }
    
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
    
}

func randomNumber(range: ClosedRange<Int> = 1...6) -> Int {
    let min = range.lowerBound
    let max = range.upperBound
    return Int(arc4random_uniform(UInt32(1 + max - min))) + min
}

func isKeyPresentInUserDefaults(key: String) -> Bool {
    return UserDefaults.standard.object(forKey: key) != nil
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
//        if !sender.isKind(of: UIButton.self) {
//            return
//        }
        view.endEditing(true)
    }
    
    @IBAction func reload(){
        self.viewDidLoad()
    }
    
    @IBAction func backTapped(_ sender: Any?) {
        if let _  = self.navigationController?.popViewController(animated: true){
            
        }
    }
}

enum VendingMachineError:Error {
    case valueNotFounds
}

extension MKMapView {
    func zoomToUserLocation() {
        guard let coordinate = userLocation.location?.coordinate else { return }
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000)
        setRegion(region, animated: true)
    }
}

extension Date{
    func getStringFromDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return formatter.string(from: self as Date)
    }
    
    func getElapsedInterval() -> String {
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: Date())
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year" :
                "\(year)" + " " + "years"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month" :
                "\(month)" + " " + "months"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day" :
                "\(day)" + " " + "days"
        } else if let hour = interval.hour, hour > 0{
            return hour == 1 ? "\(hour)" + " " + "hour" :
                "\(hour)" + " " + "hours"
        } else if let minute = interval.minute, minute > 0{
            return minute == 1 ? "\(minute)" + " " + "minute" :
                "\(minute)" + " " + "minutes"
        }else{
            return "a moment ago"
        }
    }
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

extension NSDictionary {
    func getValueForKey<T>(key:String,callback:T)  -> T{
        guard let value  = self[key] as? T else{
            return callback}
        return value
    }
    func getValueForKey<T>(key:String) throws -> T{
        guard let value  = self[key] as? T else{throw VendingMachineError.valueNotFounds}
        return value
    }
}

extension UIViewController{
    func showAlertWithTitle(title:String?,message:String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showFailedAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Failed", message: "Couldn't Get Your Data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { (action) in
                self.viewDidLoad()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                self.view.isUserInteractionEnabled = false
                self.backTapped(nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showNoData(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Sorry", message: "There's no data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}

extension UIImage {
    var jpeg: Data? {
        return UIImageJPEGRepresentation(self, 0.5)
    }
    var png: Data? {
        return UIImagePNGRepresentation(self)
    }
}

enum AppErrorCode:Int {
    case Success = 0
    case MobileAlreadyExists = 1
    case EmailAlreadyExists = 2
    case DatabaseConnectionError = 3
    case AccounIsNotActive = 4
    case WrongCobinationOfPasswordOrUsername = 5
    case YouMustDetermineAccountType = 6
    case UserDoesnotExist = 7
    case CodeDoesnotMatch = 8
    case unauthorized = 9
    case errorSendingSms = 10
    case requestAlreadyExists = 11
    case requestDoesnotExist = 12
    case ValidationError = 400
    case NotFound = 204
    case Down = 404    
}

public enum AppLanguage:String {
    case arabic = "ar"
    case english = "en"
}
