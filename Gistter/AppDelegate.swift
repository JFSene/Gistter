//
//  AppDelegate.swift
//  Gistter
//
//  Created by Joel Sene on 11/07/18.
//  Copyright © 2018 Joel Sene. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		return true
	}

	func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
		if "ppoauthapp" == url.scheme {
			if let vc = window?.rootViewController as? LoginViewController {
				vc.oauth2.handleRedirectURL(url)
				return true
			}
		}
		return false
	}



}

