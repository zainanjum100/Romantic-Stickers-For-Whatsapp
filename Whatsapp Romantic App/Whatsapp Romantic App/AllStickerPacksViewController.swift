//
// Copyright (c) WhatsApp Inc. and its affiliates.
// All rights reserved.
//
// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//

import UIKit
import GoogleMobileAds



class AllStickerPacksViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, GADBannerViewDelegate,GADInterstitialDelegate {

//    @IBOutlet private weak var stickerPacksTableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    var interstitial: GADInterstitial!
    var INTER_ADD_ID = "ca-app-pub-4639632909284359/2038197172"
    var BANNER_ADD_ID = "ca-app-pub-4639632909284359/1108258887"

    private var needsFetchStickerPacks = true
    private var stickerPacks: [StickerPack] = []
    private var selectedIndex: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .automatic
        }
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.alpha = 0.0;
        //stickerPacksTableView.register(UINib(nibName: "StickerPackTableViewCell", bundle: nil), forCellReuseIdentifier: "StickerPackCell")
//        stickerPacksTableView.tableFooterView = UIView(frame: .zero)
        
        self.needsFetchStickerPacks = false
        self.fetchStickerPacks()
        
        interstitial = GADInterstitial(adUnitID: INTER_ADD_ID)
        let request = GADRequest()
        interstitial.load(request)
//        navigationController?.navigationItem.title = "Romantic Stickers"
//        title = "Romantic Stickers"
        
        bannerView.adUnitID = BANNER_ADD_ID
        bannerView.rootViewController = self
        bannerView.adSize = kGADAdSizeSmartBannerPortrait
        bannerView.delegate = self
        bannerView.load(GADRequest())

        
    }
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
    }
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        bannerView.isHidden = true
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/1033173712")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    //create add
    func createAd() -> GADInterstitial {
        let inter = GADInterstitial(adUnitID: INTER_ADD_ID)
        inter.load(GADRequest())
        return inter
    }



    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedIndex = self.selectedIndex {
            tableView.deselectRow(at: selectedIndex, animated: true)
        }
    }


    private func fetchStickerPacks() {
        let loadingAlert: UIAlertController = UIAlertController(title: "Please wait.", message: "\n\n", preferredStyle: .alert)
        loadingAlert.addSpinner()
        present(loadingAlert, animated: true, completion: nil)

        do {
            try StickerPackManager.fetchStickerPacks(fromJSON: StickerPackManager.stickersJSON(contentsOfFile: "contents")) { stickerPacks in
                loadingAlert.dismiss(animated: false, completion: {
                    self.navigationController?.navigationBar.alpha = 1.0;

                    if stickerPacks.count > 1 {
                        self.stickerPacks = stickerPacks
                        for (i,_) in stickerPacks.enumerated(){
                            self.stickerPacks[i].isFav = false
                        }
                        ApiService.instance.stickerPacks = self.stickerPacks
                        self.tableView.reloadData()
                    } else {
//                        self.show(stickerPack: stickerPacks[0], animated: false)
                    }
                })
            }
        } catch StickerPackError.fileNotFound {
            fatalError("sticker_packs.wasticker not found.")
        } catch {
            fatalError(error.localizedDescription)
        }
    }


    // MARK: Tableview

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        cell.favBtn.tag = indexPath.section
        cell.favBtn.addTarget(self, action: #selector(favBtnTapped(_:)), for: .touchUpInside)
        if pack.isFav!{
            cell.favBtn.setImage(UIImage(named: "like_fill"), for: .normal)
        }else{
            cell.favBtn.setImage(UIImage(named: "like_o"), for: .normal)
        }
        
        return cell
    }
    @objc func favBtnTapped(_ sender: UIButton) {
        self.stickerPacks[sender.tag].isFav?.toggle()
        self.tableView.reloadData()
        ApiService.instance.stickerPacks = self.stickerPacks
    }
       // Set the spacing between sections
      func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let headerView = UIView()
           headerView.backgroundColor = UIColor.clear
           return headerView
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return stickerPacks.count
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        let vc = storyboard?.instantiateViewController(withIdentifier: "stickerPackVC") as! StickerPackViewController
        let pack = stickerPacks[indexPath.section]
            vc.title = pack.name
            vc.stickerPack = pack
            vc.navigationItem.hidesBackButton = stickerPacks.count <= 1
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        if (interstitial.isReady) {
            interstitial.present(fromRootViewController: self)
            interstitial = createAd()
        }

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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

    @objc func addButtonTapped(button: UIButton) {
        let loadingAlert: UIAlertController = UIAlertController(title: "Sending to WhatsApp", message: "\n\n", preferredStyle: .alert)
        loadingAlert.addSpinner()
        present(loadingAlert, animated: true, completion: nil)

        stickerPacks[button.tag].sendToWhatsApp { completed in
            loadingAlert.dismiss(animated: true, completion: nil)
        }
    }
}
extension Bool{
    mutating func toggle(){
        self = !self
    }
}
