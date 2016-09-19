import UIKit

class ViewController: UIViewController {
    // UILabels for showing off request-results
    @IBOutlet weak var getRequestAnswerLabel: UILabel!
    @IBOutlet weak var postRequestAnswerLabel: UILabel!
    @IBOutlet weak var optionsRequestAnswerLabel: UILabel!
    @IBOutlet weak var putRequestAnswerLabel: UILabel!
    @IBOutlet weak var deleteRequestAnswerLabel: UILabel!
    @IBOutlet weak var headRequestAnswerLabel: UILabel!
    // UIButtons for performing every available HTTP-Request
    @IBOutlet weak var getRequestButton: UIButton!
    @IBOutlet weak var postRequestButton: UIButton!
    
    var httpResult :String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // Action-functions for all UIButtons
    @IBAction func getRequestSent(_ sender: UIButton) {
        sendHTTPGet()
        if !httpResult.isEmpty {
            self.getRequestAnswerLabel.text = httpResult
            httpResult = ""
        }
    }
    
    @IBAction func postRequestSent(_ sender: UIButton) {
        sendHTTPPost()
        self.postRequestAnswerLabel.text = "POST sent"
    }
    
    @IBAction func optionsRequestSent(_ sender: UIButton) {
        sendHTTPOptions()
        self.optionsRequestAnswerLabel.text =  "Allowed HTTP methods are " + httpResult
        httpResult = ""
    }
    
    @IBAction func putRequestSent(_ sender: UIButton) {
        sendHTTPPut()
        self.putRequestAnswerLabel.text = "PUT sent"
    }
    
    @IBAction func deleteRequestSent(_ sender: UIButton) {
        sendHTTPDelete()
        self.deleteRequestAnswerLabel.text = httpResult
        httpResult = ""
    }
    
    @IBAction func headRequestSent(_ sender: AnyObject) {
        sendHTTPHead()
        self.headRequestAnswerLabel.text = "HEAD sent"
    }
    
    
    //  HTTP-GET
    // TODO: File-download, Background-download
    func sendHTTPGet() {
        // Creating a configuration object is always the first step when uploading or downloading data
        // configure timeout values, caching policies, connection requirements and other types of info for NSURLSession
        // Once configured session object ignores any changes you m ake to the NSURLSessionConfiguration
        let myUrlSessionConfig = URLSessionConfiguration.default
        
        
        //var myUrlSession = NSURLSession.init(configuration: myUrlSessionConfig, delegate: nil, delegateQueue: NSOperationQueue?)
        let myUrlSession = URLSession.init(configuration: myUrlSessionConfig)
        //var mySessionTask = NSURLSessionTask.init()
        //var mySessionDataTask = NSURLSessionDataTask.init()
        
        
        let url = URL(string: "https://httpbin.org/get")
        let request = URLRequest.init(url: url!)
        
        //NSURLSession.sharedSession().dataTaskWithRequest(<#T##request: NSURLRequest##NSURLRequest#>)
        //NSURLSession.sharedSession().dataTaskWithURL(url!)
        myUrlSession.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                print("GET: Printing json")
                print(jsonResult)
                print("GET: Printing value")
                print(jsonResult.value(forKey: "origin"))
                
                // TODO: Wait for HTTP-Answer
                self.httpResult = jsonResult.value(forKey: "origin") as! String
                
                
            } catch let jsonError {
                print(jsonError)
            }
            
