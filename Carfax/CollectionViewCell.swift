//
//  CollectionViewCell.swift
//  Carfax
//
//  Created by Dhrumil Desai on 2021-11-18.
//

import UIKit


class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var yearOutlet: UILabel!
    
    @IBOutlet weak var makeOutlet: UILabel!
    
    @IBOutlet weak var modelOutlet: UILabel!
    
    @IBOutlet weak var trimOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    

    @IBOutlet weak var locationOutlet: UILabel!
    @IBOutlet weak var mileageOutlet: UILabel!
    
    @IBOutlet weak var phoneOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func CallDealer(_ sender: Any) {
        if let url = URL(string: "tel://\(phoneOutlet.text!)"),
        UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
    
