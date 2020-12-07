//
//  ProfileViewController.swift
//  Bottles
//
//  Created by talal ahmad on 04/12/2020.
//  Copyright © 2020 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import FirebaseFirestore
import MBProgressHUD
class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {

    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    var allBrands = ["Gucci","Dior","Versace","Off White","Supreme","Louis Vuitton","Adidas","Balencigia","Common Projects","Georgio Armani","Hermes","Prada","Ralph Lauren","J. Crew","Lululemon",]
    var selectedBrands:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        saveButton.layer.cornerRadius = 10
        saveButton.layer.borderColor = UIColor.black.cgColor
        saveButton.layer.borderWidth = 1.0
        // Do any additional setup after loading the view.
        getPrefrences()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
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
    @IBAction func notificationSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            saveNotificationPrefrences(value: true)
        }else{
            saveNotificationPrefrences(value: false)
        }
    }
    func getPrefrences(){
        MBProgressHUD.showAdded(to: view, animated: true)
        db.collection("profile").whereField("uid", isEqualTo: uid).getDocuments() { (querySnapshot, err) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    UserId = document.documentID
                    if let brands = data["brands"] as? [String]
                    {
                        self.selectedBrands = brands
                        
                    }
                    if let notificationFlag = data["notificationEnable"] as? Bool{
                        self.notificationSwitch.setOn(notificationFlag, animated: true)
                    }
                    self.tableView.reloadData()
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    func saveNotificationPrefrences(value:Bool){
        MBProgressHUD.showAdded(to: view, animated: true)
        db.collection("profile").whereField("uid", isEqualTo: uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if querySnapshot!.documents.count == 0{

                }else{
                    let updateReference = db.collection("profile").document(querySnapshot!.documents.first?.documentID ?? "")
                    updateReference.getDocument { (document, err) in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        if let err = err {
                            print(err.localizedDescription)
                        }
                        else {
                            document?.reference.updateData([
                                "notificationEnable": self.notificationSwitch.isOn
                                ])

                        }
                    }

                }
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    func saveBrandsPrefrences(){
        MBProgressHUD.showAdded(to: view, animated: true)
        db.collection("profile").whereField("uid", isEqualTo: uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if querySnapshot!.documents.count == 0{

                }else{
                    let updateReference = db.collection("profile").document(querySnapshot!.documents.first?.documentID ?? "")
                    updateReference.getDocument { (document, err) in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        if let err = err {
                            print(err.localizedDescription)
                        }
                        else {
                            document?.reference.updateData([
                                "brands": self.selectedBrands
                                ])
                            self.showAlert(withTile: "", andMessage: "Brand's Updated Successfully")
                        }
                    }

                }
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    @IBAction func saveButtonAction(_ sender: Any) {
        if selectedBrands.count == 0 {
            showAlert(withTile: "Error", andMessage: "Please select atleast one Brand")
        }else{
            saveBrandsPrefrences()
        }
        

    }
    func showAlert(withTile title:String,andMessage message:String)
     {
         let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         self.present(alert, animated: true, completion: nil)
     }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allBrands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let brand = allBrands[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrandTableViewCell", for: indexPath) as! BrandTableViewCell
        cell.brandNamelabel.text = brand
        if selectedBrands.contains(brand){
            cell.radioImageView.image = #imageLiteral(resourceName: "checked")
        }else{
            cell.radioImageView.image = #imageLiteral(resourceName: "unchecked")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let brand = allBrands[indexPath.row]
        if selectedBrands.contains(brand) {
            if let index = selectedBrands.firstIndex(of: brand){
                selectedBrands.remove(at: index)
            }
        }else{
            selectedBrands.append(brand)

        }
        self.tableView.reloadData()

    }

}
