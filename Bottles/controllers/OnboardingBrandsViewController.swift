//
//  OnboardingBrandsViewController.swift
//  Bottles
//
//  Created by talal ahmad on 11/01/2021.
//  Copyright © 2021 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import FirebaseFirestore
import MBProgressHUD
class OnboardingBrandsViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!
    var userName:String?
    var filterBrandData:[Brand] = []
    var isFilterSelected = false
    var selectedBrands:[Brand] = []{
        didSet {
            if selectedBrands.count > 4{
                self.saveButton.isHidden = false
            }else{
                self.saveButton.isHidden = true
            }
        }
    }
    var brands:[Brand] = [Brand(name: "NIKE", icon: "NIKE"),Brand(name: "ADIDAS ORIGINAL", icon: "ADIDAS ORIGINAL"),Brand(name: "KENZO", icon: "KENZO"),Brand(name: "PLAY COMME DES GARCONS", icon: "PLAY COMME DES GARCONS"),Brand(name: "COMMON PROJECTS", icon: "COMMON PROJECTS"),Brand(name: "A.P.C", icon: "A.P.C"),Brand(name: "FOLK", icon: "FOLK"),Brand(name: "MAISON KITSUNE", icon: "MAISON KITSUNE"),Brand(name: "COS", icon: "COS"),Brand(name: "NORSE PROJECTS", icon: "NORSE PROJECTS"),Brand(name: "THE HIP STORE", icon: "THE HIP STORE"),Brand(name: "SATURDAYS NYC", icon: "SATURDAYS NYC"),Brand(name: "AIME LEON DORE", icon: "AIME LEON DORE"),Brand(name: "SANDRO", icon: "SANDRO"),Brand(name: "ACNE STUDIOS", icon: "ACNE STUDIOS"),Brand(name: "PATAGONIA", icon: "PATAGONIA"),Brand(name: "AMI", icon: "AMI"),Brand(name: "CHAMPION", icon: "CHAMPION"),Brand(name: "YMC", icon: "YMC"),Brand(name: "MAISON LABICHE", icon: "MAISON LABICHE"),Brand(name: "UNIVERSAL WORKS", icon: "UNIVERSAL WORKS"),Brand(name: "CARHARTT", icon: "CARHARTT"),Brand(name: "WOOD WOOD", icon: "WOOD WOOD"),Brand(name: "NNO7", icon: "NNO7"),Brand(name: "NOAH", icon: "NOAH"),Brand(name: "RAINS", icon: "RAINS"),Brand(name: "EDWIN", icon: "EDWIN"),Brand(name: "NEW BALANCE", icon: "NEW BALANCE"),Brand(name: "LES DEUX", icon: "LES DEUX"),Brand(name: "ALLSAINTS", icon: "ALLSAINTS"),Brand(name: "THE KOOPLES", icon: "THE KOOPLES"),Brand(name: "LEVI'S", icon: "LEVI'S"),    Brand(name: "FARFETCH", icon: "FARFETCH"),Brand(name: "MR PORTER", icon: "MR PORTER"),Brand(name: "GUCCI", icon: "GUCCI"),Brand(name: "BALENCIAGA", icon: "BALENCIAGA"),Brand(name: "NORDSTORM", icon: "NORDSTORM"),Brand(name: "BURBERRY", icon: "BURBERRY"),Brand(name: "MONCLER", icon: "MONCLER"),Brand(name: "DOLCE & GABBANA", icon: "DOLCE & GABBANA"),Brand(name: "SAINT LAURENT", icon: "SAINT LAURENT"),Brand(name: "VERCASA", icon: "VERCASA"),Brand(name: "PRADA", icon: "PRADA"),Brand(name: "VALENTINO", icon: "VALENTINO"),Brand(name: "ALEXANDER MCQUEEN", icon: "ALEXANDER MCQUEEN"),Brand(name: "GIVENCHY", icon: "GIVENCHY"),Brand(name: "LANVIN", icon: "LANVIN"),Brand(name: "DIOR  HOMME", icon: "DIOR  HOMME"),Brand(name: "BRIONI", icon: "BRIONI"),Brand(name: "TOD'S", icon: "TOD'S"),Brand(name: "EMPORIO ARMANI", icon: "EMPORIO ARMANI"),Brand(name: "MOSCHINO", icon: "MOSCHINO"),Brand(name: "DSQUARED2", icon: "DSQUARED2"),Brand(name: "HELMUT LANG", icon: "HELMUT LANG"),Brand(name: "BOTTEGA VENETA", icon: "BOTTEGA VENETA"),Brand(name: "BRUNELLO CUCINELLI CASHMERE", icon: "BRUNELLO CUCINELLI CASHMERE"),Brand(name: "CANALI", icon: "CANALI"),Brand(name: "CHURCH'S", icon: "CHURCH'S"),Brand(name: "SALLE PRIVEE", icon: "SALLE PRIVEE"),Brand(name: "RALPH LAUREN PURPLE LABEL", icon: "RALPH LAUREN PURPLE LABEL"),Brand(name: "DUNHILL", icon: "DUNHILL"),Brand(name: "CHARVET", icon: "CHARVET"),Brand(name: "SANTONI", icon: "SANTONI"),Brand(name: "SIES MARJAN", icon: "SIES MARJAN"),Brand(name: "ISABEL BENENATO", icon: "ISABEL BENENATO"),Brand(name: "MISSONI", icon: "MISSONI"),Brand(name: "JACQUEMUS", icon: "JACQUEMUS"),Brand(name: "FAVOURBROOK", icon: "FAVOURBROOK"),Brand(name: "BERLUTI", icon: "BERLUTI"),Brand(name: "TOM FORD", icon: "TOM FORD")    ,Brand(name: "END.", icon: "END"),Brand(name: "SSENSE", icon: "SSENSE"),Brand(name: "OFF-WHITE C/O VIRGIL ABLOH", icon: "OFF-WHITE CO VIRGIL ABLOH"),Brand(name: "MONCLER", icon: "MONCLER"),Brand(name: "MARCELO BURLON", icon: "MARCELO BURLON"),Brand(name: "GCDS", icon: "GCDS"),Brand(name: "VETEMENTS", icon: "VETEMENTS"),Brand(name: "YEEZY", icon: "YEEZY"),Brand(name: "PALM ANGELS", icon: "PALM ANGELS"),Brand(name: "BALMAIN", icon: "BALMAIN"),Brand(name: "MAISON MARGIELA", icon: "MAISON MARGIELA"),Brand(name: "VISVIM", icon: "VISVIM"),Brand(name: "RHUDE", icon: "RHUDE"),Brand(name: "A_COLD_WALL*", icon: "A_COLD_WALL*"),Brand(name: "HERON PRESTON", icon: "HERON PRESTON"),Brand(name: "AMBUSH", icon: "AMBUSH"),Brand(name: "FACETASM", icon: "FACETASM") ,Brand(name: "AMIRI", icon: "AMIRI") ,Brand(name: "STONE ISLAND", icon: "STONE ISLAND"),Brand(name: "RICK OWENS", icon: "RICK OWENS"),Brand(name: "NEIL BARRETT", icon: "NEIL BARRETT"),Brand(name: "CALVIN KLEIN 205 W39 NYC", icon: "CALVIN KLEIN 205 W39 NYC"),Brand(name: "FEAR OF GOD", icon: "FEAR OF GOD")     ,Brand(name: "REVOLVE", icon: "REVOLVE") ,Brand(name: "FOREVER 21", icon: "FOREVER 21"),Brand(name: "TOPSHOP", icon: "TOPSHOP"),Brand(name: "H&M", icon: "H&M"),Brand(name: "FREE PEOPLE", icon: "FREE PEOPLE"),Brand(name: "RIVER ISLAND", icon: "RIVER ISLAND"),Brand(name: "MANGO", icon: "MANGO"),Brand(name: "MONKI", icon: "MONKI"),Brand(name: "BOOHOO", icon: "BOOHOO"),Brand(name: "MISSGUIDED", icon: "MISSGUIDED"),Brand(name: "NEW LOOK", icon: "NEW LOOK"),Brand(name: "EXPRESS", icon: "EXPRESS"),Brand(name: "& OTHER STORIES", icon: "& OTHER STORIES"),Brand(name: "KURT GEIGER", icon: "KURT GEIGER"),Brand(name: "SANCTUARY", icon: "SANCTUARY"),Brand(name: "VERO MODA", icon: "VERO MODA"),Brand(name: "AQUA", icon: "AQUA"),Brand(name: "INGRID & ISABEL", icon: "INGRID & ISABEL"),Brand(name: "TOMMY HILFIGER", icon: "TOMMY HILFIGER"),Brand(name: "UGG", icon: "UGG")    ,Brand(name: "PRIVATE WHITE V.C.", icon: "PRIVATE WHITE V.C."),Brand(name: "SUNSPEL", icon: "SUNSPEL"),Brand(name: "HACKETT", icon: "HACKETT"),Brand(name: "REISS", icon: "REISS"),Brand(name: "BROOKS BROTHERS", icon: "BROOKS BROTHERS"),Brand(name: "BILLY REID", icon: "BILLY REID"),Brand(name: "HICKEY FREEMAN", icon: "HICKEY FREEMAN"),Brand(name: "TOOD SNYDER", icon: "TOOD SNYDER"),Brand(name: "POLO RALPH LAUREN", icon: "POLO RALPH LAUREN"),Brand(name: "J.CREW", icon: "J.CREW"),Brand(name: "RRL", icon: "RRL"),Brand(name: "CLUB MONACO", icon: "CLUB MONACO")       ,Brand(name: "RLX RALPH LAUREN", icon: "RLX RALPH LAUREN"),Brand(name: "LACOSTE SPORT", icon: "LACOSTE SPORT"),Brand(name: "LULULEMON ATHLETICA", icon: "LULULEMON ATHLETICA"),Brand(name: "GEOX", icon: "GEOX"),Brand(name: "ADIDAS BY STELLA MCCARTNEY", icon: "ADIDAS BY STELLA MCCARTNEY"),Brand(name: "ADAM SELMAN SPORT", icon: "ADAM SELMAN SPORT"),Brand(name: "ADIDAS", icon: "ADIDAS"),Brand(name: "REEBOK", icon: "REEBOK"),Brand(name: "PUMA", icon: "PUMA"),Brand(name: "ASICS", icon: "ASICS"),Brand(name: "REEBOK X VICTORIA BECKHAM", icon: "REEBOK X VICTORIA BECKHAM")]
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 10
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let bounds = UIScreen.main.bounds
        let width = bounds.width
        layout.itemSize = CGSize(width: 80, height: 90)
        self.saveButton.isHidden = true
        collectionView.collectionViewLayout = layout
        //searchBar.searchBarStyle = .prominent
        searchBar.setTextField(color: UIColor.white)
        searchBar.layer.borderColor = UIColor.black.cgColor
        searchBar.layer.borderWidth =  2
        self.searchBar.delegate = self
        self.searchBar.autocapitalizationType = .none
        self.searchBar.showsCancelButton = false
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
                                "brands": self.selectedBrands.map({$0.name}),
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


}
extension OnboardingBrandsViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFilterSelected {
            return filterBrandData.count
        }else{
            return brands.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = isFilterSelected ? filterBrandData[indexPath.row] : brands[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newOnboardingBrandCVC", for: indexPath) as! newOnboardingBrandCVC
        cell.titleLabel.text = item.name
        let name = item.icon
        cell.setImage(name: name)
        cell.iconImageView.layer.borderWidth = 2
        cell.iconImageView.layer.borderColor = UIColor.gray.cgColor
        cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.width / 2
        
        cell.selectedView.layer.borderWidth = 2
        cell.selectedView.layer.borderColor = UIColor.gray.cgColor
        cell.selectedView.layer.cornerRadius = cell.selectedView.frame.width / 2
        if selectedBrands.contains(item) {
            cell.selectedView.isHidden = false
        }else{
            cell.selectedView.isHidden = true
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let bounds = UIScreen.main.bounds
            let width = bounds.width - 60
            return CGSize(width: width/3, height: 120)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let brand = isFilterSelected ? filterBrandData[indexPath.row] : brands[indexPath.row]
        if selectedBrands.contains(brand) {
            if let index = selectedBrands.firstIndex(of: brand){
                selectedBrands.remove(at: index)
            }
        }else{
            selectedBrands.append(brand)
        }
        self.collectionView.reloadData()
        
    }
    
}

extension UISearchBar {
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    func setTextField(color: UIColor) {
        guard let textField = getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }
}
extension OnboardingBrandsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentString: NSString = searchBar.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: text) as NSString
        searchData(newString: newString as String)
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isFilterSelected = false
            let items = brands
            filterBrandData = items
            self.collectionView.reloadData()
//            searchBar.endEditing(true)
        }else{
            searchData(newString: searchText)
        }
    }
    func searchData(newString:String){
        let test = String(newString.filter { !" \n\t\r".contains($0) })
        let items = brands
        if test.count > 0 {
            isFilterSelected = true
            let list = items.filter({$0.name.capitalized.contains(test.capitalized)})
            filterBrandData = list
            self.collectionView.reloadData()
        }else{
            isFilterSelected = false
            let list = items
            filterBrandData = list
            self.collectionView.reloadData()
        }
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
}
