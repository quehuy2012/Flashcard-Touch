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
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.4321628213, green: 0.337002188, blue: 0.9065725207, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: deck.name, items: decksName as [AnyObject])
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = #colorLiteral(red: 0.5347885489, green: 0.3542699218, blue: 0.9699434638, alpha: 1)
        menuView.shouldKeepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.white
        menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        menuView.cellTextLabelAlignment = .left // .Center // .Right // .Left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.black
        menuView.maskBackgroundOpacity = 0.3
        
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UI Event
    
    @IBAction func editTapped(_ sender: AnyObject) {
        print("Edit tapped")
        let viewController = DeckDetailAddEditViewController.instantiateFrom(appStoryboard: .DeckDetail)
        viewController.cardt = localCard
        viewController.deck = decks[selectedDeckIndex]
        viewController.delegate = self
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func PlayGame1Button(_ sender: Any) {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
        
        let viewBackground = cell.viewWithTag(10) as UIView!
        let term = cell.viewWithTag(20) as! UILabel
        let definition = cell.viewWithTag(30) as! UILabel
        
        let randomNum:UInt32 = arc4random_uniform(3) + 1
        
        if randomNum%3 == 0{
            viewBackground?.backgroundColor = UIColor.red
        } else if randomNum%3 == 1{
            viewBackground?.backgroundColor = UIColor.green
        } else{
            viewBackground?.backgroundColor = UIColor.purple
        }
        term.textColor = UIColor.white
        term.text = card.term
        definition.text = card.definition
        
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        
        
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
