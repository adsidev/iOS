//
//  dashBoardCollectionViewCell.swift
//  Limitless
//
//  Created by Jayprakash Kumar on 12/5/16.
//  Copyright © 2016 CNBT. All rights reserved.
//

import UIKit

class dashBoardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var subjectImage: UIImageView!
    @IBOutlet weak var lockUnLockImage: UIImageView!
    @IBOutlet weak var subjectName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.autoresizingMask.insert(.flexibleHeight)
        self.contentView.autoresizingMask.insert(.flexibleWidth)
    }
}


