//
//  BannerCollectionViewCell.swift
//  SampleBanner
//
//  Created by Rin on 2022/05/21.
//

import UIKit

final class BannerCollectionViewCell: UICollectionViewCell {

    static let identifier = "BannerCollectionViewCell"
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }

    @IBOutlet private weak var bannerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!

    func configure(title: String, backgroundColor: UIColor) {
        titleLabel.text = title
        bannerView.backgroundColor = backgroundColor
    }
}
