//
//  BaseResponse.swift
//  Gistter
//
//  Created by Joel Sene on 13/07/18.
//  Copyright © 2018 Joel Sene. All rights reserved.
//

import Foundation

class BaseResponse {

	var data: AnyObject?
	var errors: [ErrorModel] = []
	var errorObj: ErrorModel?
	var returnObj: AnyObject?

	init?(json: AnyObject?) {

		guard let jsonDict = json as? NSDictionary else {
			return nil
		}

		if let data = jsonDict["data"] as AnyObject? {
			self.data = data
		}

		if let errors = jsonDict["error"] as? [AnyObject] {
			for JSONerror in errors {
				let errorMessage = ErrorModel(json: JSONerror)
				if errorMessage != nil {
					self.errors.append(errorMessage!)
				}
			}
		}

		if let returnObject = jsonDict as AnyObject? {
			let simpleObj = ErrorModel(json: returnObject)
			if simpleObj?.error != nil {
				self.errorObj = simpleObj
			}
			self.returnObj = jsonDict
		}
	}
}

struct ErrorModel {
	var code: String?
	var message: String?
	var field: String?
	var action: String?
	var error: String?
	var error_description: String?

	init?(json: AnyObject) {
		guard let jsonDict = json as? NSDictionary else {
			return nil;
		}

		self.message = jsonDict["message"] as? String

		if let code = jsonDict["code"] as? String {
			self.code = code
		}

		if let action = jsonDict["action"] as? String {
			self.action = action
		}

		if let field = jsonDict["field"] as? String {
			self.field = field
		}

		if let error = jsonDict["error"] as? String {
			self.error = error
		}

		if let error_description = jsonDict["error_description"] as? String {
			self.error_description = error_description
		}
	}
}

