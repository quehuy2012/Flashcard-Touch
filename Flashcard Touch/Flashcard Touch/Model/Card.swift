//
//  Card.swift
//  Flashcard Touch
//
//  Created by TuanAnhVu on 4/29/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

import Foundation
import UIKit

struct Card {
    var term : String
    var definition : String
    var termImage : UIImage?
    var definitionImage: UIImage?
    var deckID : String
    
    init(){
        term = ""
        definition = ""
        termImage = UIImage()
        definitionImage = UIImage()
        deckID = ""
    }
    
    init(term:String, definition:String,termImage:UIImage?,definitionImage:UIImage?,deckID:String) {
        self.term = term
        self.definition = definition
        self.termImage = termImage
        self.definitionImage = definitionImage
        self.deckID = deckID
    }
    
}
