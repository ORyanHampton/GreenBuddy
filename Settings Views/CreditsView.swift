//
//  CreditsView.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 2/2/21.
//  Copyright © 2021 O'Ryan Hampton. All rights reserved.
//

import SwiftUI
import MessageUI
import UIKit

struct CreditsView: View {
    var body: some View {
        ZStack{
            Color.themeBackground
            Form{
                Section{
                    VStack{
                        Text("Creator")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                        Text("O'Ryan Hampton")
                    }
                }
                Section{
                    Button(action: {
                        SendEmailViewController().sendEmail(nil)
                    }){
                        Text("Report Bug / Feedback")
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}



class SendEmailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBAction func sendEmail(_ sender: UIButton? = nil) {
        // Modify following variables with your text / recipient
        let recipientEmail = "greenbuddy.app@gmail.com"
        let subject = "Bug Report"
        let body = ""
        
        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            
            present(mail, animated: true)
        
        // Show third party email composer if default Mail app is not present
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView()
    }
}
