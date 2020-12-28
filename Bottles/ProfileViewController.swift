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
struct BrandSection {
    var type: String
    var Brands: [String]
}

class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {
//    brandSection = [BrandSection(type: "MY BRANDS", Brands: []),BrandSection(type: "ALL BRANDS", Brands: []),BrandSection(type: "A", Brands: ["Adidas"]),BrandSection(type: "B", Brands: ["Balenciaga"]),BrandSection(type: "C", Brands: ["Common Projects"]),BrandSection(type: "D", Brands: ["Dior",]),BrandSection(type: "E", Brands: []),BrandSection(type: "F", Brands: []),BrandSection(type: "G", Brands: ["Georgio Armani","Gucci"]),BrandSection(type: "H", Brands: ["Hermes"]),BrandSection(type: "I", Brands: []),BrandSection(type: "J", Brands: ["J. Crew"]),BrandSection(type: "K", Brands: []),BrandSection(type: "L", Brands: ["Louis Vuitton","Lululemon"]),BrandSection(type: "M", Brands: []),BrandSection(type: "N", Brands: []),BrandSection(type: "O", Brands: ["Off White"]),BrandSection(type: "P", Brands: ["Prada"]),BrandSection(type: "Q", Brands: []),BrandSection(type: "R", Brands: ["Ralph Lauren"]),BrandSection(type: "S", Brands: ["Supreme"]),BrandSection(type: "T", Brands: []),BrandSection(type: "U", Brands: []),BrandSection(type: "V", Brands: ["Versace"]),BrandSection(type: "W", Brands: []),BrandSection(type: "X", Brands: []),BrandSection(type: "Y", Brands: []),BrandSection(type: "Z", Brands: [])]
    @IBOutlet weak var notificationSwitch: UISwitch!
    var brandSection:[BrandSection] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    var allBrands = ["Gucci","Dior","Versace","Off White","Supreme","Louis Vuitton","Adidas","Balenciaga","Common Projects","Georgio Armani","Hermes","Prada","Ralph Lauren","J. Crew","Lululemon",]
    var selectedBrands:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        brandSection = [BrandSection(type: "MY BRANDS", Brands: []),BrandSection(type: "ALL BRANDS", Brands: []),BrandSection(type: "A", Brands: ["Adidas"]),BrandSection(type: "B", Brands: ["Balenciaga"]),BrandSection(type: "C", Brands: ["Common Projects"]),BrandSection(type: "D", Brands: ["Dior",]),BrandSection(type: "G", Brands: ["Georgio Armani","Gucci"]),BrandSection(type: "H", Brands: ["Hermes"]),BrandSection(type: "J", Brands: ["J. Crew"]),BrandSection(type: "L", Brands: ["Louis Vuitton","Lululemon"]),BrandSection(type: "O", Brands: ["Off White"]),BrandSection(type: "P", Brands: ["Prada"]),BrandSection(type: "R", Brands: ["Ralph Lauren"]),BrandSection(type: "S", Brands: ["Supreme"]),BrandSection(type: "V", Brands: ["Versace"])]
        self.tableView.dataSource = self
        self.tableView.delegate = self
        saveButton.layer.cornerRadius = 10
        saveButton.layer.borderColor = UIColor.black.cgColor
        saveButton.layer.borderWidth = 1.0
        // Do any additional setup after loading the view.
        getPrefrences()
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
//        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
//        self.view.addGestureRecognizer(swipeRight)
//
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
//        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
//        self.view.addGestureRecognizer(swipeLeft)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        saveBrandsPrefrences()
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
                    if let userName = data["userName"] as? String
                    {
                        UserName = userName
                        UserDefaults.standard.setValue(UserName, forKey: "UserName")
                        
                    }
                    if let brands = data["brands"] as? [String]
                    {
                        self.selectedBrands = brands
                        self.brandSection[0].Brands = brands
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
//        MBProgressHUD.showAdded(to: view, animated: true)
        db.collection("profile").whereField("uid", isEqualTo: uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if querySnapshot!.documents.count == 0{

                }else{
                    let updateReference = db.collection("profile").document(querySnapshot!.documents.first?.documentID ?? "")
                    updateReference.getDocument { (document, err) in
//                        MBProgressHUD.hide(for: self.view, animated: true)
                        if let err = err {
                            print(err.localizedDescription)
                        }
                        else {
                            document?.reference.updateData([
                                "brands": self.selectedBrands
                                ])
//                            self.showAlert(withTile: "", andMessage: "Brand's Updated Successfully")
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return brandSection.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return brandSection[0].Brands.count
        }else{
            return brandSection[section].Brands.count
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionText = self.brandSection[section].type
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            headerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            let label = UILabel()
            label.frame = CGRect.init(x: 20, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
            label.text = sectionText
            label.font = UIFont(name: "HelveticaNeue-Bold", size: 15) // my custom font
            label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) // my custom colour

            headerView.addSubview(label)

            return headerView
        }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 35
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.brandSection[section]

        return section.type
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let brand = brandSection[0].Brands[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "BrandTableViewCell", for: indexPath) as! BrandTableViewCell
            cell.brandNamelabel.text = brand
            cell.brandNamelabel.textColor = #colorLiteral(red: 0.01176470588, green: 0.3098039216, blue: 0.2784313725, alpha: 1)
            cell.radioImageView.isHidden = false
            cell.radioImageView.image = #imageLiteral(resourceName: "checked")
            return cell
        }else{
            let brand = brandSection[indexPath.section].Brands[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "BrandTableViewCell", for: indexPath) as! BrandTableViewCell
            cell.brandNamelabel.text = brand
            if selectedBrands.contains(brand){
                cell.brandNamelabel.textColor = #colorLiteral(red: 0.01176470588, green: 0.3098039216, blue: 0.2784313725, alpha: 1)
                cell.radioImageView.isHidden = false
                cell.radioImageView.image = #imageLiteral(resourceName: "checked")
            }else{
                cell.brandNamelabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.radioImageView.isHidden = true
            }
            return cell
        }

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            
        }else{
            let brand = brandSection[indexPath.section].Brands[indexPath.row]
            if selectedBrands.contains(brand) {
                if let index = selectedBrands.firstIndex(of: brand){
                    selectedBrands.remove(at: index)
                    brandSection[0].Brands.remove(at: index)
                }
            }else{
                selectedBrands.append(brand)
                brandSection[0].Brands.append(brand)

            }
            self.tableView.reloadData()
        }


    }

}
