//
//  DeckDetailViewControllerTableViewCell.swift
//  Flashcard Touch
//
//  Created by TuanAnhVu on 5/23/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

import UIKit
import SwipeCellKit

class DeckDetailViewControllerTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var viewScreen: UIView!
    @IBOutlet weak var definition: UILabel!
    @IBOutlet weak var markImageView: UIImageView!
    
    var mark = false {
        didSet {
            markImageView.image = mark ? #imageLiteral(resourceName: "Mark") : #imageLiteral(resourceName: "Unmark")
        }
    }
    
    func setMark(_ mark: Bool, animated: Bool) {
        self.mark = mark
        
        if (animated) {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseIn], animations: {
                self.markImageView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            }, completion: { (finsihed) in
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: { 
                    self.markImageView.transform = CGAffineTransform.identity
                }, completion: nil)
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        viewScreen.layer.cornerRadius = 15
//        let f = contentView.frame
//        let fr = UIEdgeInsetsInsetRect(f, UIEdgeInsetsMake(10, 10, 10, 10))
//        contentView.frame = fr
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
