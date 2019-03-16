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
            //loadingIndicator()
            //imagePreviewDialog()
            //tableViewDialog()
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
    
    
    func imagePreviewDialog(){
        let dialog = AZDialogViewController(title: "Image",message: "Image Description")
        let container = dialog.container
        let imageView = UIImageView(image: #imageLiteral(resourceName: "image"))
        imageView.contentMode = .scaleAspectFit
        container.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        
        dialog.customViewSizeRatio = imageView.image!.size.height / imageView.image!.size.width
        
        dialog.addAction(AZDialogAction(title: "Done") { (dialog) -> (Void) in
            dialog.image = #imageLiteral(resourceName: "ign")
        })
        
        
        dialog.show(in: self)
    }
    
    func loadingIndicator(){
        let dialog = AZDialogViewController(title: "Loading...", message: "Logging you in, please wait")
        
        let container = dialog.container
        let indicator = UIActivityIndicatorView(style: .gray)
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
        
        //dialog.animationDuration = 5.0
        dialog.customViewSizeRatio = 0.2
        dialog.dismissDirection = .none
        dialog.allowDragGesture = false
        dialog.dismissWithOutsideTouch = true
        dialog.show(in: self)
        
        let when = DispatchTime.now() + 3  // change 2 to desired number of seconds
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
               dialog.cancelEnabled = !dialog.cancelEnabled
            }))
            dialog.dismissDirection = .bottom
            dialog.allowDragGesture = true
        }
        
        dialog.cancelButtonStyle = { (button,height) in
            button.tintColor = self.primaryColor
            button.setTitle("CANCEL", for: [])
            return false
        }
        
        
        
        
    }
    
    func ignDialog(){
        let dialogController = AZDialogViewController(title: "IGN",
                                                      message: "IGN is your destination for gaming, movies, comics and everything you're into. Find the latest reviews, news, videos, and more more.")
        
        dialogController.showSeparator = true
        
        dialogController.dismissDirection = .bottom
        
        dialogController.imageHandler = { (imageView) in
            imageView.image = UIImage(named: "ign")
            imageView.contentMode = .scaleAspectFill
            return true
        }
        
        dialogController.addAction(AZDialogAction(title: "Subscribe", handler: { (dialog) -> (Void) in
            //dialog.title = "title"
            //dialog.message = "new message"
            //dialog.image = dialog.image == nil ? #imageLiteral(resourceName: "ign") : nil
            //dialog.title = ""
            //dialog.message = ""
            //dialog.customViewSizeRatio = 0.2
            
            
        }))
        
        //let container = dialogController.container
        //let button = UIButton(type: .system)
        //button.setTitle("MY BUTTON", for: [])
        //dialogController.container.addSubview(button)
        //button.translatesAutoresizingMaskIntoConstraints = false
        //button.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        //button.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        
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

        dialogController.blurBackground = true
        dialogController.blurEffectStyle = .dark

        dialogController.rightToolStyle = { (button) in
            button.setImage(#imageLiteral(resourceName: "share"), for: [])
            button.tintColor = .lightGray
            return true
        }
        
        dialogController.rightToolAction = { (button) in
            print("Share function")
        }
        
        dialogController.dismissWithOutsideTouch = true
        dialogController.show(in: self)
    }
    
    func editUserDialog(){
        let dialogController = AZDialogViewController(title: "Antonio Zaitoun", message: "minitour")
        dialogController.showSeparator = true
        
        dialogController.addAction(AZDialogAction(title: "Edit Name", handler: { (dialog) -> (Void) in
            //dialog.removeAction(at: 0)
            dialog.addAction(AZDialogAction(title: "action") { (dialog) -> (Void) in
               dialog.dismiss()
            })
            
            dialog.contentOffset = self.view.frame.height / 2.0 - dialog.estimatedHeight / 2.0 - 16
            
        }))
        
        dialogController.addAction(AZDialogAction(title: "Remove Friend", handler: { (dialog) -> (Void) in
            dialog.removeAction(at: 1)
        }))
        
        dialogController.addAction(AZDialogAction(title: "Block", handler: { (dialog) -> (Void) in
            //dialog.spacing = 20
            dialog.removeAction(at: 2)
            dialog.contentOffset = self.view.frame.height / 2.0 - dialog.estimatedHeight / 2.0 - 16
        }))
        
        dialogController.cancelButtonStyle = { (button,height) in
            button.tintColor = self.primaryColor
            button.setTitle("CANCEL", for: [])
            return true
            
        }
        
        dialogController.cancelEnabled = true
        
        dialogController.buttonStyle = { (button,height,position) in
            button.setBackgroundImage(UIImage.imageWithColor(self.primaryColorDark), for: .highlighted)
            button.setTitleColor(UIColor.white, for: .highlighted)
            button.setTitleColor(self.primaryColor, for: .normal)
            button.layer.masksToBounds = true
            button.layer.borderColor = self.primaryColor.cgColor
        }
        
        dialogController.dismissDirection = .bottom
        
        dialogController.dismissWithOutsideTouch = true
        
        
        dialogController.contentOffset = self.view.frame.height / 2.0 - dialogController.estimatedHeight / 2.0 - 16
        
        dialogController.show(in: self)
        
    }
    
    func reportUserDialog(controller: UIViewController){
        let dialogController = AZDialogViewController(title: "Minitour has been blocked.",
                                                      message: "Let us know your reason for blocking them?",
                                                      widthRatio: 0.8)
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
            dialog.removeSection(0)
            //dialog.dismiss()
        }))
        
        dialogController.buttonStyle = { (button,height,position) in
            button.setBackgroundImage(UIImage.imageWithColor(self.primaryColorDark), for: .highlighted)
            button.setTitleColor(UIColor.white, for: .highlighted)
            button.setTitleColor(self.primaryColor, for: .normal)
            button.layer.masksToBounds = true
            button.layer.borderColor = self.primaryColor.cgColor
        }

        let imageView = UIImageView(image: #imageLiteral(resourceName: "image"))
        imageView.contentMode = .scaleAspectFill
        imageView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true


        dialogController.show(in: controller) {
            $0.section(view: imageView)
            imageView.superview?.superview?.layer.masksToBounds = true
        }

    }

    func reportDialog(){
        let dialogController = AZDialogViewController(title: nil, message: nil)
        dialogController.dismissDirection = .bottom
        
        dialogController.dismissWithOutsideTouch = true
        
        let primary = #colorLiteral(red: 0.1019607843, green: 0.737254902, blue: 0.6117647059, alpha: 1)
        let primaryDark = #colorLiteral(red: 0.0862745098, green: 0.6274509804, blue: 0.5215686275, alpha: 1)
        
        
        dialogController.buttonStyle = { (button,height,position) in
            button.tintColor = primary
            button.layer.masksToBounds = true
            button.setBackgroundImage(UIImage.imageWithColor(primary) , for: .normal)
            button.setBackgroundImage(UIImage.imageWithColor(primaryDark), for: .highlighted)
            button.setTitleColor(UIColor.white, for: [])
            button.layer.masksToBounds = true
            button.layer.borderColor = self.primaryColor.cgColor
            button.layer.borderColor = primary.cgColor

        }

        dialogController.buttonInit = { index in
            return HighlightableButton()
        }
        
        dialogController.cancelEnabled = true
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

    var tableViewDialogController: AZDialogViewController?

    func tableViewDialog(){
        let dialog = AZDialogViewController(title: "Switch Account", message: nil,widthRatio: 1.0)
        tableViewDialogController = dialog

        dialog.showSeparator = false
        
        let container = dialog.container
        
        dialog.customViewSizeRatio = ( view.bounds.height - 100) / view.bounds.width
        
        let tableView = UITableView(frame: .zero, style: .plain)
        
        container.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        //tableView.bouncesZoom = false
        tableView.bounces = false
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -32).isActive = true
        tableView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true

        dialog.gestureRecognizer.delegate = self
        dialog.dismissDirection = .bottom

        dialog.show(in: self) { dialog in
            dialog.contentOffset = self.view.frame.height / 2.0 - dialog.estimatedHeight / 2.0 + 15
        }
        
    }
    
    @IBAction func fullScreenDialog(_ sender: UIButton) {
        tableViewDialog()
    }
    var items: [String] = {
        var list = [String]()
        for i in 0..<100 {
            list.append("Account \(i)")
        }
        return list
    }()
    
    func handlerForIndex(_ index: Int)->ActionHandler{
        switch index{
        case 0:
            return { dialog in
                print("action for index 0")
            }
        case 1:
            return { dialog in
                print("action for index 1")
            }
        default:
            return {dialog in
                print("default action")
            }
        }
        
    }

    var shouldDismiss: Bool = false
    var velocity: CGFloat = 0.0
    
}



