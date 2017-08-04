//
//  DialogViewController.swift
//  test2
//
//  Created by Tony Zaitoun on 2/24/17.
//  Copyright © 2017 Crofis. All rights reserved.
//

import UIKit

public typealias ActionHandler = ((AZDialogViewController)->(Void))

open class AZDialogViewController: UIViewController{

    //MARK: - Private Properties
    
    /// The container that holds the image view.
    fileprivate var imageViewHolder: UIView!
    
    /// The image view.
    fileprivate var imageView: UIImageView!
    
    /// The Title Label.
    fileprivate var titleLabel: UILabel!
    
    /// The message label.
    fileprivate var messageLabel: UILabel!
    
    /// The cancel button.
    fileprivate var cancelButton: UIButton!
    
    /// The stackview that holds the buttons.
    fileprivate var buttonsStackView: UIStackView!
    
    /// The stack that holds all the view
    fileprivate var generalStackView: UIStackView!
    
    /// The seperatorView
    fileprivate var separatorView: UIView!
    
    /// The button on the left
    fileprivate var leftToolItem: UIButton!
    
    /// The button on the right
    fileprivate var rightToolItem: UIButton!
    
    /// The array which holds the actions
    fileprivate var actions: [AZDialogAction?]!
    
    /// The primary draggable view.
    fileprivate var baseView: BaseView!
    
    /// Did finish animating
    fileprivate var didInitAnimation = false
    
    /// The view holder's top anchor constraint
    fileprivate var imageViewHolderConstraint: NSLayoutConstraint!
    
    /// The image view holder's height constraint
    fileprivate var imageViewHolderHeightConstraint: NSLayoutConstraint!
    
    /// The general stack view top constraint
    fileprivate var generalStackViewTopConstraint: NSLayoutConstraint!
    
    /// The cancel button constraint
    fileprivate var cancelButtonHeightConstraint: NSLayoutConstraint!{
        willSet{
            if cancelButtonHeightConstraint != nil { cancelButtonHeightConstraint.isActive = false }
        }didSet{
            cancelButtonHeightConstraint.isActive = true
        }
    }
    
    //The height constraint of the custom view `container`
    fileprivate var customViewHeightAnchor: NSLayoutConstraint!{
        willSet{
            if customViewHeightAnchor != nil { customViewHeightAnchor.isActive = false }
        }didSet{
            customViewHeightAnchor.isActive = true
        }
    }
    
    fileprivate var baseViewCenterYConstraint: NSLayoutConstraint!{
        willSet{
            if baseViewCenterYConstraint != nil {baseViewCenterYConstraint.isActive = false }
        }didSet{
            baseViewCenterYConstraint.isActive = true
        }
    }
    
    // Title of the dialog.
    fileprivate var mTitle: String?{
        didSet{
            if titleLabel != nil,generalStackView != nil {
                titleLabel.text = mTitle
                if mTitle == nil || mTitle?.characters.count == 0{
                    titleLabel.isHidden = true
                    separatorView.isHidden = true
                }else{
                    titleLabel.isHidden = false
                    separatorView.isHidden = false
                }
                animateStackView()
            }
        }
    }
    
    // Message of the dialog.
    fileprivate var mMessage: String?{
        didSet{
            if messageLabel != nil,generalStackView != nil {
                messageLabel.text = mMessage
                if mMessage == nil || mMessage?.characters.count == 0{
                    messageLabel.isHidden = true
                }else{
                    messageLabel.isHidden = false
                }
                animateStackView()
            }
        }
    }
    
    // Helper to get the real device width
    fileprivate var deviceWidth: CGFloat {
        return view.bounds.width < view.bounds.height ? view.bounds.width : view.bounds.height
    }
    
    // Helper to get the real device height
    fileprivate var deviceHeight: CGFloat {
        return view.bounds.width < view.bounds.height ? view.bounds.height : view.bounds.width
    }
    
    //MARK: - Getters
    
    open fileprivate(set) var spacing: CGFloat = -1.0
    
    open fileprivate(set) var stackSpacing: CGFloat = 0.0
    
    open fileprivate(set) var sideSpacing: CGFloat = 20.0
    
