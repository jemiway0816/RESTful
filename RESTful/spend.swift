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
        
        // 用spends當key有拿到data
        guard let data = userDefaults.data(forKey: "spends") else { return nil }
        
        // 以Spend結構解碼並傳回Spend陣列
        let decoder = JSONDecoder()
        return try? decoder.decode([Spend].self, from: data)
    }

    static func saveSpends(_ spends:[Spend]) {

        let encoder = JSONEncoder()
        
        // 將傳入的spends資料編碼成data
        guard let data = try? encoder.encode(spends) else { return }
        
        // 用spends當key將data存進UserDefaults
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "spends")
    }
   
}
