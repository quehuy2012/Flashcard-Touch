//
//  Folder.swift
//  Flashcard Touch
//
//  Created by TuanAnhVu on 4/29/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

import Foundation
import UIKit

struct Folder {
    var identifier : String
    var name : String
    var decks : [Deck]?
    
    init(){
        identifier = ""
        name = ""
        decks = []
    }
    
    init(identifier:String ,name:String, decks:[Deck]?) {
        self.identifier = identifier
        self.name = name
        self.decks = decks
    }
}
