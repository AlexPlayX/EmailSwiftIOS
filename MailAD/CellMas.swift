//
//  CellMas.swift
//  MailAD
//
//  Created by Алексей on 5/29/19.
//  Copyright © 2019 Алексей. All rights reserved.
//

import Foundation
import UIKit

class CellMas: UITableViewCell{
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var sub: UILabel!
}
