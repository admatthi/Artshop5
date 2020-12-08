//
//  LikeModel.swift
//  Bottles
//
//  Created by talal ahmad on 08/12/2020.
//  Copyright © 2020 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

struct LikeModel {
    let id: String?
    let deal_id:String?
    let created: Timestamp?
    let user_id:String?

    init(id: String,deal_id:String,user_id:String) {
        self.id = id
        self.deal_id = deal_id
        self.user_id = user_id
        self.created = Timestamp()
    }
    init(withID id: String, json: [String: Any]) {
        self.id = id
        self.deal_id = json["deal_id"] as? String
        self.user_id = json["user_id"] as? String
        self.created = json["created_at"] as? Timestamp
        
    }
}

struct CommentModel {
    let id: String?
    let deal_id:String?
    let created: Timestamp?
    let user_id:String?
    let comment_text:String?
    let userName:String?

    init(id: String,deal_id:String,user_id:String,comment_text:String,userName:String?) {
        self.id = id
        self.deal_id = deal_id
        self.user_id = user_id
        self.created = Timestamp()
        self.comment_text = comment_text
        self.userName = userName
    }
    init(withID id: String, json: [String: Any]) {
        self.id = id
        self.deal_id = json["deal_id"] as? String
        self.user_id = json["user_id"] as? String
        self.created = json["created_at"] as? Timestamp
        self.comment_text = json["comment_text"] as? String
        self.userName = json["userName"] as? String
        
    }
}
