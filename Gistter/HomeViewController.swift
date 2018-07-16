//
//  HomeViewController.swift
//  Gistter
//
//  Created by Joel Sene on 11/07/18.
//  Copyright © 2018 Joel Sene. All rights reserved.
//

import UIKit
import p2_OAuth2
import WebKit
import AVFoundation

class HomeViewController: UIViewController {

	//MARK: - OUTLETS
	@IBOutlet weak var imageView: UIImageView! {
		didSet {
			imageView.layer.cornerRadius = 20
			imageView.layer.masksToBounds = true

		}
	}

	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var numberOfReposLabel: UILabel!
	@IBOutlet weak var numberOfGistsLabel: UILabel!
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var square: UIImageView!

	//MARK: - VARIABLES
	var userName: String?
	var numberOfRepos: Int?
	var numberofGists: Int?
	var userImage: UIImage = UIImage()
	var gistCodeForApiCall:String?
	var modelTest: Files?
	var gistService: GistService = GistService()
	var commentsURL: String?
	var video = AVCaptureVideoPreviewLayer()

	override func viewDidLoad() {
		super.viewDidLoad()
		prepareUI()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.isHidden = true
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.navigationController?.navigationBar.isHidden = false
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
		if simulator! {
			let testURL = "https://api.github.com/gists/90ca35d10ce2f2fff53b7d7596cab39e"
			formatUrlForApiCall(url: testURL)
		} else {
			callCamera()
		}
	}

	//MARK: - Prepare Functions

	func prepareUI() {
			square.image = #imageLiteral(resourceName: "qr-code")
			imageView.image = userImage
			numberOfGistsLabel.text = String(describing: numberofGists!)
			numberOfReposLabel.text = String(describing: numberOfRepos!)
			userNameLabel.text = userName!
	}

	func formatUrlForApiCall(url: String) {
		let excludeFirstRange = url.index(url.startIndex, offsetBy: 29)..<url.endIndex
		gistCodeForApiCall = url[excludeFirstRange]
		getGist(gistCodeForApiCall!)
	}

	func getGist(_ gistCode: String) {
		gistService.getGist(gistCode: gistCode, successCallBack: { (gistJSON) in
			let data = gistJSON["html_url"] as? String
			if data != nil {
				DispatchQueue.main.async {
					self.commentsURL = data
					self.performSegue(withIdentifier: "showComments", sender: self)
				}
			}

		}) { (error) in
			AlertHelper(controller: self).show(message: error)
		}
	}

	//MARK: - Camera calls

	func callCamera() {
		square.image = #imageLiteral(resourceName: "square")
		
		//Create session
		let session = AVCaptureSession()

		//Define capture device
		let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)

		do  {
			let input = try AVCaptureDeviceInput(device: captureDevice)
			session.addInput(input)
		} catch {
			print("ERROR")
		}

		let output = AVCaptureMetadataOutput()
		session.addOutput(output)

		output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
		output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]

		video = AVCaptureVideoPreviewLayer(session: session)
		video.frame = containerView.layer.bounds
		containerView.layer.addSublayer(video)

		self.containerView.bringSubview(toFront: square)
		session.startRunning()
	}

	func closeCamera() {
		containerView.isHidden = true
	}

	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showComments" {
			let commentsVC = segue.destination as?  GistViewController
			commentsVC?.receivedURL = commentsURL
		}

	}
}

//MARK: - AVCapture Delegate
extension HomeViewController: AVCaptureMetadataOutputObjectsDelegate {
	func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {

		if metadataObjects != nil && metadataObjects.count != 0 {
			if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
				if object.type == AVMetadataObjectTypeQRCode {
					self.formatUrlForApiCall(url: object.stringValue)
				}
			}
		}
	}
}