    open fileprivate(set) var buttonHeight: CGFloat = 0.0
    
    open fileprivate(set) var cancelButtonHeight:CGFloat = 0.0
    
    open fileprivate(set) var titleFontSize: CGFloat = 0.0
    
    open fileprivate(set) var messageFontSize: CGFloat = 0.0
    
    open fileprivate(set) var fontName: String = "AvenirNext-Medium"
    
    open fileprivate(set) var fontNameBold: String = "AvenirNext-DemiBold"
    
    open fileprivate(set) lazy var container: UIView = UIView()
    
    //MARK: - Public
    
    /// Show separator
    open var showSeparator = true
    
    /// Separator Color
    open var separatorColor: UIColor = UIColor(colorLiteralRed: 208/255, green: 211/255, blue: 214/255, alpha: 1){
        didSet{
            separatorView?.backgroundColor = separatorColor
        }
    }
    
    /// Allow dismiss when touching outside of the dialog (touching the background)
    open var dismissWithOutsideTouch = true
    
    /// Allow users to drag the dialog
    open var allowDragGesture = true
    
    /// Button style closure, called when setting up an action. Where the 1st parameter is a reference to the button, the 2nd is the height of the button and the 3rd is the position of the button (index).
    open var buttonStyle: ((UIButton,_ height: CGFloat,_ position: Int)->Void)?
    
    /// Left Tool Style, is the style (closure) that is called when setting up the left tool item. Make sure to return true to show the item.
    open var leftToolStyle: ((UIButton)->Bool)?
    
    /// Right Tool Style, is the style (closure) that is called when setting up the right tool item. Make sure to return true to show the item.
    open var rightToolStyle: ((UIButton)->Bool)?
    
    /// The action that is triggered when tool is clicked.
    open var leftToolAction: ((UIButton)->Void)?
    
    /// The action that is triggered when tool is clicked.
    open var rightToolAction: ((UIButton)->Void)?
    
    /// The cancel button style. where @UIButton is the refrence to the button, @CGFloat is the height of the button and @Bool is the value you return where true would show the button and false won't.
    open var cancelButtonStyle: ((UIButton,CGFloat)->Bool)?
    
    /// Image handler, used when setting up an image using some sort of process.
    open var imageHandler: ((UIImageView)->Bool)?
    
    /// Dismiss direction [top,bottom,both,none]
    open var dismissDirection: AZDialogDismissDirection = .both
    
    /// Background alpha. default is 0.2
    open var backgroundAlpha: Float = 0.2
    
    /// Animation duration.
    open var animationDuration: TimeInterval = 0.2
    
