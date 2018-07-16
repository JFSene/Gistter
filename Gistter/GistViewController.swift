//
//  GistViewController.swift
//  Gistter
//
//  Created by Joel Sene on 16/07/18.
//  Copyright © 2018 Joel Sene. All rights reserved.
//

import UIKit

class GistViewController: UIViewController {

	@IBOutlet weak var myWebView: UIWebView!
	var receivedURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()
		title = "Gistter"
		let url = URL (string: receivedURL!)
		let requestObj = URLRequest(url: url!)
		myWebView.loadRequest(requestObj)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func closeReader(_ sender: Any) {
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
