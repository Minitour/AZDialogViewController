//
//  DialogViewController.swift
//  test2
//
//  Created by Tony Zaitoun on 2/24/17.
//  Copyright © 2017 Crofis. All rights reserved.
//

import Foundation
import UIKit

public typealias ActionHandler = ((AZDialogViewController)->(Void))

open class AZDialogViewController: UIViewController{

    // Title of the dialog.
    fileprivate var mTitle: String?
    
    // Message of the dialog.
    fileprivate var mMessage: String?
    
    // The container that holds the image view.
    fileprivate var imageViewHolder: UIView!
    
    // The image view.
    fileprivate var imageView: UIImageView!
    
    // The Title Label.
    fileprivate var titleLabel: UILabel!
    
    // The message label.
    fileprivate var messageLabel: UILabel!
    
    // The cancel button.
    fileprivate var cancelButton: UIButton!
    
    // The stackview that holds the buttons.
    fileprivate var stackView: UIStackView!
    
    // The seperatorView
    fileprivate var seperatorView: UIView!
    
    fileprivate var leftToolItem: UIButton!
    
    fileprivate var rightToolItem: UIButton!
    
    // The array which holds the actions
    fileprivate var actions: [AZDialogAction?]!
    
    // The primary draggable view.
    fileprivate var baseView: BaseView!
    
    fileprivate var didInitAnimation = false
    
    // Show separator
    open var showSeparator = true
    
    open var dismissWithOutsideTouch = true
    
    open var buttonStyle: ((UIButton,_ height: CGFloat,_ position: Int)->Void)?
    
    open var leftToolStyle: ((UIButton)->Bool)?
    
    open var rightToolStyle: ((UIButton)->Bool)?
    
    open var leftToolAction: ((UIButton)->Void)?
    
    open var rightToolAction: ((UIButton)->Void)?
    
    open var cancelButtonStyle: ((UIButton,CGFloat)->Bool)?
    
    open var imageHandler: ((UIImageView)->Bool)?
    
    open var dismissDirection: AZDialogDismissDirection = .both
    
    open var backgroundAlpha: Float = 0.2
    
    open private (set) var spacing: CGFloat = 0
    
    open private (set) var stackSpacing: CGFloat = 0
    
    open private (set) var sideSpacing: CGFloat = 0
    
    open private (set) var titleFontSize: CGFloat = 0
    
    open private (set) var messageFontSize: CGFloat = 0
    
    open private (set) var buttonHeight: CGFloat = 0
    
    open private (set) var cancelButtonHeight:CGFloat = 0
    
    open private (set) var fontName = "AvenirNext-Medium"
    
    open private (set) var fontNameBold = "AvenirNext-DemiBold"
    
    
    /// The primary fuction to present the dialog.
    ///
    /// - Parameter controller: The View controller in which you wish to present the dialog.
    open func show(in controller: UIViewController){
        let navigationController = FixedNavigationController(rootViewController: self)
        navigationController.isNavigationBarHidden = true
        navigationController.modalPresentationStyle = .overFullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        controller.present(navigationController, animated: false, completion: nil)
    }
    
