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
        
        // [START custom_event_swift]
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        guard let event = GAIDictionaryBuilder.createEvent(withCategory: "Deck", action: "Create deck", label: nil, value: nil) else { return }
        tracker.send(event.build() as [NSObject : AnyObject])
        // [END custom_event_swift]
        
    }
    
    
    //MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.141602397, green: 0.8048137426, blue: 1, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // [START screen_view_hit_swift]
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Deck View Controller")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        // [END screen_view_hit_swift]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeckViewControllerTableViewCell", for: indexPath) as! DeckViewControllerTableViewCell
        
//        let nameDeck = cell.viewWithTag(5) as! UILabel
//        let dateDeck = cell.viewWithTag(10) as! UILabel
//        let countCard = cell.viewWithTag(20) as! UILabel
        
//        nameDeck.text = deck.name
        
        cell.nameDeck.text = deck.name
        if deck.lastActivity != nil {
//            cell.userActivity.text = convertDateToString(deck.lastActivity!)
        } else{
            let today = Date()
//            cell.lastActivity.text = convertDateToString(today)
        }
//        cell.count.text = "\(countCardInDeck(id: deck.identifier))"
        
//        cell.layer.borderWidth = 1
//        cell.layer.cornerRadius = 5
//        cell.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // [START custom_event_swift]
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        guard let event = GAIDictionaryBuilder.createEvent(withCategory: "Deck", action: "Switch to Deck Detail Screen", label: nil, value: nil) else { return }
        tracker.send(event.build() as [NSObject : AnyObject])
        // [END custom_event_swift]
        
        let sb = UIStoryboard(name: "DeckDetail", bundle: nil)
        let detail = sb.instantiateViewController(withIdentifier: "DeckDetailViewController") as! DeckDetailViewController
        detail.idDeck = decks[indexPath.row].identifier
        detail.isInsert = false
        detail.deck = decks[indexPath.row]
        navigationController?.pushViewController(detail, animated: true)

    }
}
