//
//  tabbar.swift
//  Whatsapp Romantic App
//
//  Created by ZainAnjum on 10/23/19.
//  Copyright © 2019 WhatsApp. All rights reserved.
//

import UIKit

class tabbar: UITabBarController {
    var isVisit:Bool = false
    override func viewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC")
        let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC")
        let likesVC = storyboard.instantiateViewController(withIdentifier: "LikesVC")
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInVC")
        
        if isVisit{
            self.viewControllers = [homeVC,likesVC,signInVC]
        }else{
            self.viewControllers = [homeVC,likesVC,profileVC]
        }
        
    }
}
