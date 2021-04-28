import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var postTextView: UITextView!
    @IBOutlet private weak var postIDTextField: UITextField!
    @IBOutlet private weak var indicatorView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var respondedData = "" {
        didSet {
            postTextView.text = respondedData
        }
    }
    
    private var session: URLSession {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicatorView.isHidden = true
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
        turnActivityIndicatorON()
        getPosts(with: postID)
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        respondedData = ""
        let currentText = textField.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 2
    }
}

private extension ViewController {
    func getPosts(with ID: String) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/comments?postId=\(ID)")
        
        guard let requestUrl = url else {
            self.turnActivityIndicatorOFF()
            return }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data,
                      let dataString = String(data: data, encoding: .utf8),
                      (response as? HTTPURLResponse)?.statusCode == 200,
                      error == nil else {
                    self.turnActivityIndicatorOFF()
                    return }
                self.turnActivityIndicatorOFF()
                self.respondedData = dataString
            }
        }
        task.resume()
    }
    
    func turnActivityIndicatorON() {
        indicatorView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func turnActivityIndicatorOFF() {
        indicatorView.isHidden = true
        activityIndicator.stopAnimating()
    }
}
