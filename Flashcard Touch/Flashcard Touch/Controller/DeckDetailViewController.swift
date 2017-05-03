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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalTerm: UILabel!
    var menuView : BTNavigationDropdownMenu!
    //card = struct Card
    var card = Card()
    //cardt = mảng Card
    var cardt:[Card] = []
    
    //cards = mảng string
    var cards:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
//        cardt.removeAll()
        
        self.automaticallyAdjustsScrollViewInsets = false

        // Do any additional setup after loading the view.
        
        var item:[String] = []
        let items = decks
        
        for i in items {
            item.append(i.identifier)
        }
        print(item)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 1.0, green:0.16, blue:0.4, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "Dropdown Menu", items: item as [AnyObject])
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
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
            
            let temp = item[indexPath]
            print(temp)
            
            for i in items {
                if temp == i.identifier {
                    self.cardt = i.cards
                }
            }
            
            print("-------")
            print(self.cardt.count)
            
//            print(decks)
            
            self.totalTerm.text = "\(self.cardt.count)"
            self.tableView.reloadData()
            
        }
        
        self.navigationItem.titleView = menuView
        
        
    }
    
    //chuyển màn hình có dữ liệu
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueEditDeckDetail" {
            let dest = segue.destination as! DeckDetailAddEditViewController
            
            dest.cardt = self.cardt
            print(dest.cardt)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension DeckDetailViewController : UITableViewDelegate, UITableViewDataSource, DeckDetailTableControllerDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //UItableDatasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("hihi")
//        print(cardt.count)
        return cardt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeckDetailTableViewCell", for: indexPath) as! DeckDetailTableViewCell
        let gramma = cardt[indexPath.row]
        //        cell.descriptionLabel.text = table.name
        cell.termLabel.text = gramma.term
        cell.giaiNghiaLabel.text = "\(gramma.definition)"
        
        cell.editingAccessoryType = .disclosureIndicator
        
        
        return cell
    }
    
    //delegate
//    func add(deck: Deck) {
//    }
    
    func edit(card: Card) {
        cardt = [card]
    }
}
