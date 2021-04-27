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
        print("🟢 ShowPostButtonDidTap")
        getPosts(with: "10")
    }
    
}

//TODO: May be Need to prevent enetering 00, 01, 02 ... 09
extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard CharacterSet(charactersIn: "1234567890").isSuperset(of: CharacterSet(charactersIn: string)) else {
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
        let baseUrl = URL(string: "https://jsonplaceholder.typicode.com/comments")
        let endPoint = "?postId=\(ID)"
        
        guard let base = baseUrl else { return }
        
        let url = "\(base)\(endPoint)"
        
        let requestUrl = URL(string: url)
        
        guard let unwrRequestUrl = requestUrl else { return }
        
        var request = URLRequest(url: unwrRequestUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                  let dataString = String(data: data, encoding: .utf8),
                  (response as? HTTPURLResponse)?.statusCode == 200,
                  error == nil else { return }
            //self.postTextView.text = dataString
            print(dataString)
        }
        task.resume()
    }
}
