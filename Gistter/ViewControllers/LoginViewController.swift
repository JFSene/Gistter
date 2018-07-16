//
//  LoginViewController.swift
//  Gistter
//
//  Created by Joel Sene on 11/07/18.
//  Copyright © 2018 Joel Sene. All rights reserved.
//

import UIKit
import p2_OAuth2
import Alamofire


class LoginViewController: UIViewController {
	//MARK: OUTLETS
	@IBOutlet weak var logoImageView: UIImageView! {
		didSet {
			logoImageView.layer.cornerRadius = 5
		}
	}
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var loginButton: UIButton!

	//MARK: - VARIABLES
	fileprivate var alamofireManager: SessionManager?
	var loader: OAuth2DataLoader?
	var userImage: UIImage?
	var numberOfRepos: Int?
	var numberofGists: Int?
	var userName: String?


	static var oauth2 = OAuth2CodeGrant(settings: [
		"client_id": "8ae913c685556e73a16f",                         // yes, this client-id and secret will work!
		"client_secret": "60d81efcc5293fd1d096854f4eee0764edb2da5d",
		"authorize_uri": "https://github.com/login/oauth/authorize",
		"token_uri": "https://github.com/login/oauth/access_token",
		"scope": "user repo:status",
		"redirect_uris": ["ppoauthapp://oauth/callback"],            // app has registered this scheme
		"secret_in_body": true,                                      // GitHub does not accept client secret in the Authorization header
		"verbose": true,
		] as OAuth2JSON)


	override func viewDidLoad() {
		super.viewDidLoad()

		loginButton.setTitle("Try it Free With ", for: .normal)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

	}


	//MARK: - ACTIONS
	@IBAction func signInEmbedded(_ sender: UIButton?) {
		if LoginViewController.oauth2.isAuthorizing {
			LoginViewController.oauth2.abortAuthorization()
			return
		}

		sender?.setTitle("Authorizing...", for: UIControlState.normal)

		LoginViewController.oauth2.authConfig.authorizeEmbedded = true
		LoginViewController.oauth2.authConfig.authorizeContext = self
		let loader = OAuth2DataLoader(oauth2: LoginViewController.oauth2)
		self.loader = loader


		loader.perform(request: userDataRequest) { response in
			do {
				let json = try response.responseJSON()
				self.didGetUserdata(dict: json, loader: loader)
			}
			catch let error {
				self.didCancelOrFail(error)
			}
		}
	}

	var userDataRequest: URLRequest {
		var request = URLRequest(url: URL(string: "https://api.github.com/user")!)
		request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
		return request
	}

	
	func didGetUserdata(dict: [String: Any], loader: OAuth2DataLoader?) {
		DispatchQueue.main.async {
			if let username = dict["login"] as? String {
				self.userName = username
			}

			if let userGists = dict["public_gists"] as? Int {
				self.numberofGists = userGists
			}

			if let userRespos = dict["public_repos"] as? Int {
				self.numberOfRepos = userRespos
			}


			if let imgURL = dict["avatar_url"] as? String, let url = URL(string: imgURL) {
				self.loadAvatar(from: url, with: loader)
			}

		}
	}

	func didCancelOrFail(_ error: Error?) {
		DispatchQueue.main.async {
			if let error = error {
				print("Authorization went wrong: \(error)")
			}

		}
	}

	func presentHome(_ userImage:UIImage, segueIdentifier: String) {
		self.userImage = userImage
		self.performSegue(withIdentifier: segueIdentifier, sender: nil)

	}




	// MARK: - Avatar

	func loadAvatar(from url: URL, with loader: OAuth2DataLoader?) {
		if let loader = loader {
			loader.perform(request: URLRequest(url: url)) { response in
				do {
					let data = try response.responseData()
					DispatchQueue.main.async {
						self.userImage = UIImage(data: data)
						self.loginButton.setTitle("Try it Free With ", for: .normal)
						self.presentHome(self.userImage!, segueIdentifier: "showHome")
					}
				}
				catch let error {
					print("Failed to load avatar: \(error)")
				}
			}
		}
		else {
			alamofireManager?.request(url).validate().responseData() { response in
				if let data = response.result.value {
					self.presentHome(UIImage(data: data)!, segueIdentifier: "showHome")
				}
				else {
					print("Failed to load avatar: \(response)")
				}
			}
		}
	}


	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let navVC = segue.destination as? UINavigationController {
			if let homeVC = navVC.viewControllers[0] as? HomeViewController {
				homeVC.numberOfRepos = numberOfRepos
				homeVC.numberofGists = numberofGists
				homeVC.userName = userName
				homeVC.userImage = userImage!
			}
		}
	}
}


