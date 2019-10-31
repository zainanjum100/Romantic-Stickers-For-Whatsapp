//
//  ProfileVC.swift
//  Whatsapp Romantic App
//
//  Created by ZainAnjum on 10/23/19.
//  Copyright © 2019 WhatsApp. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        profilePicture.layer.cornerRadius = 60
        DispatchQueue.main.async {
            self.profilePicture.cacheImage(urlString: ApiService.instance.getImgUrl())
            self.nameLabel.text = ApiService.instance.getName()
        }
    }
    @IBAction func logoutBtnTapped() {
        ApiService.instance.setName("")
        if let window = UIApplication.shared.keyWindow{
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "SignInVC")
            vc.title = "Welcome to Romantic Sticker App"
            let navVC = UINavigationController(rootViewController: vc)
            window.rootViewController = navVC
        }
    }
    


}
