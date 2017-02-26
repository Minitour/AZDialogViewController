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
            ignDialog()
        case 1:
            editUserDialog()
        case 2:
            reportUserDialog(controller: self)
        default:
            break
        }
    }
    
    
    func ignDialog(){
        let dialogController = AZDialogViewController(title: "IGN", message: "IGN is your destination for gaming, movies, comics and everything you're into. Find the latest reviews, news, videos, and more more.")
        
        dialogController.showSeparator = true
        
        //dialogController.showImage = true
        
        dialogController.imageHandler = { (imageView) in
            imageView.image = #imageLiteral(resourceName: "ign")
            imageView.contentMode = .scaleAspectFill
            return true
        }
        
        dialogController.addAction(AZDialogAction(title: "Subscribe", handler: { (dialog) -> (Void) in
            //dialog.spacing = dialog.spacing + 10
        }))
        
        //let color = #colorLiteral(red: 0.6271930337, green: 0.3653797209, blue: 0.8019730449, alpha: 1) //colorWithHexString("#25d366")
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
            //button.backgroundColor = .red
            button.setImage(#imageLiteral(resourceName: "share"), for: [])
            button.tintColor = .lightGray
            return true
        }
        
        dialogController.rightToolAction = { (button) in
            print("Share function")
        }
        
        dialogController.dismissWithGesture = true
        
        dialogController.dismissWithOutsideTouch = true
        
        dialogController.show(in: self)
    }
    
    func editUserDialog(){
        let dialogController = AZDialogViewController(title: "Antonio Zaitoun", message: "minitour")
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
        
        dialogController.dismissWithGesture = true
        
        dialogController.dismissWithOutsideTouch = true
        
        dialogController.show(in: self)
        
    }
    
    func reportUserDialog(controller: UIViewController){
        let dialogController = AZDialogViewController(title: "Minitour has been blocked.", message: "Let us know your reason for blocking them?")
        dialogController.dismissWithGesture = false
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

