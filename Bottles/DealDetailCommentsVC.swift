//
//  DealDetailCommentsVC.swift
//  Bottles
//
//  Created by talal ahmad on 09/12/2020.
//  Copyright © 2020 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit

class DealDetailCommentsVC: UIViewController {
    var deal:Book?
    var userLikedDeal:[LikeModel] = [] {
        didSet {
            
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let datemy = deal?.created
        
        let date = datemy!.dateValue()
        dateLabel.text = date.timeAgoSinceDate()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    


}
extension DealDetailCommentsVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DealDetailTableViewCell", for: indexPath) as! DealDetailTableViewCell
        cell.brandNameLabel.text = deal?.brand
        cell.detailLabel.text = deal?.name
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "$\((deal?.originalprice)!)")
        
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        
        cell.oldPriceLabel.attributedText = attributeString
        cell.oldPriceLabel.text = "$\(deal?.originalprice ?? 0)"
        cell.likeButton.setTitle("\(deal?.likesCount ?? 0)", for: .normal)
        cell.likeButton.setTitle("\(deal?.likesCount ?? 0)", for: .selected)
        if let imageURLString = deal?.imageURL, let imageUrl = URL(string: imageURLString) {
        cell.dealImageView.kf.setImage(with: imageUrl)
        }
        cell.fromLabel.text = deal?.category
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 350.0
        }
        return 0
    }
    
    
}
