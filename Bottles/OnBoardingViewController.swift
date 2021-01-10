//
//  OnBoardingViewController.swift
//  Bottles
//
//  Created by talal ahmad on 04/12/2020.
//  Copyright © 2020 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import FirebaseFirestore
import MBProgressHUD

class OnBoardingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var allBrands = ["Gucci","Dior","Versace","Off White","Supreme","Louis Vuitton","Adidas","Balenciaga","Common Projects","Georgio Armani","Hermes","Prada","Ralph Lauren","J. Crew","Lululemon",]
    
    var brands:[Brand] = [Brand(name: "NIKE", icon: "NIKE"),Brand(name: "ADIDAS ORIGINAL", icon: "ADIDAS ORIGINAL"),Brand(name: "KENZO", icon: "KENZO"),Brand(name: "PLAY COMME DES GARCONS".capitalized, icon: "PLAY COMME DES GARCONS".capitalized),Brand(name: "COMMON PROJECTS".capitalized, icon: "COMMON PROJECTS   ".capitalized),Brand(name: "A.P.C".capitalized, icon: "A.P.C".capitalized),Brand(name: "FOLK".capitalized, icon: "FOLK".capitalized),Brand(name: "MAISON KITSUNE".capitalized, icon: "MAISON KITSUNE".capitalized),Brand(name: "COS".capitalized, icon: "COS".capitalized),Brand(name: "NORSE PROJECTS".capitalized, icon: "NORSE PROJECTS".capitalized),Brand(name: "THE HIP STORE".capitalized, icon: "THE HIP STORE".capitalized),Brand(name: "SATURDAYS NYC".capitalized, icon: "SATURDAYS NYC".capitalized),Brand(name: "AIME LEON DORE".capitalized, icon: "AIME LEON DORE".capitalized),Brand(name: "SANDRO".capitalized, icon: "SANDRO".capitalized),Brand(name: "ACNE STUDIOS".capitalized, icon: "ACNE STUDIOS".capitalized),Brand(name: "PATAGONIA".capitalized, icon: "PATAGONIA".capitalized),Brand(name: "AMI".capitalized, icon: "AMI".capitalized),Brand(name: "CHAMPION".capitalized, icon: "CHAMPION".capitalized),Brand(name: "YMC".capitalized, icon: "YMC".capitalized),Brand(name: "MAISON LABICHE".capitalized, icon: "MAISON LABICHE".capitalized),Brand(name: "UNIVERSAL WORKS".capitalized, icon: "UNIVERSAL WORKS".capitalized),Brand(name: "CARHARTT".capitalized, icon: "CARHARTT".capitalized),Brand(name: "WOOD WOOD".capitalized, icon: "WOOD WOOD".capitalized),Brand(name: "NNO7".capitalized, icon: "NNO7".capitalized),Brand(name: "NOAH".capitalized, icon: "NOAH".capitalized),Brand(name: "RAINS".capitalized, icon: "RAINS".capitalized),Brand(name: "EDWIN".capitalized, icon: "EDWIN".capitalized),Brand(name: "NEW BALANCE".capitalized, icon: "NEW BALANCE".capitalized),Brand(name: "LES DEUX".capitalized, icon: "LES DEUX".capitalized),Brand(name: "ALLSAINTS".capitalized, icon: "ALLSAINTS".capitalized),Brand(name: "THE KOOPLES".capitalized, icon: "THE KOOPLES".capitalized),Brand(name: "LEVI'S".capitalized, icon: "LEVI'S".capitalized)]
    
    var selectedBrands:[String] = []
    var userName:String?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        saveButton.layer.cornerRadius = 10
        
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
                            UserName = self.userName
                            UserDefaults.standard.setValue(UserName, forKey: "UserName")
                            MBProgressHUD.showAdded(to: self.view, animated: true)
                            document?.reference.updateData([
                                "brands": self.selectedBrands,
                                "userName":self.userName
                            ],completion: { (error) in
                                MBProgressHUD.hide(for: self.view, animated: true)
                                if error == nil {
                                    UserDefaults.standard.set(true, forKey: "launchedBefore")
                                    let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    let vc : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "mainTabbarController") as! UITabBarController
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
                                    appDelegate.window?.rootViewController = vc
                                    appDelegate.window?.makeKeyAndVisible()
                                    
                                }
                            })

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
struct Brand:Equatable {
    var name:String
    var icon:String
    static func ==(lhs: Brand, rhs: Brand) -> Bool {
        return lhs.name == rhs.name && lhs.icon == rhs.icon
    }
}
