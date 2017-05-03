//
//  Deck.swift
//  Flashcard Touch
//
//  Created by TuanAnhVu on 4/29/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

import Foundation
import UIKit

class Deck {
    var identifier : String
    var name : String
    var cards : [Card]
    var lastActivity : Date?
    var folderID : String
    
    init(){
        identifier = ""
        name = ""
        cards = []
        lastActivity = Date()
        folderID = ""
    }
    
    init(identifier:String ,name:String, cards:[Card],lastActivity:Date?,folderID:String) {
        self.identifier = identifier
        self.name = name
        self.cards = cards
        self.lastActivity = lastActivity
        self.folderID = folderID
    }
    
}
