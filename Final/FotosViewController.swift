//
//  FotosViewController.swift
//  Final
//
//  Created by Serch on 15/07/16.
//  Copyright © 2016 Serch. All rights reserved.
//

import UIKit

class FotosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var fotoVista: UIImageView!
    
    @IBOutlet weak var camaraBoton: UIButton!
    
    private let miPicker = UIImagePickerController()
    
    weak var rutaPersistViewController: RutaPersistViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if !UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            camaraBoton.enabled = false
        }
        miPicker.delegate = self
        if(rutaPersistViewController!.fotoVista.image != nil) {
            self.fotoVista.image = rutaPersistViewController!.fotoVista.image
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func album(sender: AnyObject) {
        
        miPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(miPicker, animated: true, completion: nil)
    }
    
    
    @IBAction func camara(sender: AnyObject) {
        miPicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(miPicker, animated: true, completion: nil)
    }
    
    
    @IBAction func dismissModalView(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        fotoVista.image = image
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func guardar(sender: AnyObject) {
        
        rutaPersistViewController?.fotoVista.image =  fotoVista.image
        self.dismissViewControllerAnimated(true, completion: nil)
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
