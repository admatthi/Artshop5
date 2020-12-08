//
//  Genre.swift
//  BookNotesDebug
//
//  Created by Alek Matthiessen on 8/5/19.
//

import UIKit

public struct Genre {
    let books: [Book]?

    public init(withJSON json: [String: Any]) {
        self.books = json.enumerated().compactMap({ (_, element) -> Book? in
            let bookID = element.key
            if let bookJSON = element.value as? [String: Any] {

                return Book(withID: bookID, json: bookJSON)
            }
            return nil
        })
    }
}


public struct UserLikeData {
    let likes: [LikeModel]?

    public init(withJSON json: [String: Any]) {
        self.likes = json.enumerated().compactMap({ (_, element) -> LikeModel? in
            let likeID = element.key
            if let likeJSON = element.value as? [String: Any] {

                return LikeModel(withID: likeID, json: likeJSON)
            }
            return nil
        })
    }
}
public struct CommentData {
    let comments: [CommentModel]?

    public init(withJSON json: [String: Any]) {
        self.comments = json.enumerated().compactMap({ (_, element) -> CommentModel? in
            let likeID = element.key
            if let likeJSON = element.value as? [String: Any] {

                return CommentModel(withID: likeID, json: likeJSON)
            }
            return nil
        })
    }
}
