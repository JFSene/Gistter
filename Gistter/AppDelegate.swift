//
//  AppDelegate.swift
//  Gistter
//
//  Created by Joel Sene on 11/07/18.
//  Copyright © 2018 Joel Sene. All rights reserved.
//

import UIKit
var simulator: Bool?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		UIApplication.shared.isStatusBarHidden = true
		let barButtonItemAppearance = UIBarButtonItem.appearance()
			barButtonItemAppearance.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.clear], for: .normal)

		#if arch(i386) || arch(x86_64)
			simulator = true
			print("Simulator")
		#else
			simulator = false
			print("DEVICE")

		#endif


		UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.2310060263, green: 0.5919990606, blue: 0.8931849731, alpha: 0.9130458048)
		UINavigationBar.appearance().tintColor = .white
		UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
		UINavigationBar.appearance().isTranslucent = false


		return true
	}

	func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
		if "ppoauthapp" == url.scheme {
			if let vc = window?.rootViewController as? LoginViewController {
				LoginViewController.oauth2.handleRedirectURL(url)
				return true
			}
		}
		return false
	}



}

