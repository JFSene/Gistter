
//
//  GistService.swift
//  Gistter
//
//  Created by Joel Sene on 13/07/18.
//  Copyright © 2018 Joel Sene. All rights reserved.
//
import Foundation

class GistService: API {

	func getGist(gistCode: String, successCallBack: @escaping(([String:Any]) -> Void), failCallBack: @escaping((String) -> Void)) {
		let url = "\(URLs.URL)\(URLs.singleGist)\(gistCode)"

		request(urlParam: url,
		        parameters: nil, success: { (gistJSON) in
					let gistTest = gistJSON as? [String: Any]
					var response: [String:Any] = [:]
					response = gistTest!

					successCallBack(response)
		}, fail: { (error) in
			failCallBack(error)
		}, requestType: .get)
	}
	
}