    /// The offset of the dialog.
    open var contentOffset: CGFloat = 0.0 {
        didSet{
            if let baseView = self.baseView{
                baseViewCenterYConstraint =
                    baseView.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: contentOffset)
                
                let center = self.view.center
                let offset = contentOffset
                UIView.animate(withDuration: animationDuration){
                    baseView.center = CGPoint(x: center.x ,y: center.y + offset)
                }
            }
        }
    }
    
    /// Change the title of the dialog
    open override var title: String?{
        get{
            return mTitle
        }set{
            mTitle = newValue
        }
    }
    
    /// Change the message of the dialog
    open var message: String? {
        get{
            return mMessage
        }set{
            mMessage = newValue
        }
    }
    
    /// Change the height of the custom view
    open var customViewSizeRatio: CGFloat = 0.0{
        didSet{
            customViewHeightAnchor =
                container.heightAnchor
                    .constraint(equalTo: container.widthAnchor, multiplier: customViewSizeRatio)
            
            let alpha: CGFloat = customViewSizeRatio > 0.0 ? 1.0 : 0.0
            animateStackView { [weak self] in
                self?.container.alpha = alpha
            }
        }
    }
    
    /// Change the text of the cancel button
    open var cancelTitle: String = "CANCEL"{
        didSet{
            cancelButton?.setTitle(cancelTitle, for: [])
        }
    }
    
    /// Use this to hide/show the cancel button
    open var cancelEnabled: Bool = false{
        willSet{
            //design the button if possible
            if newValue, cancelButton != nil, cancelButtonHeight != 0  {
                _ = cancelButtonStyle?(cancelButton,cancelButtonHeight)
            }
            
        }
        didSet{
            //safe check if cancel button is not nil
            if cancelButton != nil {
                
                //update the height constraint
                cancelButtonHeightConstraint =
                    cancelButton.heightAnchor
                        .constraint(equalToConstant: cancelButtonHeight * (cancelEnabled ? 1.0 : 0.0))
                
                //animate with alpha
                let alpha: CGFloat = (cancelEnabled ? 1.0 : 0.0)
                
                //copy values for use in closure
                let newValue = cancelEnabled
                if newValue {cancelButton.isHidden = false}
                
                //animate stack view with completion block and additional animations
                animateStackView(completionBlock: { [weak self] in
                    if !newValue {
                        self?.cancelButton.isHidden = true
                    }
                    
                }) {[weak self] in
                    self?.cancelButton?.alpha = alpha
                    
                }
            }
            
            
        }
    }
    
    /// The dialog's image.
    open var image: UIImage?{
        get{
            return imageView?.image
        }set{
            if let image = newValue{
                //not nil
                if let _ = imageView.image {
                    // old value not nil
                    //new value not nil
                    //only update the image
                    imageView?.image = image
                }else {
                    //old nil
                    //new value not nil
                    //update image and constraints
                    imageView?.image = image
                    updateConstraints(showImage: true)
                }
            }else{
                //nil
                if let _ = imageView.image {
                    //old value not nil
                    updateConstraints(showImage: false){ [weak self] in
                        self?.imageView.image = nil
                    }
                }
            }
        }
    }
    
    /// Enables the rubber effect you would see on a scroll view.
    open var rubberEnabled: Bool = true
    
    /// Returns the estimated dialog frame height.
    open var estimatedHeight: CGFloat {
        
        if isViewLoaded{
            return baseView.frame.height
        }
        
        func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat{
            let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.font = font
            label.text = text
            label.textAlignment = .center
            
            label.sizeToFit()
            return label.frame.height
        }
        
        var titleFontSize: CGFloat
        var messageFontSize: CGFloat
        var buttonHeight: CGFloat
        var cancelButtonHeight: CGFloat
        
        let width: CGFloat = UIScreen.main.bounds.width
        let height: CGFloat = UIScreen.main.bounds.height
        let fontNameBold = self.fontNameBold
        let fontName = self.fontName
        let showSeparator = self.showSeparator
        let mTitle = self.mTitle
        let mMessage = self.mMessage
        let spacing = height * 0.012
        let sideSpacing: CGFloat = 20.0
        let showImage = image != nil
        let side: CGFloat = width / 8
        let labelWidth: CGFloat = width - side * 2 - sideSpacing
        let imageHolderSize: CGFloat = showImage ? CGFloat(Int((width - 2 * side) / 3))  : 0
        let imageMultiplier:CGFloat = showImage ? 0.0 : 1.0
        
        titleFontSize = height * 0.0269
        let titleFont = UIFont(name: fontNameBold, size: titleFontSize)
        let titleHeight:CGFloat = mTitle == nil ? 0.0 : heightForView(mTitle!, font: titleFont!, width: labelWidth)
        
        let seperatorHeight: CGFloat = showSeparator ? 0.7 : 0.0
        let seperatorMultiplier: CGFloat = seperatorHeight > 0.0 ? 1.0 : 0.0
        
        messageFontSize = height * 0.0239
        let labelFont = UIFont(name: fontName, size: messageFontSize)!
        let messageLableHeight:CGFloat = mMessage == nil ? 0 : heightForView(mMessage!, font: labelFont, width: labelWidth)
        let messageLabelMultiplier: CGFloat = messageLableHeight > 0 ? 1.0 : 0.0
        
        buttonHeight = CGFloat(Int(height * 0.07))
        let stackViewSize: CGFloat = CGFloat(self.actions.count) * buttonHeight + CGFloat(self.actions.count-1) * (stackSpacing)
        let stackMultiplier:CGFloat = stackViewSize > 0 ? 1.0 : 0.0
        
        cancelButtonHeight = height * 0.0449
        let cancelMultiplier: CGFloat = cancelEnabled ? 1.0 : 0.0
        
        // Elaboration on spacingCalc:
        //
        //      3 * spacing : The space between titleLabel and baseView + space between stackView and cancelButton + space between baseView and cancelButton.
        //      spacing * (seperatorMultiplier + messageLabelMultiplier + 2 * stackMultiplier) : This ranges from 0 to 4.
        //      seperatorMultiplier: 0 if the seperator has no height, thus it will not have spacing.
        //      messageLabelMultiplier: 0 if the messageLabel is empty and has no text which means it has no height thus it has no spacing.
        //      2 * stackMultiplier: 0 if the stack has no buttons. 2 if the stack has atleast 1 button. There is a 2 because the spacing between the stack and other views is 2 * spacing.
        //
        let spacingCalc = 3 * spacing + spacing * (imageMultiplier + seperatorMultiplier + messageLabelMultiplier + 2 * stackMultiplier)
        
        // The baseViewHeight:
        //                     Total Space Between Views
        //                   + Image Holder half height
        //                   + Title Height
        //                   + Seperator Height
        //                   + Message Label Height
        //                   + Stack View Height
        //                   + Cancel Button Height.
        var baseViewHeight:CGFloat = 0.0
        
        baseViewHeight += spacingCalc
        baseViewHeight += (2 * imageHolderSize/3)
        baseViewHeight += titleHeight
        baseViewHeight += seperatorHeight
        baseViewHeight += messageLableHeight
        baseViewHeight += stackViewSize
        baseViewHeight += cancelButtonHeight * cancelMultiplier
        
        return baseViewHeight
    }
    
    /// Add an action button to the dialog. Make sure you add the actions before calling the .show() function.
    ///
    /// - Parameter action: The AZDialogAction.
    open func addAction(_ action: AZDialogAction){
        actions.append(action)
        
        if buttonsStackView != nil{
            let button = setupButton(index: actions.count-1)
            self.buttonsStackView.addArrangedSubview(button)
            //button.frame = buttonsStackView.bounds
            button.center = CGPoint(x: buttonsStackView.bounds.midX,y: buttonsStackView.bounds.maxY)
            animateStackView()
        }
    }
    
    /// Remove a button at a certain index.
    ///
    /// - Parameter index: The index at which you would like to remove the action.
    open func removeAction(at index: Int){
        if actions.count <= index{
            return
        }
        
        actions.remove(at: index)
        
        if buttonsStackView == nil {
            return
        }
        
        for subview in buttonsStackView.arrangedSubviews{
            if subview.tag == index{
                subview.removeFromSuperview()
            }
        }
        
        var i = 0
        for view in buttonsStackView.arrangedSubviews{
            view.tag = i
            i+=1
        }
        
        animateStackView()
    }
    
    /// Remove all actions
    open func removeAllActions(){
        actions.removeAll()
        
        for view in buttonsStackView.arrangedSubviews{
            view.removeFromSuperview()
        }
        
        animateStackView()
    }
    
    /// The primary fuction to present the dialog.
    ///
    /// - Parameter controller: The View controller in which you wish to present the dialog.
    open func show(in controller: UIViewController){
        controller.present(self, animated: false, completion: nil)
    }
    
    
    //MARK: - Overriding methods
    
    /// The primary function to dismiss the dialog.
    ///
    /// - Parameters:
    ///   - animated: Should it dismiss with animation? default is true.
    ///   - completion: Completion block that is called after the controller is dismiss.
    override open func dismiss(animated: Bool = true,completion: (()->Void)?=nil){
        if animated {
            UIView.animate(withDuration: animationDuration, animations: { [weak self] () -> Void in
                if let `self` = self,let baseView = self.baseView,let view = self.view{
                    baseView.center.y = view.bounds.maxY + baseView.bounds.midY
                    view.backgroundColor = .clear
                }
                }, completion: { (complete) -> Void in
                    super.dismiss(animated: false, completion: completion)
            })
        }else{
            super.dismiss(animated: false, completion: completion)
        }
    }
    
    /// Creates the view that the controller manages.
    override open func loadView() {
        super.loadView()
        
        baseView = BaseView()
        generalStackView = UIStackView()
        imageViewHolder = UIView()
        imageViewHolder.backgroundColor = .white
        imageView = UIImageView()
        buttonsStackView = UIStackView()
        titleLabel = UILabel()
        messageLabel = UILabel()
        cancelButton = UIButton(type: .system)
        separatorView = UIView()
        leftToolItem = UIButton(type: .system)
        rightToolItem = UIButton(type: .system)
        
        if spacing == -1 {spacing = deviceHeight * 0.012}
        let showImage = imageHandler?(imageView) ?? false
        
        // Disable translate auto resizing mask into constraints
        baseView.translatesAutoresizingMaskIntoConstraints = false
        generalStackView.translatesAutoresizingMaskIntoConstraints = false
        imageViewHolder.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        leftToolItem.translatesAutoresizingMaskIntoConstraints = false
        rightToolItem.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(baseView)
        
        baseView.addSubview(generalStackView)
        baseView.addSubview(imageViewHolder)
        baseView.addSubview(cancelButton)
        
        generalStackView.addArrangedSubview(titleLabel)
        generalStackView.addArrangedSubview(separatorView)
        generalStackView.addArrangedSubview(messageLabel)
        generalStackView.addArrangedSubview(container)
        generalStackView.addArrangedSubview(buttonsStackView)
        
        imageViewHolder.addSubview(imageView)
        
        
        //setup image
        let imageMultiplier = setupImage(showImage: showImage)
        
        //Setup general stack view
        setupGeneralStackView(imageMultiplier: imageMultiplier)
        
        // Setup Title Label
        setupTitleLabel()
        
        // Setup Seperator Line
        setupSeparator()
        
        // Setup Message Label
        setupMessageLabel()

        //Setup Custom View
        setupContainer()
        
        // Setup Buttons (StackView)
        setupButtonsStack()
        
        // Setup Cancel button
        setupCancelButton()
        
        // Setup Base View
        setupBaseView()

        // Setup Tool Items
        setupToolItems()
        
    }
    
    /// Called after the controller's view is loaded into memory.
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        createGesutre(for: view)
        createGesutre(for: baseView)
        createGesutre(for: container)
        
        baseView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(AZDialogViewController.handlePanGesture(_:))))
        
        baseView.layer.cornerRadius = 15
        baseView.layer.backgroundColor = UIColor.white.cgColor
        baseView.isHidden = true
        baseView.lastLocation = self.view.center
        baseView.lastLocation.y = baseView.lastLocation.y + contentOffset
    }
    
    /// Notifies the view controller that its view was added to a view hierarchy.
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !didInitAnimation{
            didInitAnimation = true
            baseView.center.y = self.view.bounds.maxY + baseView.bounds.midY
            baseView.isHidden = false
            UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 6.0, options: [], animations: { [weak self]() -> Void in
                if let `self` = self {
                    self.baseView.center = self.view.center
                    self.baseView.center.y = self.baseView.center.y + self.contentOffset
                    let backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: self.backgroundAlpha)
                    self.view.backgroundColor = backgroundColor
                }
            })
        }
    }
    
    /// Returns a newly initialized view controller with the nib file in the specified bundle.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    /// Not been implemented
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
    public convenience init(title: String?=nil,
                     message: String?=nil,
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
        
        //if panning is disabled return
        if !allowDragGesture{
            return
        }
        
        //copy current offset
        let contentOffset = self.contentOffset
        
        //copy animation duration
        let animationDuration = self.animationDuration
        
        //get pan translation
        let translation = sender.translation(in: self.view)
        
        let yTranslation: CGFloat
        
        let centerWithOffset = view.center.y + contentOffset
        
        //check if should rubber:
            //view will rubber only if:
            //- rubber is enabled
            //- the view is above the center
            //- dismiss direction is bottom only.
        if rubberEnabled &&
            dismissDirection == .bottom &&
            baseView.center.y + translation.y < centerWithOffset {

            let distanceFromCenter = abs(centerWithOffset - (baseView.lastLocation.y + translation.y))
            let precentage = sqrt(1.0 / (distanceFromCenter + 1.0)) + 0.10
            yTranslation = baseView.lastLocation.y + translation.y * precentage
        }else{
            yTranslation = baseView.lastLocation.y + translation.y
        }
        
        //apply new center
        baseView.center = CGPoint(x: baseView.lastLocation.x , y: yTranslation)
        
        //create `return to center` function.
        let returnToCenter:(CGPoint,Bool)->Void = { [weak self] (finalPoint,animate) in
            var point = finalPoint
            point.y = point.y + contentOffset
            if !animate {
                self?.baseView.center = point
                return
            }
            UIView.animate(withDuration: 0.35,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 2.0,
                           options: [],
                           animations: { [weak self] () -> Void in self?.baseView.center = point },
                           completion: nil)
        }
        
        //create `dismiss in direction` function.
        let dismissInDirection:(CGPoint)->Void = { [weak self] (finalPoint) in
            UIView.animate(withDuration: animationDuration, animations: { () -> Void in
                self?.baseView.center = finalPoint
                self?.view.backgroundColor = .clear
            }, completion: { (complete) -> Void in
                self?.dismiss(animated: false, completion: nil)
            })
        }
        
        //calculate final point, default is center.
        var finalPoint = view.center
        
        //on gesture ended (by user)
        if sender.state == .ended{
            
            //calculate velocity
            let velocity = sender.velocity(in: view)
            
            //calculate magnitude
            let mag = sqrtf(Float(velocity.x * velocity.x) + Float(velocity.y * velocity.y))
            
            //calculate slide multitude
            let slideMult = mag / 200
            
            //check if to dismiss.
            let dismissWithGesture = dismissDirection != .none ? true : false
            
            if dismissWithGesture && slideMult > 1 {
                //dismiss
                if velocity.y > 0{
                    //dismiss downward
                    if dismissDirection == .bottom || dismissDirection == .both {
                        finalPoint.y = view.frame.maxY + baseView.bounds.midY
                        dismissInDirection(finalPoint)
                    }else{
                        returnToCenter(finalPoint,true)
                    }
                }else{
                    
                    //dismiss upward
                    if dismissDirection == .top || dismissDirection == .both {
                        finalPoint.y = -baseView.bounds.midY
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
        if sender.view is BaseView || sender.view == container{
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
    
    /// Setup Image View
    fileprivate func setupImage(showImage: Bool)->CGFloat{
        let imageHolderSize: CGFloat = showImage ? CGFloat(Int((deviceWidth - 2 * deviceWidth / 8) / 3))  : 0
        let imageMultiplier:CGFloat = showImage ? 0.0 : 1.0
        imageViewHolder.layer.cornerRadius = imageHolderSize / 2
        imageViewHolder.layer.masksToBounds = true
        imageViewHolder.backgroundColor = UIColor.white
        
        imageViewHolder.centerXAnchor.constraint(equalTo: baseView.centerXAnchor, constant: 0).isActive = true
        
        imageViewHolder.widthAnchor.constraint(equalTo: imageViewHolder.heightAnchor).isActive = true
        
        imageViewHolderConstraint = imageViewHolder.topAnchor.constraint(equalTo: baseView.topAnchor, constant: -imageHolderSize/3)
        imageViewHolderConstraint.isActive = true
        
        imageViewHolderHeightConstraint = imageViewHolder.heightAnchor.constraint(equalToConstant: imageHolderSize)
        imageViewHolderHeightConstraint.isActive = true

        imageView.layer.cornerRadius = (imageHolderSize - 2 * 5) / 2
        imageView.layer.masksToBounds = true
        
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageViewHolder.widthAnchor, multiplier: 0.90).isActive = true
        imageView.centerXAnchor.constraint(equalTo: imageViewHolder.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: imageViewHolder.centerYAnchor).isActive = true
        
        return imageMultiplier
    }
    
    /// Setup general stack view
    fileprivate func setupGeneralStackView(imageMultiplier: CGFloat){
        generalStackView.distribution = .fill
        generalStackView.alignment = .center
        generalStackView.axis = .vertical
        generalStackView.spacing = stackSpacing
        
        generalStackView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        generalStackView.leftAnchor.constraint(equalTo: baseView.leftAnchor,constant: sideSpacing/2).isActive = true
        generalStackView.rightAnchor.constraint(equalTo: baseView.rightAnchor,constant: -sideSpacing/2).isActive = true
        
        generalStackViewTopConstraint =
            generalStackView.topAnchor.constraint(equalTo: imageViewHolder.bottomAnchor, constant: spacing + spacing * imageMultiplier)
        generalStackViewTopConstraint.isActive = true
    }
    
    /// Setup Title Label
    fileprivate func setupTitleLabel(){
        
        if titleFontSize == 0 {titleFontSize = deviceHeight * 0.0269}
        let titleFont = UIFont(name: fontNameBold, size: titleFontSize)
        //let titleHeight:CGFloat = mTitle == nil ? 0 : heightForView(mTitle!, font: titleFont!, width: deviceWidth * 0.6)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel.text = mTitle
        titleLabel.font = titleFont
        titleLabel.textAlignment = .center
        titleLabel.widthAnchor.constraint(lessThanOrEqualTo: messageLabel.widthAnchor, multiplier: 1.0).isActive = true
    }
    
    /// Setup Seperator Line
    fileprivate func setupSeparator(){
        let seperatorHeight: CGFloat = self.showSeparator ? 0.7 : 0.0
        separatorView.backgroundColor = separatorColor
        separatorView.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, multiplier: 1.0).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: seperatorHeight).isActive = true
    }
    
    /// Setup Message Label
    fileprivate func setupMessageLabel(){
        if messageFontSize == 0 {messageFontSize = deviceHeight * 0.0239}
        let labelFont = UIFont(name: fontName, size: messageFontSize)!
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        messageLabel.font = labelFont
        messageLabel.text = mMessage
        messageLabel.textAlignment = .center
    }
    
    /// Setup Custom View
    fileprivate func setupContainer(){
        container.alpha = customViewSizeRatio > 0 ? 1.0 : 0.0
        container.widthAnchor.constraint(equalTo: generalStackView.widthAnchor, multiplier: 1.0).isActive = true
        customViewHeightAnchor = container.heightAnchor.constraint(equalTo: container.widthAnchor, multiplier: customViewSizeRatio)
    }
    
    /// Setup Buttons (StackView)
    fileprivate func setupButtonsStack(){
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.alignment = .fill
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = stackSpacing
        buttonsStackView.widthAnchor.constraint(equalTo: generalStackView.widthAnchor, multiplier: 0.8).isActive = true
        
        for i in 0 ..< actions.count{
            let button = setupButton(index: i)
            buttonsStackView.addArrangedSubview(button)
        }
    }
    
    /// A helper function to setup the button.
    ///
    /// - Parameters:
    ///   - index: The index for the current button.
    ///
    fileprivate func setupButton(index i:Int)->UIButton{
        if buttonHeight == 0 {buttonHeight = CGFloat(Int(deviceHeight * 0.07))}
        let button = UIButton(type: .custom)
        let action = actions[i]
        button.isExclusiveTouch = true
        button.setTitle(action?.title, for: [])
        button.setTitleColor(button.tintColor, for: [])
        button.layer.borderColor = button.tintColor.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = buttonHeight/2
        button.titleLabel?.font = UIFont(name: fontName, size: buttonHeight * 0.35)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        self.buttonStyle?(button,buttonHeight,i)
        button.tag = i
        button.addTarget(self, action: #selector(AZDialogViewController.handleAction(_:)), for: .touchUpInside)
        return button
    }
    
    /// Setup Cancel Button
    fileprivate func setupCancelButton(){
        if cancelButtonHeight == 0 {cancelButtonHeight = deviceHeight * 0.0449}
        cancelButton.setTitle(cancelTitle, for: [])
        cancelButton.titleLabel?.font = UIFont(name: fontName, size: cancelButtonHeight * 0.433)
        let showCancelButton = (cancelButtonStyle?(cancelButton,cancelButtonHeight) ?? false) && cancelEnabled
        let cancelMultiplier: CGFloat = showCancelButton ? 1.0 : 0.0
        cancelButton.isHidden = (showCancelButton ? cancelButtonHeight : 0) <= 0
        cancelButton.topAnchor.constraint(equalTo: generalStackView.bottomAnchor,constant: spacing).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: baseView.bottomAnchor,constant: -spacing).isActive = true
        
        cancelButtonHeightConstraint = cancelButton.heightAnchor.constraint(equalToConstant: cancelButtonHeight  * cancelMultiplier)
        cancelButton.addTarget(self, action: #selector(AZDialogViewController.cancelAction(_:)), for: .touchUpInside)
    }
    
    /// Setup BaseView
    fileprivate func setupBaseView(){
        self.baseView.isExclusiveTouch = true
        baseView.widthAnchor.constraint(equalToConstant: deviceWidth * 0.7).isActive = true
        baseView.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 0).isActive = true
        baseViewCenterYConstraint =
            baseView.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: contentOffset)
    }
    
    // Setup Tool Items
    fileprivate func setupToolItems(){
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
    
    // Setup Controller Settings
    fileprivate func setup(){
        actions = [AZDialogAction?]()
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    /// Helper function to change the dialog using an animation
    ///
    /// - Parameters:
    ///   - completionBlock: Block that is executed once aniamtions are finished.
    ///   - animations: Additional animations to execute.
    fileprivate func animateStackView(completionBlock:(()->Void)?=nil,withOptionalAnimations animations: (()->Void)?=nil){
        UIView.animate(withDuration: animationDuration, animations: { [weak self] in
            animations?()
            self?.generalStackView?.setNeedsLayout()
            self?.generalStackView?.layoutIfNeeded()
            self?.baseView?.setNeedsLayout()
            self?.baseView?.layoutIfNeeded()
        }) { (bool) in
            completionBlock?()
        }
    }
    
    /// Helper function to update the constraints
    ///
    /// - Parameters:
    ///   - showImage: shows the image if true
    ///   - completion: completion block, to execute after the animation
    fileprivate func updateConstraints(showImage: Bool,completion: (()->Void)?=nil){
        
        //update constraints only if they already exists.
        if generalStackViewTopConstraint == nil || imageViewHolderConstraint == nil || imageViewHolderHeightConstraint == nil{
            return
        }
        
        //remove existing constraint
        generalStackViewTopConstraint.isActive = false
        imageViewHolderConstraint.isActive = false
        imageViewHolderHeightConstraint.isActive = false
        
        
        //update constraints
        let imageHolderSize: CGFloat = CGFloat(Int((deviceWidth - 2 * deviceWidth / 8) / 3))
        let constant = showImage ? imageHolderSize : 0.0
        
        generalStackViewTopConstraint =
            generalStackView
                .topAnchor.constraint(equalTo: imageViewHolder.bottomAnchor, constant: spacing + spacing * (showImage ? 0.0 : 1.0))
        
        generalStackViewTopConstraint.isActive = true
        
        imageViewHolderConstraint =
            imageViewHolder.topAnchor.constraint(equalTo: baseView.topAnchor, constant: -constant/3)
        imageViewHolderConstraint.isActive = true
        
        imageViewHolderHeightConstraint = imageViewHolder.heightAnchor.constraint(equalToConstant: constant)
        imageViewHolderHeightConstraint.isActive = true
        
        //setup layers
        imageViewHolder.layer.cornerRadius = imageHolderSize / 2
        imageViewHolder.layer.masksToBounds = true
        
        imageView.layer.cornerRadius = (imageHolderSize - 2 * 5) / 2
        imageView.layer.masksToBounds = true
        
        //setup transform
        let transform = showImage ? CGAffineTransform(scaleX: 0, y: 0) : .identity
        imageViewHolder.transform = transform
        imageView.transform = transform
        
        //animate changes
        animateStackView(completionBlock: {
            completion?()
        }){ [weak self] in
            
            self?.imageViewHolder.alpha = showImage ? 1.0 : 0.0
            let inverseTransform = showImage ? .identity : CGAffineTransform(scaleX: 0.1, y: 0.1)
            self?.imageViewHolder.transform = inverseTransform
            self?.imageView.transform = inverseTransform
        }
    }
    
    fileprivate func createGesutre(for view: UIView){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AZDialogViewController.handleTapGesture(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
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

