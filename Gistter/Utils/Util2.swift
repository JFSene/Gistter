//
//  Utils.swift
//  snd_ios
//
//  Created by Dev-06 on 20/03/17.
//  Copyright © 2017 Dev-06. All rights reserved.
//

import UIKit
import SystemConfiguration

class Util {
    static let dateFormatter = DateFormatter()
    static let formatter = NumberFormatter()
    
    static func alertMessage(errorMessage: String, controller: UIViewController, title: String) {
        let alertController = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        controller.present(alertController, animated: true, completion: nil)
    }

    public static func stringParaData(data: String, formato: String) -> Date {
        dateFormatter.dateFormat = formato
        return dateFormatter.date(from: data) ?? Date()
    }
    
    public static func dateParaString(data: Date, formato: String) -> String {
        dateFormatter.dateFormat = formato
        return dateFormatter.string(from: data)
    }
    
    static func validarEmail(email: String) -> Bool {
        if email.isEmpty {
            return false
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    static func apenasNumerosString(texto: String) -> String {
        if texto.isEmpty {
            return ""
        }
        return texto.replacingOccurrences(of: "\\D", with: "", options: .regularExpression, range: texto.startIndex..<texto.endIndex)
    }

	static func getVisibleViewController(rootViewController: UIViewController?) -> UIViewController? {
		var currentViewController = rootViewController

		if currentViewController == nil {
			currentViewController = UIApplication.shared.keyWindow?.rootViewController
		}

		if currentViewController?.presentedViewController == nil {
			return currentViewController
		}

		if let presented = currentViewController?.presentedViewController {
			if presented.isKind(of: UINavigationController.self) {
				let navigationController = presented as! UINavigationController
				return navigationController.viewControllers.last!
			}

			if presented.isKind(of: UITabBarController.self) {
				let tabBarController = presented as! UITabBarController
				return tabBarController.selectedViewController!
			}

			return getVisibleViewController(rootViewController: presented)
		}
		return nil
	}
}
