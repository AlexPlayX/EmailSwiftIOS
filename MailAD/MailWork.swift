//
//  MailWork.swift
//  MailAD
//
//  Created by Алексей on 5/24/19.
//  Copyright © 2019 Алексей. All rights reserved.
//

import UIKit
import Foundation


class MailWor {
    func mailRu(){
        hostnameMRi="imap.mail.ru"
        hostnameMRs="smtp.mail.ru"
    }
    func yandex() {
        hostnameMRi="imap.yandex.ru"
        hostnameMRs="smtp.yandex.ru"
    }
//    let user:UserData = UserData()
   public func mailSent(mailSender:String?, mailTo:String?, messagTxt:String?, hader:String?){

    let smtSession = MCOSMTPSession()
    smtSession.hostname = hostnameMRs
    smtSession.username = usernameMR
    smtSession.password = passwordMR
    smtSession.port = portMRs
    smtSession.authType = MCOAuthType.saslPlain
    smtSession.connectionType = MCOConnectionType.TLS
    smtSession.connectionLogger = {(connectionID, type, data) in
    if data != nil { if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
    { NSLog("Connectionlogger: \(string)") } } }
    let builder = MCOMessageBuilder()
        builder.header.to = [MCOAddress(displayName: "Rool", mailbox: mailTo) as Any]
    builder.header.from = MCOAddress(displayName: mailSender , mailbox: usernameMR)
    builder.header.subject = hader
    builder.htmlBody = messagTxt
    let rfc822Data = builder.data()
    let sendOperation = smtSession.sendOperation(with: rfc822Data!)
    sendOperation?.start { (error) -> Void in if (error != nil)
    { NSLog("Error sending email: \(String(describing: error))") } else { NSLog("Successfully sent email!") } }

    }

    public func inputMails()  {
        
        let imapsession = MCOIMAPSession()
        imapsession.hostname = hostnameMRi
        imapsession.port = portMRi
        imapsession.username = usernameMR
        imapsession.password = passwordMR
        imapsession.connectionType = MCOConnectionType.TLS
        let requestText : MCOIMAPMessagesRequestKind = MCOIMAPMessagesRequestKind.structure
        let requestKind : MCOIMAPMessagesRequestKind = MCOIMAPMessagesRequestKind.ArrayLiteralElement.headers
        let folder : String = "INBOX"
        let uids : MCOIndexSet = MCOIndexSet(range: MCORangeMake(1, UINT64_MAX))
        let fetchOperation : MCOIMAPFetchMessagesOperation = imapsession.fetchMessagesOperation(withFolder: folder, requestKind: requestKind, uids: uids)
        fetchOperation.start { (err, msg, vanished) -> Void in
            let inbox = Array( msg.debugDescription)
            imapsession.fetchMessagesByNumberOperation(withFolder: folder, requestKind: requestText, numbers: uids).start({ (er, msgList, fe )  in
                if(msgList != nil)
                {

                    for i in 0 ... (msgList!.endIndex-1){
                        let msg = msgList![i] as! MCOIMAPMessage
                        let fetch = imapsession.plainTextRenderingOperation(with: msg, folder: folder)
                        fetch?.start({ (textMsg,parse) in
                            if(textMsg != nil)
                            {
                                let upData:Mails = Mails()
                                let text = Array(textMsg!.debugDescription)
                                let mas = self.parsText(text: text)
                                let tupl = self.parsHeaderAndOtherInfo(inbox:inbox)
                                upData.saveMessag(messegHader: tupl.hader[i], massegID: tupl.massID[i], fromMail: tupl.from[i],mass:mas)
                            }
                        })
                    }
                }
            })
        }
    }


    private func parsText(text:[Character])->String{
        var tex: Array<Character> = Array<Character>(text)
        var i = 0
        var textDatCh = String()
        var textDat:String = " "
        while i != (tex.endIndex-1) {
            if tex[i] == "T" && tex[i+1] == "+"{
                var h = i+2
                var o = 0
                while h != (tex.endIndex-2){
                    h+=1
                }
                i+=3
                while i != h-1{

                    if tex[i] == "\\" && text[i+1] == "n" {
                    textDatCh += "\n"
                    i+=2
                    } else {
                        textDatCh+=String(text[i])
                        i+=1
                        o+=1
                    }
                }
                textDat = String(textDatCh)
                textDatCh.removeAll()
            }
            i+=1
        }
        return textDat
    }


    private func parsHeaderAndOtherInfo(inbox:[Character])->(hader:[String],massID:[String],from:[String]){
        var i = 0
        var inbo:Array<Character> = Array<Character>(inbox)
        var header = [Character]()
        var messageID = [Character]()
        var fromID = [Character]()
        var headerAray = [String]()
        var messageIDAr = [String]()
        var fromIDAr = [String]()
        while i != inbo.endIndex {
            if inbo[i] == ">" && inbo[i+1] == ">" {
                var h = i-2
                var o = 0
                while inbo[h] != ":"  {
                    h-=1
                }
                h+=1
                while h != i-2{
                    header.insert(inbo[h+1], at: o)
                    h+=1
                    o+=1
                }
                headerAray.append(String(header))
                header.removeAll()
            }
            if inbo[i] == "D" && inbo[i+1] == ":"{
                var h = i+40
                var o = 0
                while (inbo[h] != "F" && inbo[h+1] != "r") == true {
                    h+=1
                }
                i+=2
                while i != h-1{
                    messageID.insert(inbo[i], at: o)
                    i+=1
                    o+=1
                }
                messageIDAr.append(String(messageID))
                messageID.removeAll()
            }
            if inbo[i] == "m" && inbo[i+1] == ":"{
                var h = i+11
                var o = 0
                while inbo[h] != ">"{
                    h+=1
                }
                i+=31
                while i != h{
                    fromID.insert(inbo[i+1], at: o)
                    i+=1
                    o+=1
                }
                fromIDAr.append(String(fromID))
                fromID.removeAll()
            }
            i+=1
        }
        let tuples = (hader:headerAray,massID:messageIDAr,from:fromIDAr)
        return tuples
    }
}
