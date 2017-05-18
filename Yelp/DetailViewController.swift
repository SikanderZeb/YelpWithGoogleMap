//
//  DetailViewController.swift
//  Yelp
//
//  Created by Sikander Zeb on 16/5/17.
//  Copyright © 2017 Sikander Zeb. All rights reserved
//

import UIKit

class DetailViewController: UIViewController {

    var business:Business? = nil
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var catagoriesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = business?.name
        distanceLabel.text = business?.distance
        thumbImageView.setImageWith((business?.imageURL!)!)
        reviewsCountLabel.text = "\(business?.reviewCount!) Reviews"
        addressLabel.text = business?.address
        catagoriesLabel.text = business?.categories
        ratingImageView.setImageWith((business?.ratingImageURL!)!)
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
