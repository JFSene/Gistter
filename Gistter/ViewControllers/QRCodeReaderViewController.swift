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

		session.startRunning()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	//MARK: - ACTIONS
	@IBAction func closeCameraButtonTapped(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
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
