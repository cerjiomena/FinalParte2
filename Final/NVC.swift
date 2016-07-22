//
//  NVC.swift
//  Final
//
//  Created by Serch on 17/07/16.
//  Copyright © 2016 Serch. All rights reserved.
//

import UIKit

class NVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let origen = sender as! CapturaViewController
        let vc = segue.destinationViewController as! VC
        origen.sesion?.stopRunning()
        vc.urls = origen.urls
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
