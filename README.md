# AZDialogViewController
A highly customizable alert dialog controller that mimics Snapchat's alert dialog.

##Usage

Create an instance of AZDialogViewController:
```swift
let dialogController = AZDialogViewController(title: "Antonio Zaitoun", message: "minitour")
```

####Customize:
```swift
dialogController.dismissDirection = .bottom
dialogController.dismissWithOutsideTouch = true
dialogController.showSeparator = false
```

####Add Actions:
```swift
dialogController.addAction(AZDialogAction(title: "Edit Name", handler: { (dialog) -> (Void) in
        //add your actions here.
        dialog.dismiss()
}))
        
dialogController.addAction(AZDialogAction(title: "Remove Friend", handler: { (dialog) -> (Void) in
        //add your actions here.
        dialog.dismiss()
}))
        
dialogController.addAction(AZDialogAction(title: "Block", handler: { (dialog) -> (Void) in
        //add your actions here.
        dialog.dismiss()
}))
```

####Add Image:
```swift
dialogController.imageHandler = { (imageView) in
       imageView.image = UIImage(named: "your_image_here")
       imageView.contentMode = .scaleAspectFill
       return true //must return true, otherwise image won't show.
}
```

####Customize Action Buttons Style:
```swift
dialogController.buttonStyle = { (button,height,position) in
     button.setBackgroundImage(UIImage.imageWithColor(self.primaryColorDark), for: .highlighted)
     button.setTitleColor(UIColor.white, for: .highlighted)
     button.setTitleColor(self.primaryColor, for: .normal)
     button.layer.masksToBounds = true
     button.layer.borderColor = self.primaryColor.cgColor
}
```

####Customize Cancel Button Style:
```swift
dialogController.cancelButtonStyle = { (button,height) in
        button.tintColor = self.primaryColor
        button.setTitle("CANCEL", for: [])
        return true //must return true, otherwise cancel button won't show.
}
```

####Present The dialog:
```swift
dialogController.show(in: self)
//Where self is the current view controller.
```
