//
//  ViewController.swift
//  AZDialogViewControllerExample
//
//  Created by Antonio Zaitoun on 26/02/2017.
//  Copyright © 2017 Antonio Zaitoun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let primaryColor = #colorLiteral(red: 0.6271930337, green: 0.3653797209, blue: 0.8019730449, alpha: 1)
    
    let primaryColorDark = #colorLiteral(red: 0.5373370051, green: 0.2116269171, blue: 0.7118118405, alpha: 1)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func click(_ sender: UIButton) {
        switch sender.tag{
        case 0:
            //ignDialog()
            loadingIndicator()
        case 1:
            editUserDialog()
        case 2:
            reportUserDialog(controller: self)
        case 3:
            reportDialog()
        default:
            break
        }
    }
    
    func loadingIndicator(){
        let dialog = AZDialogViewController(title: "Loading...", message: "Logging you in, please wait")
        
        let container = dialog.container
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        dialog.container.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        indicator.startAnimating()
        
        
        dialog.buttonStyle = { (button,height,position) in
            button.setBackgroundImage(UIImage.imageWithColor(self.primaryColorDark), for: .highlighted)
            button.setTitleColor(UIColor.white, for: .highlighted)
            button.setTitleColor(self.primaryColor, for: .normal)
            button.layer.masksToBounds = true
            button.layer.borderColor = self.primaryColor.cgColor
        }
        
        dialog.customViewSizeRatio = 0.2
        dialog.dismissDirection = .none
        dialog.allowDragGesture = false
        dialog.dismissWithOutsideTouch = true
        dialog.show(in: self)
        
        let when = DispatchTime.now() + 3 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            dialog.message = "Preparing..."
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
            dialog.message = "Syncing accounts..."
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            dialog.title = "Ready"
            dialog.message = "Let's get started"
            dialog.image = #imageLiteral(resourceName: "image")
            dialog.customViewSizeRatio = 0
            dialog.addAction(AZDialogAction(title: "Go", handler: { (dialog) -> (Void) in
               dialog.dismiss()
            }))
        }
        
        
    }
    
    func ignDialog(){
        let dialogController = AZDialogViewController(title: "ign", message: "some message")
        
        dialogController.showSeparator = true
        
//        dialogController.imageHandler = { (imageView) in
//            imageView.image = UIImage(named: "ign")
//            imageView.contentMode = .scaleAspectFill
//            return true
//        }
        
        dialogController.addAction(AZDialogAction(title: "Subscribe", handler: { (dialog) -> (Void) in
            //dialog.title = "title"
            //dialog.message = "new message"
            dialog.image = dialog.image == nil ? #imageLiteral(resourceName: "ign") : nil
            //dialog.title = ""
            //dialog.message = ""
            //dialog.customViewSizeRatio = 0.2
            
            
        }))
        
        let container = dialogController.container
        let button = UIButton(type: .system)
        button.setTitle("MY BUTTON", for: [])
        dialogController.container.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        
        dialogController.buttonStyle = { (button,height,position) in
            button.setBackgroundImage(UIImage.imageWithColor(self.primaryColor) , for: .normal)
            button.setBackgroundImage(UIImage.imageWithColor(self.primaryColorDark), for: .highlighted)
            button.setTitleColor(UIColor.white, for: [])
            button.layer.masksToBounds = true
            button.layer.borderColor = self.primaryColor.cgColor
            button.tintColor = .white
            if position == 0 {
                let image = #imageLiteral(resourceName: "ic_bookmark").withRenderingMode(.alwaysTemplate)
                button.setImage(image, for: [])
                button.imageView?.contentMode = .scaleAspectFit
            }
            
            
        }
        
        dialogController.rightToolStyle = { (button) in
            button.setImage(#imageLiteral(resourceName: "share"), for: [])
            button.tintColor = .lightGray
            return true
        }
        
        dialogController.rightToolAction = { (button) in
            print("Share function")
        }
        
        dialogController.dismissDirection = .both
        
        dialogController.dismissWithOutsideTouch = true
        
        dialogController.show(in: self)
    }
    
    func editUserDialog(){
        let dialogController = AZDialogViewController(title: "This is a very long string and I am really bored. whatever mate", message: "minitour")
        dialogController.showSeparator = true
        
        dialogController.addAction(AZDialogAction(title: "Edit Name", handler: { (dialog) -> (Void) in
            dialog.dismiss()
        }))
        
        dialogController.addAction(AZDialogAction(title: "Remove Friend", handler: { (dialog) -> (Void) in
            dialog.dismiss()
        }))
        
        dialogController.addAction(AZDialogAction(title: "Block", handler: { (dialog) -> (Void) in
            //dialog.spacing = 20
        }))
        
        dialogController.cancelButtonStyle = { (button,height) in
            button.tintColor = self.primaryColor
            button.setTitle("CANCEL", for: [])
            return true
            
        }
        
        dialogController.buttonStyle = { (button,height,position) in
            button.setBackgroundImage(UIImage.imageWithColor(self.primaryColorDark), for: .highlighted)
            button.setTitleColor(UIColor.white, for: .highlighted)
            button.setTitleColor(self.primaryColor, for: .normal)
            button.layer.masksToBounds = true
            button.layer.borderColor = self.primaryColor.cgColor
        }
        
        dialogController.dismissDirection = .bottom
        
        dialogController.dismissWithOutsideTouch = true
        
        dialogController.show(in: self)
        
    }
    
    func reportUserDialog(controller: UIViewController){
        let dialogController = AZDialogViewController(title: "Minitour has been blocked.", message: "Let us know your reason for blocking them?")
        dialogController.dismissDirection = .none
        dialogController.dismissWithOutsideTouch = false
        
        dialogController.addAction(AZDialogAction(title: "Annoying", handler: { (dialog) -> (Void) in
            dialog.dismiss()
        }))
        
        dialogController.addAction(AZDialogAction(title: "I don't know them", handler: { (dialog) -> (Void) in
            dialog.dismiss()
        }))
        
        dialogController.addAction(AZDialogAction(title: "Inappropriate Snaps", handler: { (dialog) -> (Void) in
            dialog.dismiss()
        }))
        
        dialogController.addAction(AZDialogAction(title: "Harassing me", handler: { (dialog) -> (Void) in
            dialog.dismiss()
        }))
        
        dialogController.addAction(AZDialogAction(title: "Other", handler: { (dialog) -> (Void) in
            dialog.dismiss()
        }))
        
        dialogController.buttonStyle = { (button,height,position) in
            button.setBackgroundImage(UIImage.imageWithColor(self.primaryColorDark), for: .highlighted)
            button.setTitleColor(UIColor.white, for: .highlighted)
            button.setTitleColor(self.primaryColor, for: .normal)
            button.layer.masksToBounds = true
            button.layer.borderColor = self.primaryColor.cgColor
        }
        
        dialogController.show(in: controller)
    }

    func reportDialog(){
        let dialogController = AZDialogViewController(title: nil, message: nil)
        dialogController.dismissDirection = .bottom
        
        dialogController.dismissWithOutsideTouch = true
        
        let primary = #colorLiteral(red: 0, green: 0.6862745098, blue: 0.9411764706, alpha: 1)
        let primaryDark = #colorLiteral(red: 0.02745098039, green: 0.368627451, blue: 0.3294117647, alpha: 1)
        
        
        dialogController.buttonStyle = { (button,height,position) in
            button.tintColor = primary
            button.layer.masksToBounds = true
            button.setBackgroundImage(UIImage.imageWithColor(primary) , for: .normal)
            button.setBackgroundImage(UIImage.imageWithColor(primaryDark), for: .highlighted)
            button.setTitleColor(UIColor.white, for: [])
            button.layer.masksToBounds = true
            button.layer.borderColor = self.primaryColor.cgColor
            button.layer.borderColor = primary.cgColor
            
            if position == 4 {
                button.setTitleColor(UIColor.white, for: .highlighted)
                button.setBackgroundImage(UIImage.imageWithColor(#colorLiteral(red: 1, green: 0.3005838394, blue: 0.2565174997, alpha: 1)), for: .highlighted)
                button.setBackgroundImage(nil , for: .normal)
                button.setTitleColor(#colorLiteral(red: 1, green: 0.3005838394, blue: 0.2565174997, alpha: 1), for: .normal)
                button.layer.borderColor = #colorLiteral(red: 1, green: 0.3005838394, blue: 0.2565174997, alpha: 1).cgColor
            }
        }
        
        dialogController.cancelButtonStyle = { (button, height) in
            button.tintColor = primary
            button.setTitle("CANCEL", for: [])
            return true
        }
        
        dialogController.addAction(AZDialogAction(title: "Mute", handler: { (dialog) -> (Void) in
            dialog.dismiss()
        }))
        
        dialogController.addAction(AZDialogAction(title: "Group Info", handler: { (dialog) -> (Void) in
            dialog.dismiss()
        }))
        
        dialogController.addAction(AZDialogAction(title: "Export Chat", handler: { (dialog) -> (Void) in
            dialog.dismiss()
        }))
    
        dialogController.addAction(AZDialogAction(title: "Clear Chat", handler: { (dialog) -> (Void) in
            dialog.dismiss()
        }))
        
        dialogController.addAction(AZDialogAction(title: "Exit Chat", handler: { (dialog) -> (Void) in
            dialog.dismiss()
        }))
        
        
        dialogController.show(in: self)
    }
}

extension UIImage {
    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

