//
//  frmMain.swift
//  Macbeth Quotes
//
//  Created by David Chen on 3/19/19.
//  Copyright © 2019 David Chen. All rights reserved.
//

import UIKit

class frmMain: UIViewController {
    
    @IBOutlet weak var lbQuote: UILabel!
    @IBOutlet weak var lbSpeaker: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //print(getHTML())
        analyse(txt: getHTML())
        // Do any additional setup after loading the view.
        /*
        for speaker in speakers {
            print("_____________", speaker.id, speaker.name, speaker.quotes.count)
            for quote in speaker.quotes {
                for lineID in quotes[quote].lines {
                    let line = lines[lineID]
                    print(line.quote, speakers[quotes[line.quote].speaker].name, line.name, line.content)
                }
            }
            //print(speaker.name, speaker.quotes.count)
        }
        
        for line in lines {
            
            //print(line.quote, speakers[quotes[line.quote].speaker].name, line.name, line.content)
        }
 */
        showNewQuote()
    }
    
    func getHTML () -> String {
        let url = Bundle.main.url(forResource: "macbeth", withExtension: "html")
        do {
            let text = try String(contentsOf: url!)
            return text
        } catch {
            return ""
        }
    }
    
    var maxL: Int = 10
    func showNewQuote () {
        lbSpeaker.isHidden = true
        var newquote: String = ""
        var randomQuoteID: Int = 0
        var startFrom: Int = 0
        var maxindex: Int = 0
        while true {
            randomQuoteID = Int.random(in: 1 ..< quotes.count)
            if quotes[randomQuoteID].lines.count < 2 {
                continue
            }
            startFrom = 0
            if quotes[randomQuoteID].lines.count > maxL {
                startFrom = Int.random(in: 0 ... quotes[randomQuoteID].lines.count - maxL)
            }
            maxindex = startFrom + maxL
            if maxindex >= quotes[randomQuoteID].lines.count {
                maxindex = quotes[randomQuoteID].lines.count
            }
            for i in startFrom ..< maxindex  {
                //print(quotes[randomQuoteID].lines.count, i)
                newquote.append(lines[quotes[randomQuoteID].lines[i]].content)
                newquote.append("\n")
            }
            lbQuote.text = newquote
            break
        }
        lbSpeaker.text = speakers[quotes[randomQuoteID].speaker].name + ", " + lines[quotes[randomQuoteID].lines[startFrom]].name + " ... " + lines[quotes[randomQuoteID].lines[maxindex - 1]].name
    }
    
    @IBAction func btnRevealAnswer_Tapped(_ sender: Any) {
        lbSpeaker.isHidden = false
    }
    
    @IBAction func btnNextQuote_Tapped(_ sender: Any) {
        showNewQuote()
    }
    

}
