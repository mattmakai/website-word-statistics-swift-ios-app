//
//  ViewController.swift
//  Website Word Statistics
//
//  Created by Matthew Makai on 9/1/16.
//  Copyright © 2016 Matt Makai. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import Kanna


class ViewController: UIViewController, UISearchBarDelegate, UIWebViewDelegate {
  
  var pageStats = TextStatistics()
  
  @IBAction func showStatsBtn(sender: AnyObject) {
    let alertController = UIAlertController(title: "Webpage Statistics", message: "", preferredStyle: .ActionSheet)
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = NSTextAlignment.Left
    
    let messageText = NSMutableAttributedString(
      string: pageStats.statisticsMessage(),
      attributes: [
        NSParagraphStyleAttributeName: paragraphStyle,
        NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleBody),
        NSForegroundColorAttributeName : UIColor.blackColor()
      ]
    )
    
    alertController.setValue(messageText, forKey: "attributedMessage")
    
    let ok = UIAlertAction(title: "Ok", style: .Cancel, handler: { (action) -> Void in
    })
    
    alertController.addAction(ok)
    
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  @IBOutlet var searchBarInput: UISearchBar!
  @IBOutlet var webView: UIWebView!
  @IBOutlet var activityIndicator: UIActivityIndicatorView!
  

  override func viewDidLoad() {
    super.viewDidLoad()
    activityIndicator.alpha = 0
    searchBarInput.autocapitalizationType = .None
    searchBarInput.returnKeyType = .Go
    webView.delegate = self
    webView.keyboardDisplayRequiresUserAction = true
    webView.frame = self.view.frame
    
    let defaultRequest = NSURLRequest(URL: NSURL(string: "https://www.fullstackpython.com/")!)
    webView.loadRequest(defaultRequest)
    self.scrapePage(defaultRequest.URLString)
    
    self.searchBarInput.delegate = self
  }
  
  func webViewDidStartLoad(webView: UIWebView) {
    activityIndicator.alpha = 1
    activityIndicator.startAnimating()
  }
  
  func webViewDidFinishLoad(webView: UIWebView) {
    activityIndicator.stopAnimating()
    activityIndicator.alpha = 0
  }
  
  func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    if (navigationType == UIWebViewNavigationType.LinkClicked){
      searchBarInput.text = request.URLString
      self.scrapePage(request.URLString)
    }
    if (navigationType == UIWebViewNavigationType.BackForward) {
      searchBarInput.text = request.URLString
      self.scrapePage(request.URLString)
    }
    
    return true
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    print(searchBar.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
    if (searchBar.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) != "") {
      let url = NSURL(string: searchBar.text!)
      let req = NSURLRequest(URL:url!)
      self.webView!.loadRequest(req)
      self.scrapePage(searchBar.text!)
    }
  }
  
  // Grabs the HTML from current website for parsing.
  func scrapePage(currentUrl: String) -> Void {
    Alamofire.request(.GET, currentUrl).responseString { response in
      guard let parseURL = response.result.value else {
        return
      }
      self.pageStats.resetStatistics()
      self.parseHTML(parseURL)
    }
  }
  
  func calculateTextStats(textBlock: XMLElement) -> (charCount: Int, wordCount: Int, syllableCount: Int) {
    // strip string of surrounding whitespace and newlines
    let text = textBlock.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    return (text.characters.count, text.componentsSeparatedByString(" ").count, SyllableCounter.sharedInstance.count(text))
  }
  
  func parseHTML(html: String) -> Void {
    if let doc = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding) {
      
      // Search for <p> nodes
      for textBlock in doc.css("p") {
        pageStats.pElementCount += 1
        let stats = calculateTextStats(textBlock)
        pageStats.charCount += stats.charCount
        pageStats.wordCount += stats.wordCount
        pageStats.syllableCount += stats.syllableCount
      }
      
      // Search for <h1> nodes
      for textBlock in doc.css("h1") {
        pageStats.h1ElementCount += 1
        let stats = calculateTextStats(textBlock)
        pageStats.charCount += stats.charCount
        pageStats.wordCount += stats.wordCount
        pageStats.syllableCount += stats.syllableCount
      }
      
      // Search for <h2> nodes
      for textBlock in doc.css("h2") {
        pageStats.h2ElementCount += 1
        let stats = calculateTextStats(textBlock)
        pageStats.charCount += stats.charCount
        pageStats.wordCount += stats.wordCount
        pageStats.syllableCount += stats.syllableCount
      }
      
      print("\(pageStats.charCount) characters on the page.")
      print("\(pageStats.wordCount) words on the page.")
      print("\(pageStats.syllableCount) syllables on the page.")
      
      print("\(pageStats.pElementCount) <p> elements on the page.")
      print("\(pageStats.h1ElementCount) <h1> elements on the page.")
      print("\(pageStats.h2ElementCount) <h2> elements on the page.")
    }
  }


}

