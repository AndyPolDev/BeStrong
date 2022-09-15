import UIKit

extension UIViewController {
    func alertOkCancel(title: String, messoge: String?, completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: title,
                                                message: messoge,
                                                preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(okButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true)
    }
}
