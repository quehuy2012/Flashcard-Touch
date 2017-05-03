//
//  DeckViewController.swift
//  Flashcard Touch
//
//  Created by VictorLuu on 5/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

import UIKit

class DeckViewController: UIViewController {
    
    //MARK: UI Elements
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Local model

    //MARK: UI events
    @IBAction func createDeck_Tapped(_ sender: UIButton) {
        
    }
    
    
    //MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func convertDateToString(_ date:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }
    
    func countCardInDeck(id: String) -> Int{
        var count = 0
        for card in cards{
            card.deckID == id ? (count += 1) : (count += 0)
        }
        return count
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

extension DeckViewController:UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let deck = decks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let nameDeck = cell.viewWithTag(5) as! UILabel
        let dateDeck = cell.viewWithTag(10) as! UILabel
        let countCard = cell.viewWithTag(20) as! UILabel
        
        nameDeck.text = deck.name
        if deck.lastActivity != nil {
            dateDeck.text = convertDateToString(deck.lastActivity!)
        } else{
            let today = Date()
            dateDeck.text = convertDateToString(today)
        }
        countCard.text = "\(countCardInDeck(id: deck.identifier))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "DeckDetail", bundle: nil)
        let detail = sb.instantiateViewController(withIdentifier: "DeckDetailViewController") as! DeckDetailViewController
        detail.idDeck = decks[indexPath.row].identifier
        detail.isInsert = false
        detail.deck = decks[indexPath.row]
        navigationController?.pushViewController(detail, animated: true)

    }
}
