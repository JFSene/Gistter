//
//  APIManager.swift
//  Gistter
//
//  Created by Joel Sene on 13/07/18.
//  Copyright © 2018 Joel Sene. All rights reserved.
//

import Foundation
import Alamofire
import PKHUD

class API: NSObject {

	func request(
		urlParam: String,
		parameters: [String : AnyObject]?,
		success:@escaping ((AnyObject?) -> Void),
		fail:@escaping ((String) -> Void),
		requestType: RequestType,
		accessToken:Bool? = false)
	{
		var requestMethod: Alamofire.HTTPMethod?
		var url:String?
		var parameterEncoding: ParameterEncoding = JSONEncoding() as ParameterEncoding
		var headers: [String: String] = [:]

		if accessToken! {
			if let accessTokenStore = UserDefaults.standard.object(forKey: "access_token") as? String {
				headers["Authorization"] = "Bearer \(accessTokenStore)"
			}
		}

		if requestType == .post {
			requestMethod = Alamofire.HTTPMethod.post
			parameterEncoding = URLEncoding.default
			//parameterEncoding = JSONEncoding.default
			url = urlParam
		} else if requestType == .get {
			requestMethod = Alamofire.HTTPMethod.get
			parameterEncoding = URLEncoding.default
			url = urlParam.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
		} else if requestType == .delete {
			requestMethod = Alamofire.HTTPMethod.delete
			parameterEncoding = URLEncoding.default
			url = urlParam
		}

		Alamofire.request(url!,method: requestMethod!,parameters: parameters,encoding: parameterEncoding,headers: headers)
			.responseJSON { response in

				if let status = response.response?.statusCode {

					switch status {

					case 200..<301:
						if let result = response.result.value {
							let baseResponse = BaseResponse(json: result as AnyObject)
							print("baseResponse", baseResponse?.data as AnyObject)
							if baseResponse != nil {
								if let data = baseResponse?.data {
									success(data)
								} else {
									success(baseResponse?.returnObj)
								}
							} else {
								print("baseResponse", baseResponse as AnyObject)
							}
						}
					case 400, 500:
						if let result = response.result.value {
							let baseResponse = BaseResponse(json: result as AnyObject)
							if baseResponse != nil {

								var message: String?

								if let errorCode = baseResponse?.errors[0].code {
									message = errorCode
								}

								if let errorMessage = baseResponse?.errors[0].message {
									message = "\(message!) - \(errorMessage)"
								}

								// TODO: Refact
								if (baseResponse?.errors[0].code == "BN-079") {
									success(baseResponse?.errors[0] as AnyObject)
								} else {
									fail(message!)
								}
							}
						}
					case 401:
						if let result = response.result.value {
							let baseResponse = BaseResponse(json: result as AnyObject)
							if baseResponse != nil {
								if let viewController = Util.getVisibleViewController(rootViewController: nil) as UIViewController? {
									let exitApp = UIAlertAction(
										title: "OK",
										style: UIAlertActionStyle.cancel,
										handler: { (action:UIAlertAction!) in
											exit(0)
									})

									HUD.hide()
									AlertHelper(controller: viewController).show(
										message: (baseResponse?.errorObj?.error)!,
										actionParam: exitApp
									)

								}
							}
						}

					default:
						HUD.hide()
						fail("Ocorreu um erro inesperado, tente novamente.")
					}
				}

				if response.result.error != nil {
					if response.result.error?._code == -1009 {
						HUD.hide() { success in
							if let viewController = Util.getVisibleViewController(rootViewController: nil) as UIViewController? {

								let exitApp = UIAlertAction(
									title: "OK",
									style: UIAlertActionStyle.cancel,
									handler: { (action:UIAlertAction!) in
										exit(0)
								})

								AlertHelper(controller: viewController).show(
									message: "É necessário ter acesso à internet para usar este aplicativo",
									actionParam: exitApp
								)
							}
						}
					}
				}
		}
	}
}

public enum RequestType: String {
	case get
	case post
	case delete
}
