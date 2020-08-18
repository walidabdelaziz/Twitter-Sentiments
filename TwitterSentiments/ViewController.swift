//
//  ViewController.swift
//  TwitterSentiments
//
//  Created by Walid  on 8/18/20.
//  Copyright © 2020 Walid . All rights reserved.
//

import UIKit
import SwifteriOS

class ViewController: UIViewController {
    
    
    let sentimentClassifier = TwitterSentimentModel()
    
    let swifter = Swifter(consumerKey: TWITTER_CONSUMER_KEY, consumerSecret: TWITTER_CONSUMER_SECRET)

    
    let tweetCount = 100

    
    
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var predictContainer: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        predictContainer.layer.cornerRadius = 10
    }

    @IBAction func predictButtonPressed(_ sender: UIButton) {
        fetchTweets()
    }
    
    func fetchTweets(){
        if let searchText = textField.text{
        swifter.searchTweet(using: searchText, lang: "en", count: tweetCount,tweetMode: .extended, success: { (results, metaData) in
            
            var tweets = [TwitterSentimentModelInput]()
            
            for i in 0..<self.tweetCount{
                if let tweet = results[i]["full_text"].string{
                    let tweetClassifier = TwitterSentimentModelInput(text: tweet)
                    tweets.append(tweetClassifier)
                }
                
            }
            
            self.makePrediction(with: tweets)

            
        }) { (error) in
            print("There is an error while trying to fetch tweets \(error)")
        }
        }
    }
    
    func makePrediction(with tweets: [TwitterSentimentModelInput]){
        do{
             var sentimentScore = 0
            let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
             for prediction in predictions{
                 let sentiment = prediction.label
                 if sentiment == "Pos"{
                     sentimentScore += 1
                 }else if sentiment == "Neg"{
                     sentimentScore -= 1
                 }
             }
            
            updateUI(with: sentimentScore)
            
         }catch{
             print("There is an error while trying to predict tweets sentiments \(error)")
         }
        
    }
    
    func updateUI(with sentimentScore: Int){
        if sentimentScore > 20 {
            textLabel.text = "Amazing"
            emojiLabel.text = "😍"
        }else if sentimentScore > 10 {
            textLabel.text = "Great"
            emojiLabel.text = "😃"
        }else if sentimentScore > 0 {
            textLabel.text = "Good"
            emojiLabel.text = "😊"
        }else if sentimentScore == 0 {
            textLabel.text = "Not Bad"
            emojiLabel.text = "😐"
        }else if sentimentScore > -10 {
            textLabel.text = "Bad"
            emojiLabel.text = "🙁"
        }else if sentimentScore > -20 {
            textLabel.text = "Too Bad"
            emojiLabel.text = "😡"
        }else{
            textLabel.text = "Shitttttt !"
            emojiLabel.text = "🤬"
        }
        reviewLabel.text = "Overall tweets about \(textField.text!)"
        textField.text = ""

    }
    
}

