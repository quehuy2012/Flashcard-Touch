//
//  DeckViewController.swift
//  Flashcard Touch
//
//  Created by VictorLuu on 5/3/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

import UIKit
import SwipeCellKit
import Firebase
import FirebaseDatabase

class DeckViewController: UIViewController {
    
    var ref:DatabaseReference!
    var mangDictCount:Int = 0
    var decksFirebase = [String]()
    //    var decks = [Deck]()
    var lastActivity:String = ""
    
    var saveCards:[Card] = []
    var UID = ""
    //MARK: UI Elements
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Local model

    //MARK: UI events
    @IBAction func createDeck_Tapped(_ sender: UIButton) {
        
//        // [START custom_event_swift]
//        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
//        guard let event = GAIDictionaryBuilder.createEvent(withCategory: "Deck", action: "Create deck", label: nil, value: nil) else { return }
//        tracker.send(event.build() as [NSObject : AnyObject])
//        // [END custom_event_swift]
        
        let viewController = DeckDetailAddEditViewController.instantiateFrom(appStoryboard: .DeckDetail)
        viewController.isEditDeck = false
        viewController.UID = UID
        navigationController?.pushViewController(viewController, animated: true)
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
        
        decks = []
        
        parseDatabase()
    }
    
    func parseDatabase() {
        ref = Database.database().reference()
        
        //đọc dữ liệu từ uid (event Type : khi thay đổi, khi them, khi di chuyển hay toàn bộ,
        self.ref.child(self.UID).observeSingleEvent(of:.value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String:Any] else {
                return
            }
            //            print(snapshot)
            print(dict)
            print(dict.count)
            
            self.mangDictCount = dict.count
            
            for (index,leg) in dict{
                //                print("\(index) and \(leg)")
                self.decksFirebase.append("\(index) \(leg)")
                
                //tiếp tục parse
                let responseDict = leg as! NSDictionary
                let cards = responseDict["cards"] as? [String:Any]
                self.lastActivity = (responseDict["last activity"] as? String)!
                
                //for trong cards
                for (index,leg) in cards! {
                    print("\(index) and \(leg)")
                    let responseCards = leg as! NSDictionary
                    
                    self.saveCards.append(Card(term: (responseCards["term"] as? String)!, definition: (responseCards["defination"] as? String)!, marked: (responseCards["mark"] as? Bool)!))
                    
                }
                
                //                print(self.saveCards)
                //                print(self.saveCards.count)
                
                
                decks.append(Deck(name: index, cards: self.saveCards, lastActivity: self.GetDateFromString(DateStr: self.lastActivity)
                ))
                //xoá những giá trị đã được lưu vào Decks
                self.saveCards.removeAll()
            }
            print(decks.count)
            
            self.tableView.reloadData()
            
        })
    }
    
    //get string sang date
    func GetDateFromString(DateStr: String)-> Date
    {
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
        let DateArray = DateStr.components(separatedBy: "/")
        let components = NSDateComponents()
        components.year = Int(DateArray[2])!
        components.month = Int(DateArray[1])!
        components.day = Int(DateArray[0])! + 1
        let date = calendar?.date(from: components as DateComponents)
        
        return date!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
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
        cell.delegate = self
//        let nameDeck = cell.viewWithTag(5) as! UILabel
//        let dateDeck = cell.viewWithTag(10) as! UILabel
//        let countCard = cell.viewWithTag(20) as! UILabel
        
//        nameDeck.text = deck.name
        
        cell.nameDeck.text = deck.name
        if deck.lastActivity != nil {
//            cell.userActivity.text = convertDateToString(deck.lastActivity!)
        } else{
            _ = Date()
//            cell.lastActivity.text = convertDateToString(today)
        }
        
        cell.numberReview.text = "\(deck.cards.count)"
//        cell.count.text = "\(countCardInDeck(id: deck.identifier))"
        
//        cell.layer.borderWidth = 1
//        cell.layer.cornerRadius = 5
//        cell.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        // [START custom_event_swift]
//        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
//        guard let event = GAIDictionaryBuilder.createEvent(withCategory: "Deck", action: "Switch to Deck Detail Screen", label: nil, value: nil) else { return }
//        tracker.send(event.build() as [NSObject : AnyObject])
//        // [END custom_event_swift]
        
        let sb = UIStoryboard(name: "DeckDetail", bundle: nil)
        let detail = sb.instantiateViewController(withIdentifier: "DeckDetailViewController") as! DeckDetailViewController
        detail.isInsert = false
        detail.deck = decks[indexPath.row]
        detail.UID = UID
        _ = navigationController?.pushViewController(detail, animated: true)

    }
    
    func myDeleteFunction(childIWantToRemove: String) {
        
        ref.child(UID).child(childIWantToRemove).removeValue { (error, ref) in
            if error != nil {
                print("error \(error)")
            }
        }
    }
}



extension DeckViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .left {
            // Làm edit
            return nil
        }
        else {
            let removedDeck = decks[indexPath.row]
            let deleteAction = SwipeAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
                decks.remove(at: indexPath.row)
                // Xóa firebase ở đây
                self.myDeleteFunction(childIWantToRemove: removedDeck.name)
                
                tableView.reloadData()
            })
            
            deleteAction.hidesWhenSelected = true
            deleteAction.accessibilityLabel = "Delete"
            deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.2655673325, blue: 0.3893191218, alpha: 1)
            
            return [deleteAction]
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .border
        options.buttonSpacing = 11
        
        return options
    }
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.title = descriptor.title()
        action.image = descriptor.image()
        action.backgroundColor = descriptor.color
    }
}
