//
//  MainStickerCell.swift
//  Whatsapp Romantic App
//
//  Created by ZainAnjum on 02/10/2019.
//  Copyright © 2019 WhatsApp. All rights reserved.
//

import UIKit

class MainStickerCell: UITableViewCell {

    @IBOutlet weak var stickerName: UILabel!
    @IBOutlet weak var stickerImage: UIImageView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var favBtn: UIButton!
    var sticker: Sticker? {
           willSet {
               if newValue !== sticker {
//                   imageView.image = nil
               }
           }
           didSet {
               if oldValue !== sticker {
                   if let currentSticker = sticker {
                       StickerPackManager.queue.async {
                           let image = currentSticker.imageData.image(withSize: CGSize(width: 256, height: 256))
                           DispatchQueue.main.async {
                               if let sticker = self.sticker, currentSticker === sticker {
                                   self.stickerImage.image = image
                               }
                           }
                       }
                   }
               }
           }
       }
    


}
