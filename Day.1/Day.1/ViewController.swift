import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var labelsView: UIView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var textField: UITextField!


    @IBOutlet weak var buttonOut: UIButton!

    @IBAction func button(_ sender: Any) {
        if let newText = textField.text {
            leftLabel.text = newText
        }
        if textField.text == "" {
            leftLabel.text = "Label Left"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.becomeFirstResponder()
    }


    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        adjustLayoutForOrientation(size: size)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    

    func adjustLayoutForOrientation(size: CGSize) {
        _ = size.width > size.height

        view.layoutIfNeeded()
    }
}
