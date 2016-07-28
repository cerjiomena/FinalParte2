//
//  ListadoEventosController.swift
//  Final
//
//  Created by Serch on 28/07/16.
//  Copyright © 2016 Serch. All rights reserved.
//

import UIKit


class ListadoEventosController: UITableViewController {
    
    var info :Array<Array<String>> = Array<Array<String>>()
    var imagenes: Array<UIImage> = Array<UIImage>()
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBar = navigationController!.navigationBar
        navigationBar.tintColor = UIColor.blueColor()
        let leftButton =  UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ListadoEventosController.cancel(_:)))
        navigationItem.leftBarButtonItem = leftButton
        
        let urls: String = "http://104.236.91.248/mexico"
        let url = NSURL(string: urls)
        let datos = NSData(contentsOfURL: url!)
        if datos == nil{
            let alert = UIAlertController(title:"Error", message: "No hay conexion a Internet", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        else {
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                let dico1 = json as! NSDictionary
                if dico1["events"] != nil
                {
                    let eventos = dico1["events"] as! NSArray
                    for i in eventos{
                        let fecha  : String  = i["date"] as! NSString as String
                        let nombre: String  = i["name"] as! NSString as String
                        let descripcion: String  = i["description"] as! NSString as String
                        let imagen: String  = i["image"] as! NSString as String
                        
                        let fot = NSURL(string: imagen)
                        let dat = NSData(contentsOfURL: fot!)
                        var caratula:UIImage? = nil
                        
                        if(dat == nil) {
                            
                            caratula = UIImage(named: "default-placeholder")
                            
                        } else {
                            caratula = UIImage(data:dat!)
                        }
                        
                        
                        self.info.append([fecha,nombre,descripcion])
                        self.imagenes.append(caratula!)
                        print(nombre)
                    }
                }
                else
                {
                    let alert = UIAlertController(title: ":(", message: "Eventos no encontrados", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            catch _ {
                
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.info.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = "\(self.info[indexPath.row][0]): \(self.info[indexPath.row][1])"
        cell.detailTextLabel?.text = self.info[indexPath.row][2]
        cell.imageView!.image = self.imagenes[indexPath.row]

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func cancel(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        //self.navigationController?.popToRootViewControllerAnimated(true)
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }


}
