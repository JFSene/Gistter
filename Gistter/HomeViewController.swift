//
//  HomeViewController.swift
//  Gistter
//
//  Created by Joel Sene on 11/07/18.
//  Copyright © 2018 Joel Sene. All rights reserved.
//

import UIKit
import BarcodeScanner
import p2_OAuth2
import AVFoundation

class HomeViewController: UIViewController {
	//MARK: - OUTLETS
	@IBOutlet weak var dismissButton: UIButton!
	@IBOutlet weak var imageView: UIImageView! {
		didSet {
			imageView.layer.cornerRadius = 20
			imageView.layer.masksToBounds = true
			
		}
	}

	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var numberOfReposLabel: UILabel!
	@IBOutlet weak var numberOfGistsLabel: UILabel!


	var userName: String?
	var numberOfRepos: Int?
	var numberofGists: Int?
	var userImage: UIImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
		imageView.image = userImage
		numberOfGistsLabel.text = String(describing: numberofGists!)
		numberOfReposLabel.text = String(describing: numberOfRepos!)
		userNameLabel.text = userName!


    }

	override var prefersStatusBarHidden : Bool {
		return true
	}

	//MARK: - ACTIONS
	@IBAction func logOutButtonTapped(_ sender: UIButton) {
		LoginViewController.oauth2.forgetTokens()
		dismiss(animated: true, completion: nil)
	}

	@IBAction func callCameraButtonTapped(_ sender: UIButton) {
//		let viewController = makeBarcodeScannerViewController()
//		viewController.title = "Barcode Scanner"
//		present(viewController, animated: true, completion: nil)

		performSegue(withIdentifier: "showCamera", sender: nil)
	}


	private func makeBarcodeScannerViewController() -> BarcodeScannerController {
		let viewController = BarcodeScannerController()
		viewController.codeDelegate = self
		viewController.errorDelegate = self
		viewController.dismissalDelegate = self
		return viewController
	}



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - BarcodeScannerCodeDelegate
extension HomeViewController: BarcodeScannerCodeDelegate {
	func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
		print("Barcode Data: \(code)")
		print("Symbology Type: \(type)")
		controller.dismiss(animated: true, completion: nil)

	}


}

// MARK: - BarcodeScannerErrorDelegate

extension HomeViewController: BarcodeScannerErrorDelegate {
	func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
		print(error)
	}

}

// MARK: - BarcodeScannerDismissalDelegate

extension HomeViewController: BarcodeScannerDismissalDelegate {
	func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
		controller.dismiss(animated: true, completion: nil)
	}
}
