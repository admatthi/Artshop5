//
//  newOnboardingBrandCVC.swift
//  Bottles
//
//  Created by talal ahmad on 11/01/2021.
//  Copyright © 2021 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit

class newOnboardingBrandCVC: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    func setImage(name: String) {
        iconImageView.image = UIImage(named: name)
    }
}
