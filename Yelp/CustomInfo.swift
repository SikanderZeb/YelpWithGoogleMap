//
//  CustomInfo.swift
//  Yelp
//
//  Created by Sikander Zeb on 16/5/17.
//  Copyright © 2017 Sikander Zeb. All rights reserved
//

import UIKit

class CustomInfo: UIView {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            thumbImageView.setImageWith(business.imageURL!)
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
