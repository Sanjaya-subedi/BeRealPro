//
//  User.swift
//  BeReal
//
//  Created by Sanjaya Subedi on 2/26/23.
//

import Foundation

import ParseSwift
import UIKit
struct User: ParseUser {
    // These are required by `ParseObject`.
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // These are required by `ParseUser`.
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    var authData: [String: [String: String]?]?
    
    var name: String?
    var sessionToken: String?
    
    var profilePhoto: ParseFile?
    
    var lastPostedDate: Date?
    
    

    // Your custom properties.
    // var customKey: String?
//    static func authenticate(token: String, completion: @escaping (Result<Self, Error>) -> Void) {
//            Self.current(token: token) { result in
//                switch result {
//                case .success(let user):
//                    completion(.success(user))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//        }
}
