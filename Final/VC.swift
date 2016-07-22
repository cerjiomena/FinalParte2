//
//  VC.swift
//  Final
//
//  Created by Serch on 17/07/16.
//  Copyright © 2016 Serch. All rights reserved.
//

import UIKit

class VC: UIViewController {

    @IBOutlet weak var direccion: UILabel!
    @IBOutlet weak var web: UIWebView!
    var urls : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        direccion?.text = urls
        let url = NSURL(string: urls!)
        let peticion = NSURLRequest(URL: url!)
        web.loadRequest(peticion)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
