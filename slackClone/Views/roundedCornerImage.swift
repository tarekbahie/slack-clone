
import UIKit

@IBDesignable class RoundedCornerImage: UIImageView {
    
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
        self.layer.cornerRadius = self.frame.size.width / 2
        
    }
    
}
