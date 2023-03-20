//
//  NewTableViewCell.swift
//  urlTest
//
//  Created by jiye Yi on 2023/03/20.
//

import UIKit

class NewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var webimage : UIImageView!
    @IBOutlet weak var cellLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        webimage?.image = nil
        cellLabel?.text = nil
        backgroundColor = .systemBackground
    }
}

