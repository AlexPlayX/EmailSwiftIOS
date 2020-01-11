//
//  SentMail.swift
//  MailAD
//
//  Created by Алексей on 6/3/19.
//  Copyright © 2019 Алексей. All rights reserved.
//

import Foundation
import UIKit

class SentMail:ViewController{

    @IBOutlet weak var senerMail: UITextField!
    @IBOutlet weak var mailTo: UITextField!
    @IBOutlet weak var massegText: UITextView!
    @IBOutlet weak var headerText: UITextField!

    @IBAction func mailSentBatton(_ sender: UIBarButtonItem) {
        let mailM: MailWor = MailWor()
        mailM.mailSent(mailSender:senerMail.text,mailTo: mailTo.text!, messagTxt: massegText.text!, hader: headerText.text)

    }
}
