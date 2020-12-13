//
//  DealDetailCommentsVC.swift
//  Bottles
//
//  Created by talal ahmad on 09/12/2020.
//  Copyright © 2020 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import MBProgressHUD
import FirebaseFirestore
import IQKeyboardManagerSwift
class DealDetailCommentsVC: UIViewController,UITextFieldDelegate {
    var deal:Book?
    @IBOutlet weak var markAsExpiredButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var sendbutton: UIButton!
    @IBOutlet weak var commentTextTF: UITextField!
    var userLikedDeal:[LikeModel] = [] {
        didSet {
            
        }
    }
    var comments :[CommentModel] = []{
        didSet {
            DispatchQueue.main.async(execute: tableView.reloadData)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextTF.delegate = self
        self.modalPresentationStyle = .fullScreen
        markAsExpiredButton.layer.cornerRadius = 10
        markAsExpiredButton.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        markAsExpiredButton.layer.borderWidth = 1
        let datemy = deal?.created
        commentTextTF.layer.borderWidth = 1
        commentTextTF.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        commentTextTF.setLeftPaddingPoints(10)
        let date = datemy!.dateValue()
        dateLabel.text = date.timeAgoSinceDate()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        getAllComments(DealId: deal?.bookID ?? "")
    }
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enableAutoToolbar = true
        super.viewWillDisappear(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enableAutoToolbar = false
        super.viewWillAppear(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if commentTextTF.text == "" || commentTextTF.text == nil {
            
        }else{
            if let username = UserDefaults.standard.string(forKey: "UserName"),let userId = UserDefaults.standard.string(forKey: "UserId") {
                saveComment(userName: username, userID: userId, dealiD: deal?.bookID ?? "", CommentText: commentTextTF.text ?? "")
                self.commentTextTF.text = nil
            }

        }
        return true
    }
    @IBAction func sendbuttonAction(_ sender: Any) {

    }
    @IBAction func markAsExpiredButtonAction(_ sender: Any) {
        if let userid = UserId{
            if let exprireReq = deal?.expiredRequest {
                if exprireReq.contains(userid) {
                    
                }else{
                    markAsExpired(dealId: deal?.bookID ?? "")
                }
            }else{
                markAsExpired(dealId: deal?.bookID ?? "")
            }
            
            
        }
       
    }
    
    
    func getAllComments(DealId:String){
        MBProgressHUD.showAdded(to: view, animated: true)
        db.collection("deal_comment").whereField("deal_id", isEqualTo: DealId).getDocuments() { (querySnapshot, err) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let para:NSMutableDictionary = NSMutableDictionary()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let docId = document.documentID
                    let prod: NSMutableDictionary = NSMutableDictionary()
                    for (key, value) in data {
                        prod.setValue(value, forKey: "\(key)")
                        
                    }
                    
                    para.setObject(prod, forKey: docId as NSCopying)
                }
                if para.count > 0 {
                    
                    if let snapDict = para as? [String : Any] {
                        
                        let comments = CommentData(withJSON: snapDict)
                        
                        if let comments = comments.comments {
                            
                            self.comments = comments
                            
                            //
                            //
                            self.comments = self.comments.sorted(by: { $0.created?.dateValue().timeIntervalSince1970 ?? 0 > $1.created?.dateValue().timeIntervalSince1970 ?? 1 })
                            
                        }
                    }
                }else{
                    self.comments = []
                }
            }
        }
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func markAsExpired(dealId:String){
        MBProgressHUD.showAdded(to: view, animated: true)
        let updateReference = db.collection("latest_deals").document(dealId)
        updateReference.getDocument { (document, err) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let err = err {
                print(err.localizedDescription)
            }
            else {
                if let deal = self.deal {
                    let count = deal.expirationCount + 1
                    if let userId = UserId {
                        self.deal?.expiredRequest?.append(userId)
                    }
               
                    if deal.expirationCount >= 2 {
                        document?.reference.updateData([
                            "expirationCount": count,
                            "expired":true,
                            "expiredRequest":self.deal?.expiredRequest ?? []
                            ])
                    }else{
                        document?.reference.updateData([
                            "expirationCount": count,
                            "expiredRequest":self.deal?.expiredRequest ?? []
                            ])
                    }

                }

            }
        }
    }
    func saveComment(userName:String,userID:String,dealiD:String,CommentText:String){
        MBProgressHUD.showAdded(to: view, animated: true)
        // Add a second document with a generated ID.
        var ref: DocumentReference? = nil

        ref = db.collection("deal_comment").addDocument(data: [
            "comment_text": CommentText,
            "deal_id": dealiD,
            "user_id": userID,
            "userName":userName,
            "created_at":Date()
        ]) { err in
            if let err = err {
                MBProgressHUD.hide(for: self.view, animated: true)
                print("Error adding document: \(err)")
            } else {
                let updateReference = db.collection("latest_deals").document(dealiD)
                updateReference.getDocument { (document, err) in
                    if let err = err {
                        print(err.localizedDescription)
                    }
                    else {
                        if let deal = self.deal {
                            let count = deal.commentCount + 1
                            self.deal?.commentCount = count
                            if let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? DealDetailTableViewCell{
                                cell.commentButton.setTitle("\(deal.commentCount)", for: .normal)
                                cell.commentButton.setTitle("\(deal.commentCount)", for: .selected)
                            }
                            self.comments.append(CommentModel(id: ref!.documentID, deal_id: dealiD, user_id: userID, comment_text: CommentText, userName: userName))
                            self.tableView.reloadData()
                            document?.reference.updateData([
                                "comment_count": count
                                ])
                           
                        }

                    }
                }

                MBProgressHUD.hide(for: self.view, animated: true)
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
    }

}
extension DealDetailCommentsVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1+comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DealDetailTableViewCell", for: indexPath) as! DealDetailTableViewCell
            if let bookdata = deal{
                if bookdata.expired {
                    cell.soldoutLabel.isHidden = false
                    cell.dealImageView.alpha = 0.25
                }else{
                    cell.soldoutLabel.isHidden = true
                    cell.dealImageView.alpha = 1
                }
            }
            cell.brandNameLabel.text = deal?.brand
            cell.detailLabel.text = deal?.name
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "$\((deal?.originalprice)!)")
            
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            
            cell.oldPriceLabel.attributedText = attributeString
            cell.oldPriceLabel.text = "$\(deal?.originalprice ?? 0)"
            cell.likeButton.setTitle("\(deal?.likesCount ?? 0)", for: .normal)
            cell.likeButton.setTitle("\(deal?.likesCount ?? 0)", for: .selected)
            cell.commentButton.setTitle("\(deal?.commentCount ?? 0)", for: .normal)
            cell.commentButton.setTitle("\(deal?.commentCount ?? 0)", for: .selected)
            cell.likeButton.setImage(#imageLiteral(resourceName: "blackheart"), for: .normal)
            cell.likeButton.setImage(#imageLiteral(resourceName: "blackheart"), for: .selected)
            cell.likeButton.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
            cell.likeButton.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .selected)
            cell.likeButton.setImage(#imageLiteral(resourceName: "blackheart"), for: .selected)
            for i in userLikedDeal {
                if i.deal_id == deal?.bookID {
                    cell.likeButton.setImage(#imageLiteral(resourceName: "redheart"), for: .normal)
                    cell.likeButton.setImage(#imageLiteral(resourceName: "redheart"), for: .selected)
                    cell.likeButton.setTitleColor(#colorLiteral(red: 0.9627978206, green: 0.3363226652, blue: 0.2758938074, alpha: 1), for: .normal)
                    cell.likeButton.setTitleColor(#colorLiteral(red: 0.9627978206, green: 0.3363226652, blue: 0.2758938074, alpha: 1), for: .selected)
//                                cell.likeButton.isUserInteractionEnabled = false
                }
            }
            if let imageURLString = deal?.imageURL, let imageUrl = URL(string: imageURLString) {
            cell.dealImageView.kf.setImage(with: imageUrl)
            }
            cell.fromLabel.text = deal?.category
            return cell
        }else{
            let comment = comments[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
            cell.userNameLabel.text = comment.userName
            cell.detailLabel.text = comment.comment_text
            return cell
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 350.0
        }
        return UITableView.automaticDimension
    }
    
    
    func estimatedFrame(text: String, font: UIFont) -> CGRect {
        let size = CGSize(width: 200, height: 1000) // temporary size
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [NSAttributedString.Key.font: font],
                                                   context: nil)
    }
}
