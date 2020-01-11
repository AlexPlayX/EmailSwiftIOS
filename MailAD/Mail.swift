//
//  Mail.swift
//  MailAD
//
//  Created by Алексей on 5/30/19.
//  Copyright © 2019 Алексей. All rights reserved.
//

import Foundation
import UIKit

class Mail: Mails{
    @IBOutlet var headarMas: UILabel!
    @IBOutlet var fromMas: UILabel!
    @IBOutlet var textMas: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let masseg = massegList[indexTap]
        headarMas.text = masseg.value(forKey: "hader") as? String
        fromMas.text = masseg.value(forKey: "from") as? String
        textMas.text = masseg.value(forKey:"textMessag") as? String
    }
}
