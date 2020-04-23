//
//  ViewController.swift
//  WhereIm
//
//  Created by Alexandre de Oliveira Nepomuceno on 23/04/20.
//  Copyright © 2020 Alexandre de Oliveira Nepomuceno. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var velocidadeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var enderecoLabel: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    var gerenciadordeLocalizacao = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            gerenciadordeLocalizacao.delegate = self
            gerenciadordeLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
            gerenciadordeLocalizacao.requestWhenInUseAuthorization()
            gerenciadordeLocalizacao.startUpdatingLocation()
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let localizacao = locations.last!
        let latitude = localizacao.coordinate.latitude
        let longitude = localizacao.coordinate.longitude
        latitudeLabel.text = String(latitude)
        self.longitudeLabel.text = String(longitude)
        if localizacao.speed > 0 {
            self.velocidadeLabel.text = String(localizacao.speed)
        }
        //atualizar map
        
        //configuração do zoom
        let deltaLatitude : CLLocationDegrees = 0.01
        let deltaLogintude : CLLocationDegrees = 0.01
        
        let latitudeCordinatorRegion : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
       
        let mkcordinatorspan : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: deltaLatitude, longitudeDelta: deltaLogintude)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: latitudeCordinatorRegion, span:mkcordinatorspan)
        map.setRegion(region, animated:true)
        
        CLGeocoder().reverseGeocodeLocation(localizacao){
            (detalhesLocal, erro) in
            if erro == nil {
                if let dadosLocal = detalhesLocal?.first{
                    
                    var thoroughfare = ""
                    if dadosLocal.thoroughfare != nil {
                        thoroughfare = dadosLocal.thoroughfare!
                    }
                    
                    var subThoroughfare = ""
                    if dadosLocal.subThoroughfare != nil {
                        subThoroughfare = dadosLocal.subThoroughfare!
                    }
                    
                    var locality = ""
                    if dadosLocal.locality != nil {
                        locality = dadosLocal.locality!
                    }
                    
                    var subLocality = ""
                    if dadosLocal.subLocality != nil {
                        subLocality = dadosLocal.subLocality!
                    }
                    
                    var postalCode = ""
                    if dadosLocal.postalCode != nil {
                        postalCode = dadosLocal.postalCode!
                    }
                    
                    var country = ""
                    if dadosLocal.country != nil {
                        country = dadosLocal.country!
                    }
                    
                    var administrativeArea = ""
                    if dadosLocal.administrativeArea != nil {
                        administrativeArea = dadosLocal.administrativeArea!
                    }
                    
                    var subAdministrativeArea = ""
                    if dadosLocal.subAdministrativeArea != nil {
                        subAdministrativeArea = dadosLocal.subAdministrativeArea!
                    }
                    
                    self.enderecoLabel.text = thoroughfare + " - "
                        + subThoroughfare + " / "
                        + locality + " / "
                        + country
                    
                    print(
                        "\n / thoroughfare:" + thoroughfare +
                            "\n / subThoroughfare:" + subThoroughfare +
                            "\n / locality:" + locality +
                            "\n / subLocality:" + subLocality +
                            "\n / postalCode:" + postalCode +
                            "\n / country:" + country +
                            "\n / administrativeArea:" + administrativeArea +
                            "\n / subAdministrativeArea:" + subAdministrativeArea
                    )
                    
                }
                
            }else
            {
                print(erro ?? "")
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse{
            
            let alerta = UIAlertController(title: "Permissão de Autorizaçõ",
                                           message: "Necessario permissão para usar a locaalização do Aplicativo", preferredStyle: .alert)
            let confirmar = UIAlertAction(title: "Abrir configurações", style: .default, handler: {
                (alertaConfiguracoes) in
                if let url = URL(string:UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url as URL)
                }
            } )
            
            let cancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alerta.addAction(confirmar)
            alerta.addAction(cancelar)
            present(alerta, animated: true, completion: nil)
        }
    }


}

