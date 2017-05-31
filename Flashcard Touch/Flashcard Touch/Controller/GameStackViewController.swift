//
//  GameStackViewController.swift
//  Flashcard Touch
//
//  Created by Nham Que Huy on 5/29/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

import UIKit
import Koloda

private var numberOfCards: Int = 5

class GameStackViewController: UIViewController {
    
    
    @IBOutlet weak var kolodaView: KolodaView!
    
    var displayingTerm = true
    var originalCards:[Card] = []
    var currentCards:[Card] = []
    
    var frontCardView: FlashCardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        currentCards = originalCards
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
    }
    
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        kolodaView.swipe(.left)
    }
    
    @IBAction func reviewButtonTapped(_ sender: UIButton) {
        kolodaView.swipe(.right)
    }
    
    @IBAction func redoButtonTapped(_ sender: UIBarButtonItem) {
        currentCards = originalCards
        kolodaView.resetCurrentCardIndex()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension GameStackViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
    }
    
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        let cardView = koloda.viewForCard(at: index) as! FlashCardView
        let card = currentCards[index]
       
        UIView.transition(with: cardView, duration: 0.4, options: [.transitionFlipFromLeft], animations: {
            cardView.label.text = self.displayingTerm ? card.definition : card.term
        }, completion: nil)
        self.displayingTerm = !self.displayingTerm
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        switch direction {
        case .left:
            currentCards.remove(at: index)
            koloda.removeCardInIndexRange(index ..< index+1, animated: true)
        default:
            break
        }
    }
}

extension GameStackViewController: KolodaViewDataSource {
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return currentCards.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        if let cardView = Bundle.main.loadNibNamed("FlashCardView", owner: self, options: nil)?[0] as? FlashCardView {
            cardView.label.text = currentCards[index].term
            
            cardView.layer.cornerRadius = 20
            cardView.layer.borderWidth = 2
            cardView.layer.borderColor = #colorLiteral(red: 0.6071627736, green: 0.6042224169, blue: 0.6251516938, alpha: 1).cgColor
            
            frontCardView = cardView
            return cardView
        }
        
        return UIView()
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("CardOverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
    
}