            let data = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("GET: Printing NSString")
            print(data)
            
        }) .resume()
    }
    
    // HTTP-POST
    // TODO: Post JSON, Upload a file
    func sendHTTPPost() {
        let myUrlSessionConfig = URLSessionConfiguration.default
        let myUrlSession = URLSession.init(configuration: myUrlSessionConfig)
        
        let url = URL(string: "https://httpbin.org/post")
        
        //let myURLRequest = NSMutableURLRequest.init(url: url!)
        var myURLRequest = URLRequest.init(url: url!)
        myURLRequest.httpMethod = "POST"
        //let valueToPost = "project=REST-Call"
        let valueToPost = "project=REST-Call&developer=PierceBrosnan"
        // TODO: Post JSON
        // TODO: Upload a file
        let data = valueToPost.data(using: String.Encoding.utf8)
        myURLRequest.httpBody = data
        myURLRequest.timeoutInterval = 60
        myURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        myURLRequest.httpShouldHandleCookies = false
        
        
        myUrlSession.dataTask(with: myURLRequest, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                print("POST: Printing json")
                print(jsonResult)
                
            } catch let jsonError {
                print(jsonError)
            }
            
            let data = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("POST: Printing NSString")
            print(data)
            
        }) .resume()
    }
    
    
    // HTTP-OPTIONS
    func sendHTTPOptions() {
        let myUrlSessionConfig = URLSessionConfiguration.default
        let myUrlSession = URLSession.init(configuration: myUrlSessionConfig)
        
        let url = URL(string: "https://httpbin.org/")
        //let myURLRequest = NSMutableURLRequest.init(url: url!)
        var myURLRequest = URLRequest.init(url: url!)
        myURLRequest.httpMethod = "OPTIONS"
        myURLRequest.timeoutInterval = 60
        myURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        myURLRequest.httpShouldHandleCookies = false
        
        myUrlSession.dataTask(with: myURLRequest, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            let urlResponse = response as! HTTPURLResponse
            print("OPTIONS: Printing response")
            print(urlResponse)
            
            print("HEAD: HTTP Statuscode is \(urlResponse.statusCode)")
            
            let urlResponseAsDictionary :NSDictionary = urlResponse.allHeaderFields as NSDictionary
            print("OPTIONS: urlResponseAsDictionary")
            print(urlResponseAsDictionary)
            
            print("OPTIONS: Allowed HTTP methods are")
            print(urlResponseAsDictionary.value(forKey: "allow"))
            
            self.httpResult = urlResponseAsDictionary.value(forKey: "allow") as! String
            
            
            }) .resume()
    }
    
    // HTTP-PUT
    // TODO: Perform File-Replacement
    func sendHTTPPut() {
        let myUrlSessionConfig = URLSessionConfiguration.default
        let myUrlSession = URLSession.init(configuration: myUrlSessionConfig)
        
        let url = URL(string: "https://httpbin.org/put")
        
        //let myURLRequest = NSMutableURLRequest.init(url: url!)
        var myURLRequest = URLRequest.init(url: url!)
        myURLRequest.httpMethod = "PUT"
        let valueToPost = "project=REST-Calls&developer=PierceBrosnan"
        let data = valueToPost.data(using: String.Encoding.utf8)
        myURLRequest.httpBody = data
        myURLRequest.timeoutInterval = 60
        myURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        myURLRequest.httpShouldHandleCookies = false
        
        myUrlSession.dataTask(with: myURLRequest, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                print("PUT: Printing json")
                print(jsonResult)
                
            } catch let jsonError {
                print(jsonError)
            }
            
            let data = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("PUT: Printing NSString")
            print(data)
            
            }) .resume()
        
    }
    
    // HTTP-DELETE
    func sendHTTPDelete() {
        let myUrlSessionConfig = URLSessionConfiguration.default
        let myUrlSession = URLSession.init(configuration: myUrlSessionConfig)
        
        let url = URL(string: "https://httpbin.org/delete")
        
        //let myURLRequest = NSMutableURLRequest.init(url: url!)
        var myURLRequest = URLRequest.init(url: url!)
        myURLRequest.httpMethod = "DELETE"
        myURLRequest.timeoutInterval = 60
        myURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        myURLRequest.httpShouldHandleCookies = false
        
        myUrlSession.dataTask(with: myURLRequest, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            let urlResponse = response as! HTTPURLResponse
            print("DELETE: Printing response")
            print(urlResponse)
            
            print("HEAD: HTTP Statuscode is \(urlResponse.statusCode)")
            
            if urlResponse.statusCode == 200 {
                print("DELETE: Ressource successfully deleted")
                self.httpResult = "Ressource successfully deleted"
            } else {
                print("DELETE: Bad-Request")
            }
            
            }) .resume()
        
    }
    
    // HTTP-HEAD
    func sendHTTPHead() {
        let myUrlSessionConfig = URLSessionConfiguration.default
        let myUrlSession = URLSession.init(configuration: myUrlSessionConfig)
        
        let url = URL(string: "https://httpbin.org/get")
        //let myURLRequest = NSMutableURLRequest.init(url: url!)
        var myURLRequest = URLRequest.init(url: url!)
        myURLRequest.httpMethod = "HEAD"
        myURLRequest.timeoutInterval = 60
        myURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        myURLRequest.httpShouldHandleCookies = false
        
        myUrlSession.dataTask(with: myURLRequest, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            let urlResponse = response as! HTTPURLResponse
            print("HEAD: Printing response")
            print(urlResponse)
            
            print("HEAD: HTTP Statuscode is \(urlResponse.statusCode)")
            
            let urlResponseAsDictionary :NSDictionary = urlResponse.allHeaderFields as NSDictionary
            print("HEAD: urlResponseAsDictionary")
            print(urlResponseAsDictionary)
            
            //Extract HTTP-Header-Options from Dictionary if necessary
            
            }) .resume()
        
    }
    
} // End of class ViewController
