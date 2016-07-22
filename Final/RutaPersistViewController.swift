//
//  RutaPersistViewController.swift
//  Final
//
//  Created by Serch on 15/07/16.
//  Copyright © 2016 Serch. All rights reserved.
//

import UIKit
import CoreData

class RutaPersistViewController: UIViewController,  UITextViewDelegate {
    
    @IBOutlet weak var nombreRuta: UITextField!
    
    @IBOutlet weak var descRuta: UITextView!
    
    @IBOutlet weak var fotoVista: UIImageView!
    
    weak var rutaViewController: RutaViewController?
    
    var contexto : NSManagedObjectContext? = nil
    
    var requeridos: [String] = []
    


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        descRuta.delegate = self
        
        
       

    }
    
    /*override func viewDidAppear(animated: Bool) {
        if(rutaViewController?.puntosColeccion != nil && rutaViewController?.puntosColeccion.count > 0) {
           
            for (i,row) in (rutaViewController?.puntosColeccion.enumerate())! {
                for (j,cell) in row.enumerate() {
                    print("m[\(i),\(j)] = \(cell)")
                }
            }
        }
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showPics(sender: AnyObject) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let fvc: FotosViewController = storyboard.instantiateViewControllerWithIdentifier("Fotos") as! FotosViewController
        fvc.rutaPersistViewController = self
        fvc.view.backgroundColor = UIColor.darkGrayColor()
        fvc.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.presentViewController(fvc, animated: true, completion: nil)
    }
  
    @IBAction func dismissModalView(sender: AnyObject) {
         self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func saveRoute(sender: AnyObject) {
        let nuevaRuta = NSEntityDescription.insertNewObjectForEntityForName("Ruta", inManagedObjectContext: self.contexto!)
        
        if estanLosRequeridos() {
        
        nuevaRuta.setValue(nombreRuta.text, forKey: "nombre")
        nuevaRuta.setValue(descRuta.text, forKey: "descripcion")
       
        nuevaRuta.setValue(UIImageJPEGRepresentation(self.fotoVista.image!, 1.0), forKey: "foto")
        
        var bufferPosiciones: String = ""
        if(rutaViewController?.puntosColeccion != nil && rutaViewController?.puntosColeccion.count > 0) {
            
            for (i,row) in (rutaViewController?.puntosColeccion.enumerate())! {
                                
                bufferPosiciones += "\(rutaViewController!.puntosNombres[i]),"
                
                for (j,cell) in row.enumerate() {

                    

                    if(j==0) {
                        bufferPosiciones += "\(cell),"
                        //nuevaPosicion.setValue(cell, forKey: "latitud")
                    } else {
                        bufferPosiciones += "\(cell)"
                        //nuevaPosicion.setValue(cell, forKey: "longitud")
                    }
                    
                    
                }
                
                if(((rutaViewController?.puntosColeccion.count)!-1) != i) {
                    bufferPosiciones += "|"
                }
               

            }
            
             nuevaRuta.setValue(bufferPosiciones, forKey: "ruta")

        }
    
        
        
        do {
            try self.contexto?.save()
            
            let alerta = UIAlertController(title: "Mensaje", message: "Ruta guardada con éxito", preferredStyle: .Alert)
            
            let accionOK = UIAlertAction(title: "OK", style: .Default, handler: {accion in
                
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
            alerta.addAction(accionOK)
            
            self.presentViewController(alerta, animated: true, completion: nil)
            
            
        } catch let error as NSError {
            
            print("Save failed: \(error.localizedDescription)")
            abort()
        }

        }
    }
    
    @IBAction func textFieldDoneEditing() {
        
        nombreRuta.resignFirstResponder()
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"  // Recognizes enter key in keyboard
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func backgroundTap(sender:UIControl) {
        nombreRuta.resignFirstResponder()
        descRuta.resignFirstResponder()
       
    }
    

    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let sigVista = segue.destinationViewController as! FotosViewController
        
        sigVista.rutaPersistViewController = self
        
    }*/
    

    func estanLosRequeridos() -> Bool {
       
        self.requeridos = []
        
        if(nombreRuta.text!.isEmpty) {
            
            requeridos.append("nombre")
        }
        
        if(descRuta.text!.isEmpty) {
            
            requeridos.append("descripción")
        }
        
        
        if(self.fotoVista.image == nil) {
            
            print("falta imagen")
        }
        
        let imageData: NSData = UIImagePNGRepresentation(self.fotoVista.image!)!
        
        let imageData2: NSData = UIImagePNGRepresentation(UIImage(named: "default-placeholder")!)!
        
        
        if (imageData.isEqual(imageData2)) {
            requeridos.append("foto")
        }
        
        if(rutaViewController!.puntosColeccion.isEmpty) {
             requeridos.append("pines")
        }

        
        
        if(requeridos.count > 0) {
            
            let alertController = UIAlertController(title: "Hey, te hace falta seleccionar:", message: requeridos.joinWithSeparator(","), preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return false
        } else {
            
            return true
        }

    }
}
