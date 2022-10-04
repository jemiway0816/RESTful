//
//  spend.swift
//  RESTful
//
//  Created by Jemiway on 2022/9/30.
//

import Foundation

struct Spend : Codable {
    
    var date:Date
    var menoy:Int
    var detail:String
    var type:String
    
    static func loadSpends() -> [Spend]? {
        
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.data(forKey: "spends") else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode([Spend].self, from: data)
    }
    
    static func saveSpends(_ spends:[Spend]) {
        
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(spends) else { return }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "spends")
    }
    
    
}
