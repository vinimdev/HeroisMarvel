//
//  MarvelAPI.swift
//  HeroisMarvel
//
//  Created by Vinicius Meira on 24/01/23.
//  Copyright © 2023 Eric Brito. All rights reserved.
//

import Foundation
import SwiftHash
import Alamofire

class MarvelAPI {
    static private let basePath = "https://gateway.marvel.com/v1/public/characters?"
    static private let privateKey = "5a054538cc4ac981672e26d82d8cc60fb7b294b7"
    static private let publicKey = "1ee630444f1675b64592419c9b0a2103"
    static private let limit = 50
    
    class func loadHeros(name: String?, page: Int = 0, onComplete: @escaping (MarvelInfo?) -> Void) {
        let offset = page * limit
        let startsWith: String
        if let name = name, !name.isEmpty {
            startsWith = "nameStartsWith=\(name.replacingOccurrences(of: " ", with: ""))&"
        } else {
            startsWith = ""
        }
        
        let url = basePath + "offset=\(offset)&limit=\(limit)&" + startsWith + getCredentials()
        print(url)
        Alamofire.request(url).responseJSON { (response) in
            guard let data = response.data else {
                onComplete(nil)
                return
            }
            do {
                let marvelInfo = try JSONDecoder().decode(MarvelInfo.self, from: data)
                onComplete(marvelInfo)
            } catch {
                print(error.localizedDescription)
                onComplete(nil)
            }
        }
    }
    
    private class func getCredentials() -> String {
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(ts + privateKey + publicKey).lowercased()
        
        return "ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
    }
}
