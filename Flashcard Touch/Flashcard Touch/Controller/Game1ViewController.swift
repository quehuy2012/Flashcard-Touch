//
//  Game1ViewController.swift
//  Flashcard Touch
//
//  Created by TuanAnhVu on 5/14/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

import UIKit
import GameKit

class Game1ViewController: UIViewController {
    
    var chooseIndex:(first:Int,second:Int) = (-1,-1)
    
    var chooseFrist:Int = -1
    
    var shuffedCardIndex:[(termIndex: Int,definitionIndex :Int)] = []

    //giá trị bộ deck từ deckDetail gửi sang
    var deck:Deck!
    
    //card local
    var localCard:[Card] = []
    
    //biến tạm localCard
    var localCardTemp:[Card] = []
    
    //mảng lưu các phần tử đã được chọn random
    var localCardSave:[Card] = []
    
    //mảng lưu term và defination của localcardsave
    var cardTermAndDefination:[String] = []
    
    //bộ deck tạm
    var deckTemp:Deck!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        localCardTemp = localCard

        
        
        var dem = 0
        
        while dem <= 5 {
            
            if localCardTemp.count <= 0 {
                print(localCardTemp.count)
                break
            }
            
            let temp = randomSerm()
            print(temp)
            
            for (index, legcount) in localCardTemp.enumerated() {
                
                if UInt32(index) == temp {
                    print(legcount.term)
                    
                    for i in localCardTemp {
                        if legcount.term == i.term && legcount.definition == i.definition && legcount.deckID == i.deckID {
                            localCardSave.append(i)
                            print(i.term)
                        }
                    }
                }
                //            for i in deckTemp.cards{
                //                deckTemp.
                //            }
            }
            dem += 1
            localCardTemp.remove(at: Int(temp))
            print(localCardTemp.count)
            print(localCardTemp)
        }
        
        //lưu term va definition vào mảng String
        for i in localCardSave{
            cardTermAndDefination.append(i.term)
            cardTermAndDefination.append(i.definition)
        }
        
        
        for (i,_) in localCardSave.enumerated(){
            let definition:(Int,Int) = (i,i)
            shuffedCardIndex.append(definition)
            
        }
        
        cardTermAndDefination = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cardTermAndDefination) as! [String]
        
        for (index,string) in cardTermAndDefination.enumerated(){
            for (indexsave, card) in localCardSave.enumerated() {
                if string == card.term {
                    shuffedCardIndex[indexsave].termIndex = index
                }
                if string == card.definition{
                    shuffedCardIndex[indexsave].definitionIndex = index
                }
            }
        }
        
        print(shuffedCardIndex)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // [START screen_view_hit_swift]
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Game 1 View Controller")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        // [END screen_view_hit_swift]
    }
    
    
    //random mảng trả về vị trí của phần tử đó trong mảng
    func randomSerm() -> UInt32 {
        let random = arc4random_uniform(UInt32(localCardTemp.count))
        print(random)
        return random
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

extension Game1ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardTermAndDefination.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Game1CollectionViewCell
        
        cell.name.text = cardTermAndDefination[indexPath.row]
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    //event choose collection view cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
        let temp = shuffedCardIndex.count
//        print(temp)
        
        if chooseFrist == -1 {
            chooseFrist = indexPath.row
            print(chooseFrist)
            let cell1 = collectionView.cellForItem(at: indexPath)
            UIView.animate(withDuration: 0.5, animations: {
                cell1?.backgroundColor = UIColor.green
            }, completion: nil)
        }
        else {
            let cell1 = collectionView.cellForItem(at: IndexPath(item: chooseFrist, section: 0))!
            
            let cell = collectionView.cellForItem(at: indexPath)!
            
            UIView.animate(withDuration: 0.5, delay: 0,options: UIViewAnimationOptions.curveEaseOut, animations: {
                cell.backgroundColor = UIColor.green
            }, completion: { (finished) in
                cell1.backgroundColor = UIColor.clear
                cell.backgroundColor = UIColor.clear
                
                
            });
//            UIView.animate(withDuration: 1.0, animations: { 
//                cell.backgroundColor = UIColor.green
//            }, completion: { (finished) in
//                cell1.backgroundColor = UIColor.clear
//                cell.backgroundColor = UIColor.clear
//            });
            for i in self.shuffedCardIndex {
                if (i.termIndex == self.chooseFrist && i.definitionIndex == indexPath.row) || (i.termIndex == indexPath.row && i.definitionIndex == self.chooseFrist) {
                    
                    cell1.isHidden = true
                    cell.isHidden = true
                    self.chooseFrist = -1
                    return
                }
            }

            
            chooseFrist = -1
        }
        
    }
    
    //layout collectionview
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 - 10
        let height = collectionView.frame.height / 4 - 16
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 8, 8, 8)
    }
    
}
