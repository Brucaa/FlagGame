//
//  ViewController.swift
//  FlagGame
//
//  Created by Milos Jovanovic on 15/11/2019.
//  Copyright © 2019 Milos Jovanovic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    var countries = [String]()
    var highScore = 0
    var score = 0
    var correctAnswer = 0
    var counter = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show score", style: .plain, target: self, action: #selector(showCurrentScore))
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco",
        "nigeria", "poland", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        let defaults = UserDefaults.standard
        
        if let highscore = defaults.value(forKey: "highScore") as? Int {
            self.highScore = highscore
            print("Successfully loaded high score! It is a \(highScore)")
        } else {
            print("Failed to load score or score is not yet saved.")
        }
        
        askQuestion(action: nil)
    }

    
    func askQuestion(action: UIAlertAction!) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased() + "  \(score)"
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct Answer!"
            score += 1
            counter += 1
            
        } else {
            title = "Wrong Answer"
            score -= 1
            counter += 1
        }

        
        if counter < 10 {
            let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        
            present(ac, animated: true)
            
            
        } else {
            if score > highScore {
                highScore = score
                save()
                let ac3 = UIAlertController(title: nil, message: "Your new highscore is \(highScore)", preferredStyle: .alert)
                
                ac3.addAction(UIAlertAction(title: "Ok", style: .default, handler: askQuestion))
                
                present(ac3, animated: true)
                highScore = score
                
                counter = 0
                score = 0
            } else {
                
            let ac2 = UIAlertController(title: title, message: "You have answered 10 questions, your final score is \(score)!", preferredStyle: .alert)
            
            ac2.addAction(UIAlertAction(title: "Restart", style: .default, handler: askQuestion))
            
            present(ac2, animated: true)
            
            counter = 0
            score = 0
            
        }
        
       }
    }
    
    @objc func showCurrentScore() {
        
        let ac = UIAlertController(title: nil, message: "Your score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    func save() {
        let defaults = UserDefaults.standard
        
        do {
            defaults.set(highScore, forKey: "highScore")
            print("Succesfully saved score!")
        } catch {
            print("Failed to save high score!")
        }
    }
}

