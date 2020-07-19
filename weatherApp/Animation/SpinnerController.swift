//
//  SpinnerController.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 04/06/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

import UIKit

final class SpinnerController: UIViewController {
    
    let spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        let horizontalConstraint = spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let widthConstraint = spinner.widthAnchor.constraint(equalToConstant: 100)
        let heightConstraint = spinner.heightAnchor.constraint(equalToConstant: 100)
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    func hide() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func show(addSpinner: SpinnerController ) {
        view.frame = view.frame
        didMove(toParent: self)
    }
}
