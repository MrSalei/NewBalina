//
//  ViewControllerComposer.swift
//  NewBalina
//
//  Created by Илья Салей on 24.06.23.
//

import UIKit

final class ViewControllerComposer {
    
    static func composedWith() -> ViewController {
        let remote = BalinaRemote()
        let repository = BalinaRepository(remote: remote)
        
        let viewModel = ViewControllerViewModel(repository: repository)
        let viewController = ViewController(viewModel: viewModel)
        
        viewController.onShowAlert = { [weak viewController] message in
            let alertController = UIAlertController(title: "Attention!", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { [weak alertController] (action) in
                alertController?.dismiss(animated: true)
            }
            alertController.addAction(okAction)
            viewController?.present(alertController, animated: true, completion: nil)
        }
        
        return viewController
    }
}
