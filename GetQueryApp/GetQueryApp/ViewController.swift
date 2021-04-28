import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var postTextView: UITextView!
    @IBOutlet private weak var postIDTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTextView.text = ""
        postIDTextField.delegate = self
    }
    
    @IBAction func showPostButtonDidTap(_ sender: UIButton) {
        guard let text = postIDTextField.text else { return }
        var postID = text
        if postID.count == 2 && postID.first == "0" {
            postID.remove(at: postID.startIndex)
            postIDTextField.text = postID
        }
        getPosts(with: postID)
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        let currentText = textField.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 2
    }
}

private extension ViewController {
    func getPosts(with ID: String) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/comments?postId=\(ID)")
        
        guard let requestUrl = url else { return }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                  let dataString = String(data: data, encoding: .utf8),
                  (response as? HTTPURLResponse)?.statusCode == 200,
                  error == nil else { return }
//            self.postTextView.text = dataString
            print("🟢 \(dataString)")
        }
        task.resume()
    }
}
