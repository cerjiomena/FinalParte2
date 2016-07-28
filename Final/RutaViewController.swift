//
//  RutaViewController.swift
//  Final
//
//  Created by Serch on 12/07/16.
//  Copyright © 2016 Serch. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RutaViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapa: MKMapView!
    private let manejador = CLLocationManager()
    var posicionInicial: CLLocation!
    var punto : CLLocationCoordinate2D!
    var distanciaRecorrida : Double!
    var pin : MKPointAnnotation!
    private var origen: MKMapItem!
    private var destino: MKMapItem!
    private var contadorPines: Int = 0
    private var lugar = ""
    private var estaEscribiendoNombrePunto = false
    
    private let reuseIdentifier = "miIdentificador"
    
    var puntosColeccion :Array<Array<Double>> = []
    var puntosNombres : Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        manejador.delegate = self
        mapa.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        posicionInicial = nil
        punto = CLLocationCoordinate2D()
        distanciaRecorrida = 0.0
        pin = nil
        //para agregar los pines
        /*let tap = UILongPressGestureRecognizer(target: self, action: #selector(RutaViewController.tapMap))
        tap.minimumPressDuration = 0.2
        mapa.addGestureRecognizer(tap)*/
       
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedWhenInUse {
            
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
            
        } else {
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let posicionActual : CLLocation = locations.last!
        
        let ultimaPosicion: CLLocation = locations[locations.count - 1]
        
        if posicionInicial == nil {
            posicionInicial = ultimaPosicion
            
        }
        
            
        let inicial = MKPlacemark(coordinate: posicionInicial.coordinate, addressDictionary: nil)
        origen = MKMapItem(placemark: inicial)
            
        let final =  MKPlacemark(coordinate: ultimaPosicion.coordinate, addressDictionary: nil)
        destino = MKMapItem(placemark: final)
            
        self.obtenerRuta(self.origen!, destino: self.destino!)

        
        let center = CLLocationCoordinate2D(latitude: posicionActual.coordinate.latitude, longitude: posicionActual.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        
        mapa.setRegion(region, animated: true)
        
        
        if estaEscribiendoNombrePunto {
            estaEscribiendoNombrePunto = false
            punto.latitude = posicionActual.coordinate.latitude
            punto.longitude = posicionActual.coordinate.longitude
            let pin = MKPointAnnotation()
            pin.title = String(lugar)
            pin.subtitle = "lat:\(punto.latitude), long:\(punto.longitude)"
            pin.coordinate = punto
            mapa.addAnnotation(pin)
            
            let nuevoPunto = [punto.latitude, punto.longitude]
            puntosNombres.append(pin.title!)
            puntosColeccion.append(nuevoPunto)

            
        }
        
        
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
       
        
        let alerta = UIAlertController(title: "Error", message: "error \(error.code)", preferredStyle: .Alert)
        
        let accionOK = UIAlertAction(title: "OK", style: .Default, handler: {accion in
            
        })
        
        alerta.addAction(accionOK)
        
        
       
        self.presentViewController(alerta, animated: true, completion: nil)
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func obtenerRuta(origen: MKMapItem, destino: MKMapItem) {
        
        let solicitud = MKDirectionsRequest()
        solicitud.source = origen
        solicitud.destination = destino
        solicitud.transportType = .Walking
        let indicaciones = MKDirections(request: solicitud)
        
        
        
        indicaciones.calculateDirectionsWithCompletionHandler({
            (respuesta: MKDirectionsResponse?, error: NSError?) in
            
            if(error != nil) {
                
                //print("Error al obtener la ruta")
            } else {
                self.muestraRuta(respuesta!)
            }
            
        })
    }
    
    func muestraRuta(respuesta: MKDirectionsResponse) {
        for ruta in respuesta.routes {
            
            mapa.addOverlay(ruta.polyline, level: MKOverlayLevel.AboveRoads)
            
            /*for paso in ruta.steps {
                
                print(paso.instructions)
            }*/
        }
        
        /*let centro = origen.placemark.coordinate
        let region = MKCoordinateRegionMakeWithDistance(centro, 3000, 3000)
        mapa.setRegion(region, animated: true)*/
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 3.0
        return renderer
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.tintColor = UIColor.greenColor()  // do whatever customization you want
            annotationView?.canShowCallout = true            // but turn off callout
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    
    /* Metodo para poner el pin en pantalla */
    //@Deprecated
    func tapMap(gestureRecognizer:UIGestureRecognizer){
        let touchPoint = gestureRecognizer.locationInView(self.mapa)
        let newCoord:CLLocationCoordinate2D = mapa.convertPoint(touchPoint, toCoordinateFromView: self.mapa)
        
        let newAnotation = MKPointAnnotation()
        newAnotation.coordinate = newCoord
      
        contadorPines += 1
        newAnotation.title = "Punto \(contadorPines)"
        mapa.addAnnotation(newAnotation)
        
        let nuevoPunto = [newCoord.latitude, newCoord.longitude]
        puntosNombres.append(newAnotation.title!)
        puntosColeccion.append(nuevoPunto)
    }
    
    
    
    @IBAction func showRouteOptions(sender: AnyObject) {
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Elige opción", preferredStyle: .ActionSheet)
        
        // 2
        let seeAction = UIAlertAction(title: "Ver rutas", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            
            let lvc: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("navListadoRutas") as! UINavigationController
             lvc.view.backgroundColor = UIColor.darkGrayColor()
             lvc.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
             
             self.presentViewController(lvc, animated: true, completion: nil)
            

        })
        let saveAction = UIAlertAction(title: "Guardar ruta", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let rpvc: RutaPersistViewController = storyboard.instantiateViewControllerWithIdentifier("rutaPersistente") as! RutaPersistViewController
            rpvc.rutaViewController = self
            rpvc.view.backgroundColor = UIColor.darkGrayColor()
            rpvc.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            
            self.presentViewController(rpvc, animated: true, completion: nil)
            

        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancelar", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(saveAction)
        optionMenu.addAction(seeAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func agregarPuntoEnPosicionActual(sender: AnyObject) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Agregar Punto Actual", message: "Teclea el nombre", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "nombre punto"
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            self.lugar = textField.text!
            self.estaEscribiendoNombrePunto = true
        }))
        
         alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    @IBAction func mostrarAcerca(sender: AnyObject) {
        
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let avc: AcercaViewController = storyboard.instantiateViewControllerWithIdentifier("about") as! AcercaViewController
        avc.view.backgroundColor = UIColor.darkGrayColor()
        avc.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.presentViewController(avc, animated: true, completion: nil)
        

        
    }

    @IBAction func mostrarEventos(sender: AnyObject) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let lvc: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("navListadoEventos") as! UINavigationController
        lvc.view.backgroundColor = UIColor.darkGrayColor()
        lvc.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.presentViewController(lvc, animated: true, completion: nil)
    }

}
