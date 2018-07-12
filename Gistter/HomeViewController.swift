//
//  HomeViewController.swift
//  Gistter
//
//  Created by Joel Sene on 11/07/18.
//  Copyright © 2018 Joel Sene. All rights reserved.
//

import UIKit

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

	//MARK: - ACTIONS
	@IBAction func logOutButtonTapped(_ sender: UIButton) {
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
