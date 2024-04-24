import Foundation
import UIKit

extension UICollectionView {
    
    func registerCellFromNib(cellID: String) {
        self.register(UINib(nibName: cellID, bundle: nil), forCellWithReuseIdentifier: cellID)
    }
}

//extension UITextField{
//   @IBInspectable var placeHolderColor: UIColor? {
//        get {
//            return self.placeHolderColor
//        }
//        set {
//            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
//        }
//    }
//}
//
//extension UIView {
//    @IBInspectable var cornerRadius: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//            layer.masksToBounds = true
//        }
//    }
//}
//
//extension UIView {
//    @IBInspectable var borderWidth: CGFloat {
//        get {
//            return layer.borderWidth
//        }
//        set {
//            layer.borderWidth = newValue
//        }
//    }
//    
//    @IBInspectable var borderColor: UIColor? {
//        get {
//            if let color = layer.borderColor {
//                return UIColor(cgColor: color)
//            }
//            return nil
//        }
//        set {
//            layer.borderColor = newValue?.cgColor
//        }
//    }
//}
//
//extension UIView {
//    @IBInspectable var bottomCornerRadius: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//        }
//    }
//}
//
//extension UIView {
//    @IBInspectable var fullyRoundedCorners: Bool {
//        get {
//            return layer.cornerRadius == min(bounds.width, bounds.height) / 2
//        }
//        set {
//            DispatchQueue.main.async { [self] in
//                if newValue {
//                    layer.cornerRadius = min(bounds.width, bounds.height) / 2
//                    layer.masksToBounds = true
//                } else {
//                    layer.cornerRadius = 0
//                    layer.masksToBounds = false
//                }
//            }
//        }
//    }
//}
