//
//  AlertHelper.swift
//  TIM venda cantada
//
//  Created by Joe on 09/04/2018.
//  Copyright © 2018 Joel Sene. All rights reserved.
//

import Foundation
import UIKit

class AlertHelper {
    
    let controller:UIViewController
    
    init(controller:UIViewController) {
        self.controller = controller
    }
    
    func show(message: String = "Erro inesperado.", actionParam: UIAlertAction? = nil) {
        let details = UIAlertController(
            title: "Atenção",
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        let cancel = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.cancel,
            handler: nil
        )
        if (actionParam != nil) {
            details.addAction(actionParam!)
        } else {
            details.addAction(cancel)
        }
        
        controller.present(
            details,
            animated: true,
            completion: nil
        )
    }
}
