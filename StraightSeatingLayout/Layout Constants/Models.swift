//
//  Models.swift
//
//  CircularSeatLayout
//
//  Created by Ankush on 21/10/22.
//

import Foundation
import UIKit

//MARK: - Models

struct RESPONSE {
    var sections: [SECTION]?
    
    init(jsonArr: [AnyObject?]) {
        self.sections = []
        
        for obj in jsonArr {
            if let newObj = obj as? [String: AnyObject] {
                sections?.append(SECTION(jsonDict: newObj))
            }
            
        }
    }
}



struct SECTION {
    var rows: [ROW]?
    var title: String?
    
    init(jsonDict: [String: AnyObject]) {
        self.title = jsonDict[ConstantKeys.title] as? String
        
        self.rows = []
        let arr = jsonDict[ConstantKeys.ROW] as? [AnyObject?]
        for obj in arr! {
            if let newObj = obj as? [String: AnyObject] {
                rows?.append(ROW(jsonDict: newObj))
            }
            
        }
    }
}

struct ROW {
    
    var seats: String?
    var blocked: [Int]?
    var space: [SPACE]?
    var title: String?
    
    init(jsonDict: [String: AnyObject]?) {
        
        self.seats = jsonDict?[ConstantKeys.seats] as? String
        self.blocked = jsonDict?[ConstantKeys.blocked] as? [Int]
        self.title = jsonDict?[ConstantKeys.title] as? String
        
        self.space = []
        let arr = jsonDict?[ConstantKeys.space] as? [[String: Int]]
        for obj in arr! {
            space?.append(SPACE(jsonDict: obj))
        }
    }
}

struct SPACE {
    var key: String?
    var value: Int?
    
    init(jsonDict: [String: Int]?) {
        self.key = jsonDict?.keys.first
        self.value = jsonDict?.values.first
    }
}

//Seat constants for button
class ConstantKeys {
    static let ROW = "ROW"
    static let COLUMN = "COLUMN"
    static let SECTION = "SECTION"
    //Classes Model
   static let title = "TITLE"
    static let seats = "SEATS"
    static let blocked = "BLOCKED"
    static let space = "SPACE"
    static let key = "key"
    static let value = "value"
    //Messages
    static let numGreaterThenZero = "Number of seats should be greater then zero"
    static let pleaseEnterSeats = "Please enter number of seats"
    static let pleaseSelectMinimum  = "Please select minimum"
    static let pleaseSelectSeats = "Please select seats"
}
