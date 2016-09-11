//
//  ViewController.swift
//  SimpleRestCalls
//
//  Created by Michael Stroh on 16.08.16.
//  Copyright © 2016 Michael Stroh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var getRequestButton: UIButton!
    @IBOutlet weak var getRequestAnswerLabel: UILabel!
    
    var jsonResultOrigin :String = ""
    @IBOutlet weak var postRequestButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getRequestSent(sender: UIButton) {
        sendHTTPGet()
        if !jsonResultOrigin.isEmpty {
            self.getRequestAnswerLabel.text = jsonResultOrigin
        }
    }
    
    @IBAction func postRequestSent(sender: UIButton) {
        sendHTTPPost()
        self.getRequestAnswerLabel.text = "POST sent"
        
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
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                print("GET: Printing json")
                print(json)
                print("GET: Printing value")
                print(json.valueForKey("origin"))
                
                // TODO: Wait for HTTP-Answer
                self.jsonResultOrigin = json.valueForKey("origin") as! String
                
                
            } catch let jsonError {
                print(jsonError)
            }
            
            let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("GET: Printing NSString")
            print(str)
            
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
            
            let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("POST: Printing NSString")
            print(str)
            
        }.resume()
        
        
    }

}