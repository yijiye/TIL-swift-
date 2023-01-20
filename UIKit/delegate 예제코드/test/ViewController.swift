//
//  ViewController.swift
//  test
//
//  Created by jiye Yi on 2023/01/13.
//

import UIKit

class Point {
    var point: Int = 100
}


class ViewController: UIViewController, UpdatePointDelegate {
    var updatePoint: Point = Point()
    
    @IBOutlet weak var pointLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pointLabel.text = Int(updatePoint.point).description
    }

    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        pointLabel.text = updatePoint.point.description
    }
    
    @IBAction func nextPageButtonTapped(_ sender: UIButton) {
        guard let secondVC = self.storyboard?.instantiateViewController(identifier: "secondViewController") as? SecondViewController else { return }
        secondVC.delegate = self
        present(secondVC, animated: true, completion: nil)
    }
    
}

