//
//  TeweetWithoutImageCell.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/10.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit
import Kingfisher

class TimeLineCell: UITableViewCell {

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var vipIconView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var verifiedIconView: UIImageView!
    @IBOutlet weak var picturesCollectionView: UICollectionView! {
        didSet {
        picturesCollectionView.delegate = self
        picturesCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var footerBar: UIImageView!
    @IBOutlet weak var picListHeightCons: NSLayoutConstraint!
    @IBOutlet weak var picListBottomCons: NSLayoutConstraint!
    
    // 图片列表中图片之间的间隙
    let thumbnailMargin: CGFloat = 8
    
    
    var status: Status? {
        didSet {
        setupUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    /// 设置单元格
    func setupUI() {
        self.layoutIfNeeded()
        nameLabel.text = status?.user?.name
        timeLabel.text = status?.created_at
        sourceLabel.text = "来自 \(status!.source!)"
        contentLabel.text = status?.text
        // 头像设置
        avatarView.kf_setImageWithURL(status!.user!.avatarURL)
        avatarView.layer.borderWidth = 0.5
        avatarView.layer.borderColor = UIColor.lightGrayColor().CGColor
        avatarView.layer.cornerRadius = avatarView.bounds.size.width / 2
        avatarView.layer.masksToBounds = true
        // 认证图标设置
        verifiedIconView.image = status?.user?.verifiedIcon
        // 会员图标设置
        vipIconView.image = status?.user?.mbrankIcon
        nameLabel.textColor = vipIconView.image == nil ? UIColor.darkGrayColor() : UIColor.orangeColor()
        if let itemSize = resizePictureCollectionView() {
            self.layoutIfNeeded()
            let layout = (picturesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout)
            layout.itemSize = itemSize
            layout.minimumLineSpacing = thumbnailMargin
            layout.minimumInteritemSpacing = thumbnailMargin
            
        }
        picturesCollectionView.reloadData()
        // 选中背景设置
        let selectedView = UIView(frame: self.bounds)
        selectedView.backgroundColor = UIColor(white: 0.98, alpha: 1)
        self.selectedBackgroundView = selectedView
        
    }
    /**
     调整图片列表的尺寸
     
     - returns: 列表中每张图片的尺寸
     */
    private func resizePictureCollectionView() -> CGSize? {
        var thumbnailWidth: CGFloat = 150
        var thumbnailHeight: CGFloat {
            return thumbnailWidth
        }
        guard let picURLs = status?.thumbnailURLs else {
            picListHeightCons.constant = 0
            picListBottomCons.constant = 0
            return nil
        }
        let picCount = picURLs.count
        switch picCount {
        case 1:
            thumbnailWidth = picturesCollectionView.bounds.width
            picListHeightCons.constant = 150
            picListBottomCons.constant = 8
            return CGSize(width: thumbnailWidth, height: 150)
        case 2:
            thumbnailWidth = (picturesCollectionView.bounds.width - thumbnailMargin) / 2
            picListHeightCons.constant = thumbnailHeight

        case 4:
            thumbnailWidth = (picturesCollectionView.bounds.width - thumbnailMargin) / 2
            picListHeightCons.constant = CGFloat(thumbnailHeight) * 2 + CGFloat(thumbnailMargin)

        default:
            let rowNum = (picCount - 1) / 3 + 1
            thumbnailWidth = (picturesCollectionView.bounds.width - thumbnailMargin * 2) / 3
            picListHeightCons.constant = thumbnailHeight * CGFloat(rowNum) + thumbnailMargin * CGFloat(rowNum-1)

        }
        picListBottomCons.constant = 8
        return CGSize(width: thumbnailWidth, height: thumbnailHeight)
    }
    /// 手动设置行高的方法
    func rowHeightFor(status: Status) -> CGFloat {
        self.status = status
        self.layoutIfNeeded()
        return footerBar.frame.maxY
    }
    
    
}
// MARK: - 图片集合 DateSouce和Delegate
extension TimeLineCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.thumbnailURLs?.count ?? 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PictureCollectionViewCell", forIndexPath: indexPath) as! PictureCollectionViewCell
        cell.pictureURL = self.status?.thumbnailURLs?[indexPath.row]
        return cell
    }
    
}

// MARK: - 图片集合单元格
class PictureCollectionViewCell: UICollectionViewCell {
    var pictureURL: NSURL? {
        didSet {
            imageView.kf_setImageWithURL(pictureURL!)
        }
    }
    @IBOutlet weak var imageView: UIImageView!
}


