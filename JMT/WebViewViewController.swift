import UIKit
import WebKit

class WebViewViewController: UIViewController, WKNavigationDelegate {

    // IBOutlet 연결
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.request(url: "\(urlTextField)")

    }

    func request(url: String) {
           self.webView?.load(URLRequest(url: URL(string: url)!))
           self.webView?.navigationDelegate = self
       }
    
    // 확인 버튼 액션 처리
    @IBAction func goButtonPressed(_ sender: UIButton) {
        if let urlString = urlTextField.text, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView?.load(request)
        } else {
            
            // URL을 가져올 수 없는 경우
            let alert = UIAlertController(title: "Error", message: "Invalid URL", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        
        
    }
}

  
