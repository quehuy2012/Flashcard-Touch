//
//  SeedData.swift
//  Flashcard Touch
//
//  Created by TuanAnhVu on 4/29/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

import Foundation
import UIKit

//create Card

let cards1 : [Card] = [
    Card(term: "normal", definition: "bình thường", termImage: nil, definitionImage: nil, deckID: "1"),
    Card(term: "apple", definition: "táo", termImage: nil, definitionImage: nil, deckID: "1")
]

let cards2 : [Card] = [
    Card(term: "book", definition: "sách", termImage: nil, definitionImage: nil, deckID: "2"),
    Card(term: "books", definition: "nhiều quyền sách hay do bạn bựa sáng tác", termImage: nil, definitionImage: nil, deckID: "2"),
    Card(term: "cook", definition: "nấu ăn", termImage: nil, definitionImage: nil, deckID: "2"),
]

let cards: [Card] = [
    Card(term: "normal", definition: "bình thường", termImage: nil, definitionImage: nil, deckID: "1"),
    Card(term: "apple", definition: "táo", termImage: nil, definitionImage: nil, deckID: "1"),
    Card(term: "book", definition: "sách", termImage: nil, definitionImage: nil, deckID: "2"),
    Card(term: "books", definition: "nhiều quyền sách", termImage: nil, definitionImage: nil, deckID: "2"),
    Card(term: "cook", definition: "nấu ăn", termImage: nil, definitionImage: nil, deckID: "2"),
    Card(term: "smile", definition: "hihihihihihihihihihihihihihihihihiihihihihihihihihiihihihihiihihihihihihiihihhihihihihi", termImage: nil, definitionImage: nil, deckID: "2"),
    Card(term: "beautiful", definition: "bựa đẹp trai", termImage: nil, definitionImage: nil, deckID: "2"),
    Card(term: "handsome", definition: "bựa siêu đẹp trai", termImage: nil, definitionImage: nil, deckID: "2"),
    Card(term: "intelligent", definition: "bựa thông minh", termImage: nil, definitionImage: nil, deckID: "2"),
    Card(term: "impossible", definition: "ko thể cản phá bựa", termImage: nil, definitionImage: nil, deckID: "2"),
    Card(term: "lightning", definition: "sấm sét", termImage: nil, definitionImage: nil, deckID: "2")
]


//create deck
var decks : [Deck] = [
    Deck(identifier: "1", name: "bí kíp", cards: cards1, lastActivity: nil, folderID: "1"),
    Deck(identifier: "2", name: "từ vựng nấu ăn", cards: cards, lastActivity: nil, folderID: "1")
]

//create Folder
let folders : [Folder] = [Folder(identifier: "1", name: "default1", decks: decks)]
