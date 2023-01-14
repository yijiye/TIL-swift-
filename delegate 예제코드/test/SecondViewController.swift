//
//  SecondViewController.swift
//  test
//
//  Created by jiye Yi on 2023/01/14.
//

import UIKit

protocol UpdatePointDelegate {
    var updatePoint : Point { get set }
}


class SecondViewController: UIViewController {
    
    var delegate: UpdatePointDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func plusPointButtonTapped(_ sender: UIButton) {
        delegate?.updatePoint.point += 100
//        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
