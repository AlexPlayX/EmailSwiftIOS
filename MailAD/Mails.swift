//
//  Mails.swift
//  MailAD
//
//  Created by Алексей on 5/26/19.
//  Copyright © 2019 Алексей. All rights reserved.
//



import UIKit
import Foundation

import CoreData


class Mails: ViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    var massegList = [UserMasseg]()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return massegList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellMas
        let massegH = massegList[indexPath.row]
        cell.title.text = massegH.value(forKey: "hader") as? String
        cell.sub.text = massegH.value(forKey: "from") as? String
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       indexTap=indexPath.row
        print(indexTap)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if editingStyle == .delete {

            context.delete(massegList[indexPath.row])
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
                massegList = try context.fetch(UserMasseg.fetchRequest())
            } catch let error as NSError {
                print("Could not save\(error),\(error.userInfo)")
            }
            tableView.reloadData()
        }
    }

    func saveMessag(messegHader:String,massegID:String,fromMail:String,mass:String) {
        var flagRepeat:Bool = true
         let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let result = try context.fetch(UserMasseg.fetchRequest())

            if (result.count > 0) {
                for i in 0 ... (result.count-1){
                let mas = result[i] as! NSManagedObject
                    
                    let idData:String! = mas.value(forKey: "id") as? String
                    if  idData == massegID{
                        flagRepeat = false
                    }
                }
            }

        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        if flagRepeat == true {
                let masseg = UserMasseg(entity: UserMasseg.entity(), insertInto: context)
            if flagRepeat == true {
                masseg.setValue(messegHader, forKey: "hader")
                masseg.setValue(massegID, forKey: "id")
                masseg.setValue(fromMail, forKey: "from")
                masseg.setValue(mass, forKey: "textMessag")
                do{
                    try context.save()
                    massegList.append(masseg)
                } catch let error as NSError {
                    print("Could not save\(error),\(error.userInfo)")
                }
            }
        }
    }

    @IBAction func refrash(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        do {
            let result = try context.fetch(UserMasseg.fetchRequest())
            massegList = result as![UserMasseg]
        } catch let error as NSError {
            print("Could not save\(error),\(error.userInfo)")
        }
            let contextf = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            do {
                let result = try contextf.fetch(UserDataLogs.fetchRequest())
                if result.count != 0{
                let mas = result[result.count-1] as! NSManagedObject
                usernameMR = mas.value(forKey: "userMailMR") as! String
                passwordMR = mas.value(forKey: "userPassMR") as! String
                }
            } catch {
                let fetchError = error as NSError
                print(fetchError)
            }
        addMails()
        tableView.reloadData()
    }

    func addMails() {
        let  mailSer : MailWor = MailWor()
        mailSer.inputMails()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.delegate = self
        let mailW: MailWor = MailWor()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        do {
            let result = try context.fetch(UserMasseg.fetchRequest())
            massegList = result as![UserMasseg]
        } catch let error as NSError {
            print("Could not save\(error),\(error.userInfo)")
        }
        let contextf = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let result = try contextf.fetch(UserDataLogs.fetchRequest())
            if result.count != 0{
                let mas = result[result.count-1] as! NSManagedObject
                usernameMR = mas.value(forKey: "userMailMR") as! String
                passwordMR = mas.value(forKey: "userPassMR") as! String
                sistem = mas.value(forKey: "mailSistem") as! String
                switch sistem{
                case "@mail.ru" :mailW.mailRu()
                case "@yandex.ru" : mailW.yandex()
                default : print("Error of up sistemMail;")
                }
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        //        tableView.reloadData()
    }

}



