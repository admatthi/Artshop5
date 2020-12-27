//
//  PostDealTableViewController.swift
//  Bottles
//
//  Created by talal ahmad on 02/12/2020.
//  Copyright © 2020 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD
import ReadabilityKit
import Kingfisher
import FirebaseFirestore
import DropDown
import ActionSheetPicker_3_0
class PostDealTableViewController: UIViewController,UITextFieldDelegate {
    let dropDown = DropDown()
    @IBOutlet weak var dealUrlTF: UITextField!
    @IBOutlet weak var brandTF: UITextField!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var CategoryButton: UIButton!
    @IBOutlet weak var itemTF: UITextField!
    @IBOutlet weak var currentPriceTF: UITextField!
    @IBOutlet weak var originalPriceTF: UITextField!
    @IBOutlet weak var brandImageView: UIImageView!
    var imageUrl :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        dealUrlTF.setLeftPaddingPoints(10)
        brandTF.setLeftPaddingPoints(10)
        categoryTF.setLeftPaddingPoints(10)
        itemTF.setLeftPaddingPoints(10)
        currentPriceTF.setLeftPaddingPoints(15)
        originalPriceTF.setLeftPaddingPoints(15)
        let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
            
            notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
            
        dealUrlTF.delegate = self
        brandTF.delegate = self
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
//        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
//        self.view.addGestureRecognizer(swipeRight)
//
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
//        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
//        self.view.addGestureRecognizer(swipeLeft)


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    @objc func appMovedToBackground() {
       print("app enters background")
   }

