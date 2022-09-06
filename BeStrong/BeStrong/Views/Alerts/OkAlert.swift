import UIKit

extension UIViewController {
    func alertOK(title: String, messoge: String?) {
        
        let alertController = UIAlertController(title: title,
                                                message: messoge,
                                                preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okButton)
        present(alertController, animated: true)
    }
}
