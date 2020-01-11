//
//  Auentificate.swift
//  MailAD
//
//  Created by Алексей on 5/29/19.
//  Copyright © 2019 Алексей. All rights reserved.
//

import Foundation
import UIKit

class Authentication:ViewController{
    let upMasseg: Mails = Mails()
    let mailW : MailWor = MailWor()
    //let afte:String
    @IBOutlet weak var swMailSistem: UISegmentedControl!
    @IBOutlet weak var userNameIn: UITextField!
    @IBOutlet weak var userPassIn: UITextField!
    @IBAction func conect(_ sender: UIButton) {
        switch swMailSistem.selectedSegmentIndex {
        case 0 : do {
           mailW.mailRu()
            self.sistem = "@mail.ru"
        }
        case 1 : do {
            mailW.yandex()
            self.sistem = "@yandex.ru"
        }
        default:
            print("Error")
        }
        userPassIn.updateConstraints()
        userPassIn.updateConstraintsIfNeeded()

        usernameMR = userNameIn.text! + sistem
        let i = userPassIn.text
        repeat{
            let i = userPassIn.text
        if i == nil
        {
            sleep(5)
        } else {
            usernameMR = userNameIn.text! + sistem
        login = userNameIn!.text! + sistem
        password = userPassIn!.text!
            passwordMR = userPassIn.text!
        saveData(userLog:login,userpas:password)
            upMasseg.addMails()
        }
        }while i == nil
       // upMasseg.viewWillApp()


    }


    private func saveData(userLog:String,userpas:String){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let userData = UserDataLogs(entity: UserDataLogs.entity(), insertInto: context)
        userData.setValue(userLog, forKey: "userMailMR")
        userData.setValue(userpas, forKey: "userPassMR")
        userData.setValue(sistem, forKey: "mailSistem")

        do{
            try context.save()

        } catch let error as NSError {
            print("Could not save\(error),\(error.userInfo)")
        }
    }
}