extension ViewController: UITableViewDelegate{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableViewDialogController?.dismiss()
    }


    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let duration = Double(1.0/abs(velocity))
        if scrollView.isAtTop {
            if shouldDismiss {
                tableViewDialogController?.animationDuration = duration
                tableViewDialogController?.dismiss()
            }else {
                tableViewDialogController?.applyAnimatedTranslation(-velocity * 35.0,duration: min(max(duration,0.2),0.4))
            }

        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        shouldDismiss = velocity.y < -3.0
        self.velocity = velocity.y
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = !scrollView.isAtTop

    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        let optionalTableView: UITableView? = otherGestureRecognizer.view as? UITableView

        guard let tableView = optionalTableView,
            let panGesture = gestureRecognizer as? UIPanGestureRecognizer,
            let direction = panGesture.direction
            else { return false }

        if tableView.isAtTop && direction == .down {
            return true
        } else {
            return false
        }
    }
}



extension ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell"){
            cell.textLabel?.text = items[indexPath.row]
            return cell
        }
        return UITableViewCell()
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

class HighlightableButton: UIButton{

    var action: ((UIButton)->Void)? = nil

    convenience init(_ action: ((UIButton)->Void)? = nil ) {
        self.init()
        self.action = action
        addTarget(self, action: #selector(didClick(_:)), for: .touchUpInside)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.737254902, blue: 0.6117647059, alpha: 1)
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }

    override var isHighlighted: Bool{
        set{
            UIView.animate(withDuration: 0.1) { [weak self] in
                self?.alpha = newValue ? 0.5 : 1
                self?.transform = newValue ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
            }
            super.isHighlighted = newValue
        }get{
            return super.isHighlighted
        }
    }

    @objc func didClick(_ sender: UIButton) {
        self.action?(self)
    }
}


public extension UIScrollView {

    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }

    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }

    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }

    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }

}

public enum PanDirection: Int {
    case up, down, left, right
    public var isVertical: Bool { return [.up, .down].contains(self) }
    public var isHorizontal: Bool { return !isVertical }
}

public extension UIPanGestureRecognizer {

    public var direction: PanDirection? {
        let velocity = self.velocity(in: view)
        let isVertical = abs(velocity.y) > abs(velocity.x)
        switch (isVertical, velocity.x, velocity.y) {
        case (true, _, let y) where y < 0: return .up
        case (true, _, let y) where y > 0: return .down
        case (false, let x, _) where x > 0: return .right
        case (false, let x, _) where x < 0: return .left
        default: return nil
        }
    }

}
