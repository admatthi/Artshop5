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
class PostDealTableViewController: UITableViewController,UITextFieldDelegate {
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
    lazy var copyButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.03529411765, green: 0.3098039216, blue: 0.2784313725, alpha: 1)
        button.titleLabel?.text = ""
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(fabTapped(_:)), for: .touchUpInside)
        return button
    }()
    lazy var copyButtonLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.text = "from clipboard"
       
        return label
    }()
    @objc func fabTapped(_ button: UIButton) {
        print("button tapped")
        self.dealUrlTF.text = self.copyButton.titleLabel?.text ?? ""
    }
    func setupButton() {
        NSLayoutConstraint.activate([
            copyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            copyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            copyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -26),
            copyButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        copyButton.layer.cornerRadius = 10
        copyButton.layer.masksToBounds = true
        copyButton.layer.borderWidth = 1
        NSLayoutConstraint.activate([
            copyButtonLabel.trailingAnchor.constraint(equalTo: copyButton.trailingAnchor, constant: -36),
            copyButtonLabel.leadingAnchor.constraint(equalTo: copyButton.leadingAnchor, constant: 36),
            copyButtonLabel.bottomAnchor.constraint(equalTo: copyButton.bottomAnchor, constant: -30),
            ])
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let view = UIApplication.shared.keyWindow {
            view.addSubview(copyButton)
            view.addSubview(copyButtonLabel)
            setupButton()
            
        }
        let pasteboard = UIPasteboard.general
        if let text = pasteboard.string , pasteboard.hasURLs{
            print(text)
            copyButtonLabel.isHidden = false
            copyButton.isHidden = false
            copyButton.setTitle(text, for: .normal)
            copyButton.setTitle(text, for: .selected)
        }else{
            copyButton.setTitle("", for: .normal)
            copyButton.setTitle("", for: .selected)
            copyButton.isHidden = true
            copyButtonLabel.isHidden = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let view = UIApplication.shared.keyWindow, copyButton.isDescendant(of: view) {
            copyButton.removeFromSuperview()
            copyButtonLabel.removeFromSuperview()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dealUrlTF.delegate = self
        brandTF.delegate = self
        submitbutton.layer.borderColor = UIColor.black.cgColor
        submitbutton.layer.borderWidth = 1.0
        submitbutton.layer.cornerRadius = 10
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

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
        let names = ["Shoes", "Shirts", "Pants", "Jackets", "Sweaters", "Sweatshirts"]
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
            showAlert(withTile: "Validation Error", andMessage: "Please Enter DealUrl")
        }else if URL(string: dealUrlTF.text!) == nil {
            showAlert(withTile: "Validation Error", andMessage: "Please Enter Valid DealUrl")
        }else if brandTF.text == nil || brandTF.text == "" {
            showAlert(withTile: "Validation Error", andMessage: "Please Enter brand")
        }else  if itemTF.text == nil || itemTF.text == "" {
            showAlert(withTile: "Validation Error", andMessage: "Please Enter Item")
        }else  if currentPriceTF.text == nil || currentPriceTF.text == "" {
            showAlert(withTile: "Validation Error", andMessage: "Please add Current Price")
        }else  if originalPriceTF.text == nil || originalPriceTF.text == "" {
            showAlert(withTile: "Validation Error", andMessage: "Please add Original Price")
        }else if categoryTF.text == "" {
            showAlert(withTile: "Validation Error", andMessage: "Please Select Atleast one Category")
        }else if brandImageView.image == nil {
            showAlert(withTile: "Validation Error" , andMessage: "brand Url Did't able to get brand image please try other Rich url")
        }else if currentPrice >= originalPrice {
            showAlert(withTile: "Validation Error" , andMessage: "Current Price must be less than the orginal price.")
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
            "created_at":Date()
        ]) { err in
            if let err = err {
                MBProgressHUD.hide(for: self.view, animated: true)
                print("Error adding document: \(err)")
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.clearAll()
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
    }
}
