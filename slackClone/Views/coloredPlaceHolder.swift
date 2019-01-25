import UIKit

@IBDesignable class ColorPlaceHolder: UITextField {
    
    override func awakeFromNib() {
        setUpView()
        
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpView()
    }
    
    func setUpView() {
        if let p = placeholder  {
            let place = NSAttributedString (string: p, attributes: [.foregroundColor: #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1) ])
            attributedPlaceholder = place
            textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            
        }
    }
    
    
    
}
