//
//  QRCodeReaderViewController.swift
//  Gistter
//
//  Created by Joel Sene on 12/07/18.
//  Copyright © 2018 Joel Sene. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

	@IBOutlet weak var closeButton: UIButton!
	var video = AVCaptureVideoPreviewLayer()

	@IBOutlet weak var square: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

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
		video.frame = view.layer.bounds
		view.layer.addSublayer(video)

		self.view.bringSubview(toFront: square)
		self.view.bringSubview(toFront: closeButton)
		session.startRunning()

    }

	func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {

		if metadataObjects != nil && metadataObjects.count != 0
		{
			if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
			{
				if object.type == AVMetadataObjectTypeQRCode
				{
					let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
					alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (nil) in
						UIPasteboard.general.string = object.stringValue
					}))

					present(alert, animated: true, completion: nil)
				}
			}
		}
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
