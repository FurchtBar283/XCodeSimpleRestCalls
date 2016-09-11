//
//  ViewController.swift
//  SimpleRestCalls
//
//  Created by Michael Stroh on 16.08.16.
//  Copyright © 2016 Michael Stroh. All rights reserved.
//

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
    
    var getJsonResultKeyOrigin :String = ""
    var optionsResponseAllowedHTTPMethods = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // Action-functions for all UIButtons
    @IBAction func getRequestSent(sender: UIButton) {
        sendHTTPGet()
        if !getJsonResultKeyOrigin.isEmpty {
            self.getRequestAnswerLabel.text = getJsonResultKeyOrigin
        }
    }
    
    @IBAction func postRequestSent(sender: UIButton) {
        sendHTTPPost()
        self.postRequestAnswerLabel.text = "POST sent"
        
    }
    
    @IBAction func optionsRequestSent(sender: UIButton) {
        sendHTTPOptions()
        self.optionsRequestAnswerLabel.text =  "Allowed HTTP methods are " + optionsResponseAllowedHTTPMethods
    }
    
    @IBAction func putRequestSent(sender: UIButton) {
        sendHTTPPut()
        self.putRequestAnswerLabel.text = "PUT sent"
    }
    
    @IBAction func deleteRequestSent(sender: UIButton) {
        sendHTTPDelete()
        self.deleteRequestAnswerLabel.text = "DELETE sent"
    }
    
    @IBAction func headRequestSent(sender: AnyObject) {
        sendHTTPHead()
        self.headRequestAnswerLabel.text = "HEAD sent"
    }
    
    
    //  HTTP-GET
    func sendHTTPGet() {
        // Creating a configuration object is always the first step when uploading or downloading data
        // configure timeout values, caching policies, connection requirements and other types of info for NSURLSession
        // Once configured session object ignores any changes you m ake to the NSURLSessionConfiguration
        let myUrlSessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        
        //var myUrlSession = NSURLSession.init(configuration: myUrlSessionConfig, delegate: nil, delegateQueue: NSOperationQueue?)
        let myUrlSession = NSURLSession.init(configuration: myUrlSessionConfig)
        //var mySessionTask = NSURLSessionTask.init()
        //var mySessionDataTask = NSURLSessionDataTask.init()
        
        
        let url = NSURL(string: "https://httpbin.org/get")
        let request = NSURLRequest.init(URL: url!)
        
        //NSURLSession.sharedSession().dataTaskWithRequest(<#T##request: NSURLRequest##NSURLRequest#>)
        //NSURLSession.sharedSession().dataTaskWithURL(url!)
        myUrlSession.dataTaskWithRequest(request) { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                print("GET: Printing json")
                print(jsonResult)
                print("GET: Printing value")
                print(jsonResult.valueForKey("origin"))
                
                // TODO: Wait for HTTP-Answer
                self.getJsonResultKeyOrigin = jsonResult.valueForKey("origin") as! String
                
                
            } catch let jsonError {
                print(jsonError)
            }
            
            let data = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("GET: Printing NSString")
            print(data)
            
        }.resume()
    }
    
    // HTTP-POST
    func sendHTTPPost() {
        let myUrlSessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let myUrlSession = NSURLSession.init(configuration: myUrlSessionConfig)
        
        let url = NSURL(string: "https://httpbin.org/post")
        
        let myURLRequest = NSMutableURLRequest.init(URL: url!)
        myURLRequest.HTTPMethod = "POST"
        //let valueToPost = "project=REST-Call"
        let valueToPost = "project=REST-Call&developer=PierceBrosnan"
        // TODO: Post JSON
        // TODO: Upload a file
        let data = valueToPost.dataUsingEncoding(NSUTF8StringEncoding)
        myURLRequest.HTTPBody = data
        myURLRequest.timeoutInterval = 60
        myURLRequest.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        myURLRequest.HTTPShouldHandleCookies = false
        
        myUrlSession.dataTaskWithRequest(myURLRequest) { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                print("POST: Printing json")
                print(jsonResult)
                
            } catch let jsonError {
                print(jsonError)
            }
            
            let data = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("POST: Printing NSString")
            print(data)
            
        }.resume()
    }
    
    
    // HTTP-OPTIONS
    func sendHTTPOptions() {
        let myUrlSessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let myUrlSession = NSURLSession.init(configuration: myUrlSessionConfig)
        
        let url = NSURL(string: "https://httpbin.org/")
        let myURLRequest = NSMutableURLRequest.init(URL: url!)
        myURLRequest.HTTPMethod = "OPTIONS"
        myURLRequest.timeoutInterval = 60
        myURLRequest.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        myURLRequest.HTTPShouldHandleCookies = false
        
        myUrlSession.dataTaskWithRequest(myURLRequest) { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            let urlResponse = response as! NSHTTPURLResponse
            print("OPTIONS: Printing response")
            print(urlResponse)
            
            print("OPTIONS: HTTP Statuscode is ")
            print(urlResponse.statusCode)
            
            let urlResponseAsDictionary :NSDictionary = urlResponse.allHeaderFields
            print("OPTIONS: urlResponseAsDictionary")
            print(urlResponseAsDictionary)
            
            print("OPTIONS: Allowed HTTP methods are")
            print(urlResponseAsDictionary.valueForKey("allow"))
            
            self.optionsResponseAllowedHTTPMethods = urlResponseAsDictionary.valueForKey("allow") as! String
            
            
            }.resume()
    }
    
    // HTTP-PUT
    // TODO: Perform File-Replacement
    func sendHTTPPut() {
        let myUrlSessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let myUrlSession = NSURLSession.init(configuration: myUrlSessionConfig)
        
        let url = NSURL(string: "https://httpbin.org/put")
        
        let myURLRequest = NSMutableURLRequest.init(URL: url!)
        myURLRequest.HTTPMethod = "PUT"
        let valueToPost = "project=REST-Calls&developer=PierceBrosnan"
        let data = valueToPost.dataUsingEncoding(NSUTF8StringEncoding)
        myURLRequest.HTTPBody = data
        myURLRequest.timeoutInterval = 60
        myURLRequest.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        myURLRequest.HTTPShouldHandleCookies = false
        
        myUrlSession.dataTaskWithRequest(myURLRequest) { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                print("PUT: Printing json")
                print(jsonResult)
                
            } catch let jsonError {
                print(jsonError)
            }
            
            let data = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("PUT: Printing NSString")
            print(data)
            
            }.resume()
        
    }
    
    // HTTP-DELETE
    func sendHTTPDelete() {
        let myUrlSessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let myUrlSession = NSURLSession.init(configuration: myUrlSessionConfig)
        
        let url = NSURL(string: "https://httpbin.org/delete")
        
        let myURLRequest = NSMutableURLRequest.init(URL: url!)
        myURLRequest.HTTPMethod = "DELETE"
        myURLRequest.timeoutInterval = 60
        myURLRequest.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        myURLRequest.HTTPShouldHandleCookies = false
        
        myUrlSession.dataTaskWithRequest(myURLRequest) { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                print("DELETE: Printing json")
                print(jsonResult)
                
            } catch let jsonError {
                print(jsonError)
            }
            
            let urlResponse = response as! NSHTTPURLResponse
            print("DELETE: Printing response")
            print(urlResponse)
            
            print("DELETE: HTTP Statuscode is ")
            print(urlResponse.statusCode)
            
            }.resume()
        
    }
    
    // HTTP-HEAD
    func sendHTTPHead() {
        let myUrlSessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let myUrlSession = NSURLSession.init(configuration: myUrlSessionConfig)
        
        let url = NSURL(string: "https://httpbin.org/get")
        let myURLRequest = NSMutableURLRequest.init(URL: url!)
        myURLRequest.HTTPMethod = "HEAD"
        myURLRequest.timeoutInterval = 60
        myURLRequest.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        myURLRequest.HTTPShouldHandleCookies = false
        
        myUrlSession.dataTaskWithRequest(myURLRequest) { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            let urlResponse = response as! NSHTTPURLResponse
            print("HEAD: Printing response")
            print(urlResponse)
            
            print("HEAD: HTTP Statuscode is ")
            print(urlResponse.statusCode)
            
            let urlResponseAsDictionary :NSDictionary = urlResponse.allHeaderFields
            print("HEAD: urlResponseAsDictionary")
            print(urlResponseAsDictionary)
            
            //let urlResponseAsDictionary = urlResponse as NSDictionary
            
            }.resume()
        
    }
    
} // End of class ViewController