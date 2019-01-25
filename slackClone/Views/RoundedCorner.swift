import UIKit

@IBDesignable class RoundedCorner: UIButton {
    
    @IBInspectable var cornerRadius : CGFloat = 5.0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }

    override func awakeFromNib() {
        setupView()
    }
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    func setupView() {
        self.layer.cornerRadius = cornerRadius
        
    }

}