   @objc func appCameToForeground() {
//    let pasteboard = UIPasteboard.general
//    if let text = pasteboard.string , pasteboard.hasURLs{
//        print(text)
//        dealUrlTF.text = text
//        self.imageUrl = nil
//        self.brandImageView.image = nil
//        guard let articleUrl = URL(string: dealUrlTF.text ?? "") else { return }
//        MBProgressHUD.showAdded(to: view, animated: true)
//        Readability.parse(url: articleUrl, completion: { data in
//            MBProgressHUD.hide(for: self.view, animated: true)
//            let title = data?.title
//            let description = data?.description
//            let keywords = data?.keywords
//            let imageUrl = data?.topImage
//
//            let videoUrl = data?.topVideo
//            let datePublished = data?.datePublished
//
//            self.imageUrl = data?.topImage
//            if let url = URL(string: data?.topImage ?? ""){
//                self.brandImageView.kf.setImage(with: url)
//            }
//
//
//
//        })
//    }else{
////        dealUrlTF.text = ""
//    }
   }
     @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if (self.tabBarController?.selectedIndex)! < 3 { // set your total tabs here
                self.tabBarController?.selectedIndex += 1
            }
        } else if gesture.direction == .right {
            if (self.tabBarController?.selectedIndex)! > 0 {
                self.tabBarController?.selectedIndex -= 1
            }
        }
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if range.length>0  && range.location == 0 {
            let changedText = NSString(string: textField.text!).substring(with: range)
            if changedText.contains("$") {
                return false
            }
        }
        return true
    }
    @IBAction func CategoryButtonAction(_ sender: Any) {
//        dropDown.dataSource = ["Shoes", "Shirts", "Pants", "Jackets", "Sweaters", "Sweatshirts"]
//        dropDown.anchorView = CategoryButton
//        dropDown.topOffset = CGPoint(x: 0, y: 350)
//        dropDown.backgroundColor = .white
//        dropDown.textColor = .black
//        dropDown.show()
//        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
//            self?.categoryTF.text = item
//
//        }
        let names = ["Shoes", "Shirts", "Pants", "Jackets", "Sweaters", "Sweatshirts","Other"]
        ActionSheetStringPicker.show(withTitle: "Select Categories", rows:names, initialSelection: 0, doneBlock: {
            picker,index , value in
            self.categoryTF.text = names[index]
        }, cancel: { ActionStringCancelBlock in return }, origin: self.categoryTF)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dealUrlTF{
            let pasteboard = UIPasteboard.general
            if let text = pasteboard.string , pasteboard.hasURLs{
                print(text)
                dealUrlTF.text = text
                self.imageUrl = nil
                self.brandImageView.image = nil
                guard let articleUrl = URL(string: dealUrlTF.text ?? "") else { return }
                MBProgressHUD.showAdded(to: view, animated: true)
                Readability.parse(url: articleUrl, completion: { data in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    let title = data?.title
                    let description = data?.description
                    let keywords = data?.keywords
                    let imageUrl = data?.topImage
                   
                    let videoUrl = data?.topVideo
                    let datePublished = data?.datePublished
                    
                    self.imageUrl = data?.topImage
                    if let url = URL(string: data?.topImage ?? ""){
                        self.brandImageView.kf.setImage(with: url)
                    }
                    
                   
                    
                })
            }else{
    //            dealUrlTF.text = ""
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == dealUrlTF{
        self.imageUrl = nil
        self.brandImageView.image = nil
        guard let articleUrl = URL(string: textField.text ?? "") else { return }
        MBProgressHUD.showAdded(to: view, animated: true)
        Readability.parse(url: articleUrl, completion: { data in
            MBProgressHUD.hide(for: self.view, animated: true)
            let title = data?.title
            let description = data?.description
            let keywords = data?.keywords
            let imageUrl = data?.topImage
           
            let videoUrl = data?.topVideo
            let datePublished = data?.datePublished
            
            self.imageUrl = data?.topImage
            if let url = URL(string: data?.topImage ?? ""){
                self.brandImageView.kf.setImage(with: url)
            }
            
           
            
        })
        }
    }
    @IBOutlet weak var submitbutton: UIButton!
    func clearAll(){
        dealUrlTF.text = ""
        brandTF.text = ""
        itemTF.text = ""
        currentPriceTF.text = ""
        originalPriceTF.text = ""
        brandImageView.image = nil
        categoryTF.text = ""
    }
    @IBAction func submitButtonAction(_ sender: Any) {
        let currentPrice = Int(currentPriceTF.text ?? "") ?? 0
        let originalPrice = Int(originalPriceTF.text ?? "") ?? 0
        if dealUrlTF.text == nil || dealUrlTF.text == "" {
            showAlert(withTile: "", andMessage: "Please Enter Deal Url")
        }else if URL(string: dealUrlTF.text!) == nil {
            showAlert(withTile: "", andMessage: "Please Enter Valid Deal Url")
        }else if brandTF.text == nil || brandTF.text == "" {
            showAlert(withTile: "", andMessage: "Please Enter brand")
        }else  if itemTF.text == nil || itemTF.text == "" {
            showAlert(withTile: "", andMessage: "Please Enter Item")
        }else  if currentPriceTF.text == nil || currentPriceTF.text == "" {
            showAlert(withTile: "", andMessage: "Please add Current Price")
        }else  if originalPriceTF.text == nil || originalPriceTF.text == "" {
            showAlert(withTile: "", andMessage: "Please add Original Price")
        }else if categoryTF.text == "" {
            showAlert(withTile: "", andMessage: "Please Select Atleast one Category")
        }else if currentPrice >= originalPrice {
            showAlert(withTile: "" , andMessage: "Current Price must be less than the orginal price.")
        }else{
            self.postData(dealurl: dealUrlTF.text ?? "", brandName: brandTF.text ?? "", ItemName: itemTF.text ?? "", originalPrice: originalPriceTF.text ?? "", currentPrice: currentPriceTF.text ?? "", imageUrl: self.imageUrl ?? "", category: categoryTF.text ?? "")
        }
    }
    func showAlert(withTile title:String,andMessage message:String)
     {
         let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         self.present(alert, animated: true, completion: nil)
     }
    func postData(dealurl:String,brandName:String,ItemName:String,originalPrice:String,currentPrice:String,imageUrl:String,category:String){
        MBProgressHUD.showAdded(to: view, animated: true)
        // Add a second document with a generated ID.
        var ref: DocumentReference? = nil

        ref = db.collection("latest_deals").addDocument(data: [
            "brand": brandName,
            "image": imageUrl,
            "name": ItemName,
            "new_price": Int(currentPrice) ?? 0,
            "orignal_price": Int(originalPrice) ?? 0,
            "url": dealurl,
            "website":dealurl,
            "category":category,
            "created_at":Date(),
            "expirationCount":0,
            "expired":false
        ]) { err in
            if let err = err {
                MBProgressHUD.hide(for: self.view, animated: true)
                print("Error adding document: \(err)")
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.clearAll()
                self.showAlert(withTile: "Deal Submitted!", andMessage: "")

                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
    }
}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