    /// The primary function to dismiss the dialog.
    ///
    /// - Parameters:
    ///   - animated: Should it dismiss with animation? default is true.
    ///   - completion: Completion block that is called after the controller is dismiss.
    open override func dismiss(animated: Bool = true,completion: (()->Void)?=nil){
        if animated {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.baseView.center.y = self.view.bounds.maxY + (self.baseView.bounds.midY)
                self.view.backgroundColor = .clear
            }, completion: { (complete) -> Void in
                super.dismiss(animated: false, completion: completion)
            })
        }else{
            super.dismiss(animated: false, completion: completion)
        }
    }
    
    
    /// Add an action button to the dialog. Make sure you add the actions before calling the .show() function.
    ///
    /// - Parameter action: The AZDialogAction.
    open func addAction(_ action: AZDialogAction){
        actions.append(action)
    }
    
    override open func loadView() {
        super.loadView()
        
        baseView = BaseView()
        imageViewHolder = UIView()
        imageView = UIImageView()
        stackView = UIStackView()
        titleLabel = UILabel()
        messageLabel = UILabel()
        cancelButton = UIButton(type: .system)
        seperatorView = UIView()
        leftToolItem = UIButton(type: .system)
        rightToolItem = UIButton(type: .system)
        
        if spacing == -1 {spacing = self.view.bounds.height * 0.012}
        if stackSpacing == -1 {stackSpacing = self.view.bounds.height * 0.015}
        let margins = self.view!
        let side = margins.bounds.size.width / 8
        let labelWidth = margins.bounds.width - side * 2 - sideSpacing
        let showImage = imageHandler?(imageView) ?? false
        let imagePadding:CGFloat = 5
        let separatorColor = UIColor(colorLiteralRed: 208/255, green: 211/255, blue: 214/255, alpha: 1)
        
        // Disable translate auto resizing mask into constraints
        
        baseView.translatesAutoresizingMaskIntoConstraints = false
        imageViewHolder.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        leftToolItem.translatesAutoresizingMaskIntoConstraints = false
        rightToolItem.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(baseView)
        baseView.addSubview(imageViewHolder)
        baseView.addSubview(titleLabel)
        baseView.addSubview(seperatorView)
        baseView.addSubview(messageLabel)
        baseView.addSubview(stackView)
        baseView.addSubview(cancelButton)
        imageViewHolder.addSubview(imageView)
        
        // Setup Image View
        
        let imageHolderSize: CGFloat = showImage ? CGFloat(Int((margins.bounds.width - 2 * side) / 3))  : 0
        let imageMultiplier:CGFloat = showImage ? 0.0 : 1.0
        imageViewHolder.layer.cornerRadius = imageHolderSize / 2
        imageViewHolder.layer.masksToBounds = true
        imageViewHolder.backgroundColor = UIColor.white
        imageViewHolder.topAnchor.constraint(equalTo: baseView.topAnchor, constant: -imageHolderSize/3).isActive = true
        imageViewHolder.centerXAnchor.constraint(equalTo: baseView.centerXAnchor, constant: 0).isActive = true
        imageViewHolder.heightAnchor.constraint(equalToConstant: imageHolderSize).isActive = true
        imageViewHolder.widthAnchor.constraint(equalToConstant: imageHolderSize).isActive = true
        
        if showImage {
            imageView.layer.cornerRadius = (imageHolderSize - 2 * imagePadding) / 2
            imageView.layer.masksToBounds = true
            imageView.topAnchor.constraint(equalTo: imageViewHolder.topAnchor, constant: imagePadding).isActive = true
            imageView.rightAnchor.constraint(equalTo: imageViewHolder.rightAnchor, constant: -imagePadding).isActive = true
            imageView.leftAnchor.constraint(equalTo: imageViewHolder.leftAnchor, constant: imagePadding).isActive = true
            imageView.bottomAnchor.constraint(equalTo: imageViewHolder.bottomAnchor, constant: -imagePadding).isActive = true
        }
        
        if titleFontSize == 0 {titleFontSize = self.view.bounds.height * 0.0269}
        // Setup Title Label
        let titleFont = UIFont(name: fontNameBold, size: titleFontSize)
        let titleHeight:CGFloat = mTitle == nil ? 0 : heightForView(mTitle!, font: titleFont!, width: labelWidth)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel.text = mTitle
        titleLabel.font = titleFont
        titleLabel.textAlignment = .center
        titleLabel.topAnchor.constraint(equalTo: imageViewHolder.bottomAnchor, constant: spacing + spacing * imageMultiplier).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: titleHeight).isActive = true
        titleLabel.widthAnchor.constraint(lessThanOrEqualTo: messageLabel.widthAnchor, multiplier: 1.0).isActive = true
        
        // Setup Seperator Line
    
        let seperatorHeight: CGFloat = self.showSeparator ? 0.7 : 0.0
        let seperatorMultiplier: CGFloat = seperatorHeight > 0 ? 1.0 : 0.0
        seperatorView.backgroundColor = separatorColor
        seperatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: spacing * seperatorMultiplier).isActive = true
        seperatorView.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, multiplier: 1.0).isActive = true
        seperatorView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: seperatorHeight).isActive = true
        
        // Setup Message Label
        
        if messageFontSize == 0 {messageFontSize = self.view.bounds.height * 0.0239}
        let labelFont = UIFont(name: fontName, size: messageFontSize)!
        let messageLableHeight:CGFloat = mMessage == nil ? 0 : heightForView(mMessage!, font: labelFont, width: labelWidth)
        let messageLabelMultiplier: CGFloat = messageLableHeight > 0 ? 1.0 : 0.0
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        messageLabel.font = labelFont
        messageLabel.text = mMessage
        messageLabel.textAlignment = .center
        messageLabel.topAnchor.constraint(equalTo: seperatorView.bottomAnchor, constant: spacing * messageLabelMultiplier).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: baseView.rightAnchor,constant: -sideSpacing/2).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: baseView.leftAnchor,constant: sideSpacing/2).isActive = true
        messageLabel.heightAnchor.constraint(equalToConstant: messageLableHeight).isActive = true
        
        // Setup Buttons (StackView)
        if buttonHeight == 0 {buttonHeight = CGFloat(Int(self.view.bounds.height * 0.07))}
        let stackViewSize: Int = self.actions.count * Int(buttonHeight) + (self.actions.count-1) * Int(stackSpacing)
        let stackMultiplier:CGFloat = stackViewSize > 0 ? 1.0 : 0.0
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = stackSpacing
        stackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: spacing * 2 * stackMultiplier).isActive = true
        stackView.rightAnchor.constraint(equalTo: baseView.rightAnchor,constant: -side).isActive = true
        stackView.leftAnchor.constraint(equalTo: baseView.leftAnchor,constant: side).isActive = true
        
        for i in 0 ..< actions.count{
            let button = UIButton(type: .custom)
            let action = actions[i]
            button.isExclusiveTouch = true
            button.setTitle(action?.title, for: [])
            button.setTitleColor(button.tintColor, for: [])
            button.layer.borderColor = button.tintColor.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = buttonHeight/2
            button.titleLabel?.font = UIFont(name: fontName, size: buttonHeight * 0.35)
            self.buttonStyle?(button,buttonHeight,i)
            button.tag = i
            button.addTarget(self, action: #selector(AZDialogViewController.handleAction(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        
        
        // Setup Cancel button
        if cancelButtonHeight == 0 {cancelButtonHeight = self.view.bounds.height * 0.0449}
        cancelButton.setTitle("CANCEL", for: [])
        cancelButton.titleLabel?.font = UIFont(name: fontName, size: cancelButtonHeight * 0.433)
        let showCancelButton = cancelButtonStyle?(cancelButton,cancelButtonHeight) ?? false
        let cancelMultiplier: CGFloat = showCancelButton ? 1.0 : 0.0
        cancelButton.isHidden = (showCancelButton ? cancelButtonHeight : 0) <= 0
        cancelButton.topAnchor.constraint(equalTo: stackView.bottomAnchor,constant: spacing).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: baseView.rightAnchor,constant: -side/2).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: baseView.leftAnchor,constant: side/2).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: baseView.bottomAnchor,constant: -spacing).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: cancelButtonHeight  * cancelMultiplier).isActive = true
        cancelButton.addTarget(self, action: #selector(AZDialogViewController.cancelAction(_:)), for: .touchUpInside)
        
        // Setup Base View
        
        // Elaboration on spacingCalc:
        //
        //      3 * spacing : The space between titleLabel and baseView + space between stackView and cancelButton + space between baseView and cancelButton.
        //      spacing * (seperatorMultiplier + messageLabelMultiplier + 2 * stackMultiplier) : This ranges from 0 to 4.
        //      seperatorMultiplier: 0 if the seperator has no height, thus it will not have spacing.
        //      messageLabelMultiplier: 0 if the messageLabel is empty and has no text which means it has no height thus it has no spacing.
        //      2 * stackMultiplier: 0 if the stack has no buttons. 2 if the stack has atleast 1 button. There is a 2 because the spacing between the stack and other views is 2 * spacing.
        //
        // This gives us a total of 7 if all views are present, or 3 which is the minimum.
        let spacingCalc = 3 * spacing + spacing * (imageMultiplier + seperatorMultiplier + messageLabelMultiplier + 2 * stackMultiplier)
        
        // The baseViewHeight: 
        //                     Total Space Between Views
        //                   + Image Holder half height
        //                   + Title Height 
        //                   + Seperator Height 
        //                   + Message Label Height 
        //                   + Stack View Height
        //                   + Cancel Button Height.
        let baseViewHeight =
              Int(spacingCalc)
            + Int(2 * imageHolderSize/3)
            + Int(titleHeight)
            + Int(seperatorHeight)
            + Int(messageLableHeight)
            + Int(stackViewSize)
            + Int(cancelButtonHeight * cancelMultiplier)
        
        self.baseView.isExclusiveTouch = true
        self.baseView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -side).isActive = true
        self.baseView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: side).isActive = true
        self.baseView.centerYAnchor.constraint(equalTo: (baseView.superview?.centerYAnchor)!,constant: 0).isActive = true
        self.baseView.heightAnchor.constraint(equalToConstant: CGFloat(baseViewHeight)).isActive = true
        
        if leftToolStyle?(leftToolItem) ?? false{
            baseView.addSubview(leftToolItem)
            leftToolItem.topAnchor.constraint(equalTo: baseView.topAnchor, constant: spacing*2).isActive = true
            leftToolItem.leftAnchor.constraint(equalTo: baseView.leftAnchor,constant: spacing*2).isActive = true
            leftToolItem.widthAnchor.constraint(equalTo: leftToolItem.heightAnchor).isActive = true
            leftToolItem.addTarget(self, action: #selector(AZDialogViewController.handleLeftTool(_:)), for: .touchUpInside)
        }
        
        if rightToolStyle?(rightToolItem) ?? false{
            baseView.addSubview(rightToolItem)
            rightToolItem.topAnchor.constraint(equalTo: baseView.topAnchor, constant: spacing*2).isActive = true
            rightToolItem.rightAnchor.constraint(equalTo: baseView.rightAnchor,constant: -spacing*2).isActive = true
            rightToolItem.widthAnchor.constraint(equalTo: rightToolItem.heightAnchor).isActive = true
            rightToolItem.heightAnchor.constraint(equalToConstant: 20).isActive = true
            rightToolItem.addTarget(self, action: #selector(AZDialogViewController.handleRightTool(_:)), for: .touchUpInside)
        }
        
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AZDialogViewController.handleTapGesture(_:))))
        baseView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AZDialogViewController.handleTapGesture(_:))))
        baseView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(AZDialogViewController.handlePanGesture(_:))))
        baseView.layer.cornerRadius = 15
        baseView.layer.backgroundColor = UIColor.white.cgColor
        baseView.isHidden = true
        baseView.lastLocation = self.view.center
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !didInitAnimation{
            didInitAnimation = true
            baseView.center.y = self.view.bounds.maxY + baseView.bounds.midY
            baseView.isHidden = false
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 6.0, options: [], animations: { () -> Void in
                self.baseView.center = (self.baseView.superview?.center)!
                let backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: self.backgroundAlpha)
                self.view.backgroundColor = backgroundColor
                }) { (complete) -> Void in
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Primary initializer
    ///
    /// - Parameters:
    ///   - title: The title that will be set on the dialog.
    ///   - message: The message that will be set on the dialog.
    ///   - spacing: The vertical spacing between views.
    ///   - stackSpacing: The vertical spacing between the buttons.
    ///   - sideSpacing: The spacing on the side of the views (Between the views and the base dialog view)
    ///   - titleFontSize: The title font size.
    ///   - messageFontSize: The message font size.
    ///   - buttonsHeight: The buttons' height.
    ///   - cancelButtonHeight: The cancel button height.
    ///   - fontName: The font name that will be used for the message label and the buttons.
    ///   - boldFontName: The font name that will be used for the title.
    public convenience init(title: String?,
                     message: String?,
                     verticalSpacing spacing: CGFloat = -1,
                     buttonSpacing stackSpacing:CGFloat = 10,
                     sideSpacing: CGFloat = 20,
                     titleFontSize: CGFloat = 0,
                     messageFontSize: CGFloat = 0,
                     buttonsHeight: CGFloat = 0,
                     cancelButtonHeight: CGFloat = 0,
                     fontName: String = "AvenirNext-Medium",
                     boldFontName: String = "AvenirNext-DemiBold"){
        self.init(nibName: nil, bundle: nil)
        
        mTitle = title
        mMessage = message
        self.spacing = spacing
        self.stackSpacing = stackSpacing
        self.sideSpacing = sideSpacing
        self.titleFontSize = titleFontSize
        self.messageFontSize = messageFontSize
        self.buttonHeight = buttonsHeight
        self.cancelButtonHeight = cancelButtonHeight
        self.fontName = fontName
        self.fontNameBold = boldFontName
    }
    
    
    /// Selector method - used to handle the dragging.
    ///
    /// - Parameter sender: The Gesture Recognizer.
    internal func handlePanGesture(_ sender: UIPanGestureRecognizer){
        
        let translation = sender.translation(in: self.view)
        baseView.center = CGPoint(x: baseView.lastLocation.x , y: baseView.lastLocation.y + translation.y)
        
        let returnToCenter:(CGPoint,Bool)->Void = { (finalPoint,animate) in
            if !animate {
                self.baseView.center = finalPoint
                return
            }
            UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2.0, options: [], animations: { () -> Void in
                self.baseView.center = finalPoint
            }, completion: { (complete) -> Void in
            })
        }
        
        let dismissInDirection:(CGPoint)->Void = { (finalPoint) in
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.baseView.center = finalPoint
                self.view.backgroundColor = .clear
            }, completion: { (complete) -> Void in
                self.dismiss(animated: false, completion: nil)
            })
        }
        
        var finalPoint = (baseView.superview?.center)!
        
        if sender.state == .ended{
            
            let velocity = sender.velocity(in: view)
            let mag = sqrtf(Float(velocity.x * velocity.x) + Float(velocity.y * velocity.y))
            let slideMult = mag / 200
            let dismissWithGesture = dismissDirection != .none ? true : false
            
            
            
            if dismissWithGesture && slideMult > 1 {
                //dismiss
                if velocity.y > 0{
                    //dismiss downward
                    if dismissDirection == .bottom || dismissDirection == .both {
                        finalPoint.y = (baseView.superview?.frame.maxY)! + (baseView.bounds.midY)
                        dismissInDirection(finalPoint)
                    }else{
                        returnToCenter(finalPoint,true)
                    }
                }else{
                    
                    //dismiss upward
                    if dismissDirection == .top || dismissDirection == .both {
                        finalPoint.y = -(baseView.bounds.midY)
                        dismissInDirection(finalPoint)
                    }else{
                        returnToCenter(finalPoint,true)
                    }
                }
            }else{
                //return to center
                returnToCenter(finalPoint,true)
            }
        }
        
        if sender.state == .cancelled || sender.state == .failed{
            returnToCenter(finalPoint,false)
        }
        
        
    }
    
    /// Selector method - used to handle view touch.
    ///
    /// - Parameter sender: The Gesture Recognizer.
    internal func handleTapGesture(_ sender: UITapGestureRecognizer){
        if sender.view is BaseView{
            return
        }
        if dismissWithOutsideTouch{
            self.dismiss()
        }
    }
    
    /// Selector method - used when cancel button is clicked.
    ///
    /// - Parameter sender: The cancel button.
    internal func cancelAction(_ sender: UIButton){
        dismiss()
    }
    
    /// Selector method - used when left tool item button is clicked.
    ///
    /// - Parameter sender: The left tool button.
    internal func handleLeftTool(_ sender: UIButton){
        leftToolAction?(sender)
    }
    
    /// Selector method - used when right tool item button is clicked.
    ///
    /// - Parameter sender: The right tool button.
    internal func handleRightTool(_ sender: UIButton){
        rightToolAction?(sender)
    }
    
    
    /// Selector method - used when one of the action buttons are clicked.
    ///
    /// - Parameter sender: Action Button
    internal func handleAction(_ sender: UIButton){
        (actions[sender.tag]!.handler)?(self)
    }
    
    
    fileprivate func setup(){
        actions = [AZDialogAction?]()
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    fileprivate func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.textAlignment = .center
        
        label.sizeToFit()
        return label.frame.height
    }
}

public enum AZDialogDismissDirection{
    case top
    case bottom
    case both
    case none
}

open class AZDialogAction{
    open var title: String?
    open var isEnabled: Bool = true
    open var handler: ActionHandler?
    
    public init(title: String,handler: ActionHandler? = nil){
        self.title = title
        self.handler = handler
    }
}

fileprivate class BaseView: UIView{
    
    var lastLocation = CGPoint(x: 0, y: 0)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastLocation = self.center
        super.touchesBegan(touches, with: event)
    }
}

fileprivate class FixedNavigationController: UINavigationController{
    
    open override var shouldAutorotate: Bool{
        return true
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .portrait
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
}
