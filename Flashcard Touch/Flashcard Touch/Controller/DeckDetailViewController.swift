//
//  DeckDetailViewController.swift
//  Flashcard Touch
//
//  Created by TuanAnhVu on 4/29/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu

class DeckDetailViewController: UIViewController {
    
    //MARK: UI Elements
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countTerm: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    var menuView : BTNavigationDropdownMenu!
    
    //MARK: Local variable
    var idDeck:String = ""
    var isInsert = false
    var localCard : [Card] = []
    var deck:Deck!
    var selectedDeckIndex = 0
    
    //height for table view cell
    let cellSpacingHeight: CGFloat = 5
    
    //MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        for (index,d) in decks.enumerated() {
            if d.identifier == deck.identifier {
                selectedDeckIndex = index
            }
        }
        
        actionButton.setTitle("Add", for: .normal)
        
        var sum = 0
        for card in cards{
            if card.deckID == idDeck{
                localCard.append(card)
                sum += 1
            }
        }
        countTerm.text = "\(sum) Term"
        
        // Do any additional setup after loading the view.
        let decksName = decks.map{ $0.name }
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.141602397, green: 0.8048137426, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: deck.name, items: decksName as [AnyObject])
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = #colorLiteral(red: 0.141602397, green: 0.8048137426, blue: 1, alpha: 1)
        menuView.shouldKeepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.white
        menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        menuView.cellTextLabelAlignment = .left // .Center // .Right // .Left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.black
        menuView.maskBackgroundOpacity = 0.3
        
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            
            // [START custom_event_swift]
            guard let tracker = GAI.sharedInstance().defaultTracker else { return }
            guard let event = GAIDictionaryBuilder.createEvent(withCategory: "Deck Detail", action: "Switch to other Deck", label: nil, value: nil) else { return }
            tracker.send(event.build() as [NSObject : AnyObject])
            // [END custom_event_swift]
            
            print("Did select item at index: \(indexPath)")
            
            let temp = decks[indexPath]
            print(temp)
            
            self.localCard = temp.cards
            
            print("-------")
            //print(self.cardt.count)
            
            //            print(decks)

            self.countTerm.text = "\(self.localCard.count)"
            self.tableView.reloadData()
            
            self.selectedDeckIndex = indexPath
        }
        
        self.navigationItem.titleView = menuView
        self.navigationController?.navigationBar.tintColor = UIColor.white;
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // [START screen_view_hit_swift]
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Deck Detail View Controller")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        // [END screen_view_hit_swift]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UI Event
    
    @IBAction func editTapped(_ sender: AnyObject) {
        // [START custom_event_swift]
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        guard let event = GAIDictionaryBuilder.createEvent(withCategory: "Deck Detail", action: "Switch to Edit Deck", label: nil, value: nil) else { return }
        tracker.send(event.build() as [NSObject : AnyObject])
        // [END custom_event_swift]
        
        print("Edit tapped")
        let viewController = DeckDetailAddEditViewController.instantiateFrom(appStoryboard: .DeckDetail)
        viewController.cardt = localCard
        viewController.deck = decks[selectedDeckIndex]
        viewController.delegate = self
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func PlayGame1Button(_ sender: Any) {
        // [START custom_event_swift]
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        guard let event = GAIDictionaryBuilder.createEvent(withCategory: "Deck Detail", action: "Switch to Learn Card (Game 1)", label: nil, value: nil) else { return }
        tracker.send(event.build() as [NSObject : AnyObject])
        // [END custom_event_swift]
        
        print("playgame")
        let viewController = Game1ViewController.instantiateFrom(appStoryboard: .ScreenGame1)
        viewController.deck = decks[selectedDeckIndex]
        //truyền mảng local card đang sét của bộ deckID nào đó 
        viewController.localCard = localCard
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DeckDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localCard.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let card = localCard[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeckDetailViewControllerTableViewCell", for: indexPath) as! DeckDetailViewControllerTableViewCell
        
//        let viewBackground = cell.viewWithTag(10) as UIView!
//        let term = cell.viewWithTag(20) as! UILabel
//        let definition = cell.viewWithTag(30) as! UILabel
        
        cell.termLabel.text = card.term
        cell.definition.text = card.definition
        
//        cell.layer.borderWidth = 1
//        cell.layer.cornerRadius = 10
        
        
        return cell
    }
    
}

extension DeckDetailViewController: DeckDetailAddEditViewControllerDelegate {
    func didEndEdit(deck: Deck) {
        localCard = deck.cards
        tableView.reloadData()
        
        navigationController?.popViewController(animated: true)
    }
}
