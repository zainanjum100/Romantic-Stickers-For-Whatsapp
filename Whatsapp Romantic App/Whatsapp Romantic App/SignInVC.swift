//
//  SignInVC.swift
//  Whatsapp Romantic App
//
//  Created by ZainAnjum on 10/23/19.
//  Copyright © 2019 WhatsApp. All rights reserved.
//

import UIKit
import GoogleSignIn
class SignInVC: UIViewController, GIDSignInDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        // ...
    }
    @IBAction func googlePlusButtonTouchUpInside(sender: AnyObject) {
        showLoadingAlert()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    @IBAction func skipBtnPressed() {
        let vc = storyboard!.instantiateViewController(withIdentifier: "tabbar") as! tabbar
        vc.isVisit = true
        let navvc = UINavigationController(rootViewController: vc)
        if let window = UIApplication.shared.keyWindow{
            window.rootViewController = navvc
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        let fullName = user.profile.name!
        let dimension = round(120 * UIScreen.main.scale)
        let pic = user.profile.imageURL(withDimension: UInt(dimension))
        ApiService.instance.setName(fullName)
        ApiService.instance.setImgUrl(pic!.description)
        self.dismiss(animated: true) {
            if let window = UIApplication.shared.keyWindow{
                window.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "rootVC")
            }
        }
        
    }
    private func showLoadingAlert() {
        let loadingAlert: UIAlertController = UIAlertController(title: "Please wait.", message: "\n\n", preferredStyle: .alert)
        loadingAlert.addSpinner()
        present(loadingAlert, animated: true, completion: nil)
    }
    
}
class ApiService {
    static let instance = ApiService()
    let defaults = UserDefaults.standard
    var stickerPacks: [StickerPack] = []
    func setName(_ str: String) {
        defaults.set(str, forKey: "name")
    }
    func getName()-> String {
        return defaults.string(forKey: "name") ?? ""
    }
    func setImgUrl(_ str: String) {
        defaults.set(str, forKey: "pic")
    }
    func getImgUrl()-> String {
        return defaults.string(forKey: "pic") ?? ""
    }
    let name : String = UserDefaults.standard.string(forKey: "name") ?? ""
}
import UIKit
let imageCache = NSCache<AnyObject, AnyObject>()

public extension UIImageView {
    func cacheImage(urlString: String){
        let url = URL(string: urlString)
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        guard let imageUrl = url else{ return }
        URLSession.shared.dataTask(with: imageUrl) {
            data, response, error in
            if let response = data {
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: response)
                    imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                    self.image = imageToCache
                }
            }
        }.resume()
    }
}
