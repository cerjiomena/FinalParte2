//
//  InterfaceController.swift
//  Final WatchKit Extension
//
//  Created by Serch on 10/07/16.
//  Copyright © 2016 Serch. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation


class InterfaceController: WKInterfaceController, WCSessionDelegate {


    var watchSession : WCSession?
    var ventana = MKCoordinateSpanMake(0.005, 0.005)
    
    @IBOutlet var mapa: WKInterfaceMap!
    
    var rutas : String?

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
       //NSManagedObjectContext * managedContext = [[CoreDataHelper, sharedHelper], context];

    }
    
    @IBAction func zoom(value: Float) {
        let grados:CLLocationDegrees = CLLocationDegrees(value)/10
        ventana = MKCoordinateSpanMake(grados, grados)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    if(WCSession.isSupported()){
            watchSession = WCSession.defaultSession()
            // Add self as a delegate of the session so we can handle messages
            watchSession!.delegate = self
            watchSession!.activateSession()
        }

        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    /*func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        <#code#>
    }*/
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]){
        
        dispatch_async(dispatch_get_main_queue(), {
            self.rutas  = applicationContext["message"] as? String
            self.desglosarPuntos()

        })

        
    }
    
    func desglosarPuntos() {
        
        let arreglo = self.rutas?.componentsSeparatedByString("|")
        //var origen: MKMapItem!
        //var destino: MKMapItem!
        
        
        for i in (0..<arreglo!.count-1) {
            
            obtenerPunto(arreglo![i])
            
            /*if( arreglo!.count > 1) {
                
                destino = self.obtenerPunto(arreglo![i+1])
                
            } else {
                
                destino = origen
                
                
            }*/
            //origenCentral = origen
            //self.obtenerRuta(origen!, destino:  destino!)
            
        }
        
    }
    
    func obtenerPunto(row: String) -> MKMapItem {
        
        var origen: MKMapItem!
        
        var columna = row.componentsSeparatedByString(",")
        
        let puntoCoor = CLLocationCoordinate2D(latitude: Double(columna[1])!, longitude:  Double(columna[2])!)
        let puntoLugar = MKPlacemark(coordinate: puntoCoor, addressDictionary: nil)
        origen = MKMapItem(placemark: puntoLugar)
        origen.name = columna[0]
        
        self.anotaPunto(origen)
        
        return origen
        
    }
    
    func anotaPunto(punto: MKMapItem) {
        let puntoCoor = CLLocationCoordinate2D(latitude: punto.placemark.coordinate.latitude, longitude:  punto.placemark.coordinate.longitude)
        
        mapa.addAnnotation(puntoCoor, withPinColor:.Purple)
        let region = MKCoordinateRegionMake(puntoCoor, ventana)
        mapa.setRegion(region)
    }
    
    
   



    

}
