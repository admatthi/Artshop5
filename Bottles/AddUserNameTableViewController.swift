//
//  AddUserNameTableViewController.swift
//  Bottles
//
//  Created by talal ahmad on 09/12/2020.
//  Copyright © 2020 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import MBProgressHUD
class AddUserNameTableViewController: UITableViewController {

    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        signupButton.layer.cornerRadius = 5
        
    }

    @IBAction func signupButtonAction(_ sender: Any) {
        if userNameTF.text == "" || userNameTF.text == nil {
            showAlert(withTile: "", andMessage: "Please enter UserName.")
        }else{
            MBProgressHUD.showAdded(to: view, animated: true)
            db.collection("profile").whereField("userName", isEqualTo: userNameTF.text!).getDocuments() { (querySnapshot, err) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot!.documents.count > 0 {
                        self.showAlert(withTile: "", andMessage: "username taken!")
                    }else{
                        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = mainStoryboardIpad.instantiateViewController(withIdentifier: "OnBoardingViewController") as! OnBoardingViewController
                        vc.userName = self.userNameTF.text
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
                        appDelegate.window?.rootViewController = vc
                        
                        appDelegate.window?.makeKeyAndVisible()
                    }
                }
            }

        }

    }
    func showAlert(withTile title:String,andMessage message:String)
     {
         let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         self.present(alert, animated: true, completion: nil)
     }

}
