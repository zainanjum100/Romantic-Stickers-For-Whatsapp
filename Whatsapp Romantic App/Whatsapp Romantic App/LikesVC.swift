//
//  LikesVC.swift
//  Whatsapp Romantic App
//
//  Created by ZainAnjum on 10/23/19.
//  Copyright © 2019 WhatsApp. All rights reserved.
//

import UIKit

class LikesVC: UITableViewController {

    private var stickerPacks: [StickerPack] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.stickerPacks = ApiService.instance.stickerPacks.filter{$0.isFav!}
        self.tableView.reloadData()
    }
     // MARK: Tableview

      override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }

      override  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 300
        }

       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MainStickerCell
    //        cell.addBtn.tag = indexPath.row
    //        cell.addBtn.addTarget(self, action: #selector(addButtonTapped(button:)), for: .touchUpInside)
            let pack = stickerPacks[indexPath.section]
            cell.sticker = pack.stickers[0]
            cell.stickerName.text = pack.name
            
            cell.bgView.layer.cornerRadius = 8
            cell.bgView.layer.masksToBounds = true

            cell.bgView.layer.masksToBounds = false
            cell.bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.bgView.layer.shadowColor = UIColor.black.cgColor
            cell.bgView.layer.shadowOpacity = 0.23
            cell.bgView.layer.shadowRadius = 4
            cell.favBtn.setImage(UIImage(named: "like_fill"), for: .normal)
            
            return cell
        }
           // Set the spacing between sections
         override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
               return 0
        }
       override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
               let headerView = UIView()
               headerView.backgroundColor = UIColor.clear
               return headerView
        }
       override func numberOfSections(in tableView: UITableView) -> Int {
            return stickerPacks.count
        }
        

       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "stickerPackVC") as! StickerPackViewController
            let pack = stickerPacks[indexPath.section]
                vc.title = pack.name
                vc.stickerPack = pack
                vc.navigationItem.hidesBackButton = stickerPacks.count <= 1
            self.navigationController?.pushViewController(vc, animated: true)
            
            
            

        }

       override func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if let navigationBar = navigationController?.navigationBar {
                let contentInset: UIEdgeInsets = {
                    if #available(iOS 11.0, *) {
                        return scrollView.adjustedContentInset
                    } else {
                        return scrollView.contentInset
                    }
                }()
                if scrollView.contentOffset.y <= -contentInset.top {
                    navigationBar.shadowImage = UIImage()
                } else {
                    navigationBar.shadowImage = nil
                }
            }
        }
  
}
