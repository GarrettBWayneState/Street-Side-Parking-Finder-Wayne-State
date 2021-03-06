//
//  ViewController.swift
//  Parking Finder
//
//  Created by Server on 2/7/21.
//
import UIKit
import FirebaseDatabase
import FirebaseAuth
import MapKit
import Foundation

class homeViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate
{
    // Outlets for text fields and button
    @IBOutlet weak var userParkedZoneField: UITextField!
    @IBOutlet weak var userParkedETimeField: UITextField!
    @IBOutlet weak var homeButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        userParkedZoneField.delegate = self
        userParkedETimeField.delegate = self
        
        // shadow for park button
        homeButton.layer.shadowColor = UIColor.black.cgColor
        homeButton.layer.shadowOffset = CGSize(width: 2, height: 3)
        homeButton.layer.shadowRadius = 1.0
        homeButton.layer.shadowOpacity = 1.5
    }

    // Handles the user logout button
    // Code written by Eli
    @IBAction func logOut_Button(_ sender: Any)
    {
        do
        {
            try Auth.auth().signOut()
        }
        catch let LogoutError
        {
            print(LogoutError)
        }
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        print("log out button tapped!")
        let signInVC = storyboard.instantiateViewController(withIdentifier: "loginViewController")
        self.present(signInVC, animated: true, completion: nil)
        print("No Current User Signed in")
    }
    
    @IBAction func homeButton(_ sender: Any)
    {}

    @IBAction func parkedButtonTapped(_ sender: Any)
    {
        print("parked button tapped!")
        let ref = Database.database().reference()
        let usersReference = ref.child("users")
        
        let userRef = usersReference.child(Auth.auth().currentUser!.uid)
        
        let uid :String = (Auth.auth().currentUser?.uid)!
        print("Current user ID is: " + uid)
        userRef.updateChildValues([
            "parking Zone": self.userParkedZoneField.text!,
            "parking time":self.userParkedETimeField.text!
        ])
        print("action finished")
        // Parked Button is hidden when tapped
        let tapButton : UIButton = sender as! UIButton
            tapButton.isHidden = true;
    }
    
    // Func Handle textfields Home Page
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        // code that allows users to enter only numbers
        let allowedCharacters = "+1234567890"
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        
        // code that allows users to enter three numbers total
        let maxLength = 3
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        return allowedCharacterSet.isSuperset(of: typedCharacterSet) && newString.length <= maxLength
    }
    
    //keyboard methods for fields
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        hidekeyboardHome()
        return true
    }
    
    // Func hideKeyboard
    func hidekeyboardHome()
    {
        print("Hide Keyboard")
        userParkedZoneField.resignFirstResponder()
        userParkedETimeField.resignFirstResponder()
    }
}


class finderViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        mapView.delegate = self
        setZoomLevel(location: locationLatLong)
        self.placePins()
    }
    
    // Configure map starting coorndinates
    let locationLatLong = CLLocation(latitude: 42.354405249, longitude: -83.0687297251)                                                                 // initial start coordinates
    let distanceSpan: CLLocationDistance = 1500                                                                                                         // initial start radius distance
    func setZoomLevel(location: CLLocation)                                                                                                             // create region for zoom level
    {
        let mapCoordinates = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distanceSpan, longitudinalMeters: distanceSpan)
        mapView.setRegion(mapCoordinates, animated: true)
    }
    
    // structure for annotation pins
    struct ParkingZone
    {
        var name: String
        var lattitude: CLLocationDegrees
        var longtitude: CLLocationDegrees
    }
    
    func placePins()
    {
        // set each pin coordinate and name
        let wayneParkingZonesC = [ParkingZone(name: "1", lattitude: 42.35722, longtitude: -83.06361111),
                                 ParkingZone(name: "2", lattitude: 42.35689, longtitude: -83.06472222),
                                 ParkingZone(name: "3", lattitude: 42.35670, longtitude: -83.06530),
                                 ParkingZone(name: "4", lattitude: 42.35635, longtitude: -83.06611111),
                                 ParkingZone(name: "5", lattitude: 42.35605, longtitude: -83.06694444),
                                 ParkingZone(name: "6", lattitude: 42.35577, longtitude: -83.06777778),
                                 ParkingZone(name: "7", lattitude: 42.35559, longtitude: -83.06833333),
                                 ParkingZone(name: "8", lattitude: 42.35525, longtitude: -83.06944444),
                                 ParkingZone(name: "9", lattitude: 42.35515, longtitude: -83.06972222),
                                 ParkingZone(name: "10", lattitude: 42.35490, longtitude: -83.07055556),
                                 ParkingZone(name: "11", lattitude: 42.35455, longtitude: -83.07166667),
                                 ParkingZone(name: "12", lattitude: 42.35420, longtitude: -83.07277778),
                                 ParkingZone(name: "13", lattitude: 42.35445, longtitude: -83.06580),
                                 ParkingZone(name: "14", lattitude: 42.35390, longtitude: -83.06555556),
                                 ParkingZone(name: "15", lattitude: 42.35420, longtitude: -83.07277778),
            ParkingZone(name: "16", lattitude: 42.356804620064196, longtitude: -83.06415562908188),            //more locations and pins by fahim
            ParkingZone(name: "17", lattitude: 42.356891830402986, longtitude: -83.06387667934433),
            ParkingZone(name: "18", lattitude: 42.356961202177004, longtitude: -83.06361114065186),
            ParkingZone(name: "19", lattitude: 42.357034537969085, longtitude: -83.06335096637741),
            ParkingZone(name: "20", lattitude:  42.357163370910115, longtitude: -83.06303983013169),
            ParkingZone(name: "21", lattitude:  42.35734922962929, longtitude: -83.0625736622988),
            ParkingZone(name: "22", lattitude:  42.35750871304528, longtitude: -83.06217544951403),
            ParkingZone(name: "23", lattitude:  42.35776448592051, longtitude: -83.06159609236681),
            ParkingZone(name: "24", lattitude:  42.35794440031079, longtitude: -83.06117333331446),
            ParkingZone(name: "25", lattitude:  42.358186765813464, longtitude: -83.06070281179706),
            ParkingZone(name: "26", lattitude:  42.358186765813464, longtitude: -83.06070281179706),
            ParkingZone(name: "27", lattitude:  42.35835422570779, longtitude: -83.06084817521543),
            ParkingZone(name: "28", lattitude:  42.3565933374783, longtitude: -83.06478840687288),
            ParkingZone(name: "29", lattitude:  42.35648630608267, longtitude: -83.0651156363727),
            ParkingZone(name: "30", lattitude:  42.35634756140963, longtitude: -83.06542409040941),
            ParkingZone(name: "31", lattitude:  42.356239443400014, longtitude: -83.06567695299543),
            ParkingZone(name: "32", lattitude:  42.35610268025863, longtitude: -83.06603905121244),
            ParkingZone(name: "33", lattitude:  42.35634756140963, longtitude: -83.06542409040941),
            ParkingZone(name: "34", lattitude:  42.35634756140963, longtitude: -83.06542409040941),
            ParkingZone(name: "35", lattitude:  42.35592956086741, longtitude: -83.06645057687177),
            ParkingZone(name: "36", lattitude:  42.35389678824058, longtitude: -83.07285762845464),
            ParkingZone(name: "37", lattitude:  42.35400778833208, longtitude: -83.07250491796918),
            ParkingZone(name: "38", lattitude:  42.35412869892297, longtitude: -83.07214281975217),
            ParkingZone(name: "39", lattitude:  42.35426744849474, longtitude: -83.07172171293684),
            ParkingZone(name: "40", lattitude:  42.35437814818244, longtitude: -83.07132029096391),
            ParkingZone(name: "41", lattitude:  42.354549701049955, longtitude: -83.07078469319742),
            ParkingZone(name: "42", lattitude:  42.354724127865055, longtitude: -83.07021606488627),
            ParkingZone(name: "43", lattitude:  42.3548779644611, longtitude: -83.06971178529778),
            ParkingZone(name: "45", lattitude:  42.35505338642431, longtitude: -83.06914353404568),
            ParkingZone(name: "47", lattitude:  42.362017, longtitude: -83.070072),
            ParkingZone(name: "48", lattitude:  42.361119, longtitude: -83.067252),
            ParkingZone(name: "49", lattitude:  42.353983, longtitude: -83.062326),
            ParkingZone(name: "50", lattitude:  42.351096, longtitude: -83.063837)
        ]
        // add each annotation parking zone with its info
        for ParkingZone in wayneParkingZonesC
        {
            let annotation = MKPointAnnotation()
            annotation.title = ParkingZone.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: ParkingZone.lattitude, longitude: ParkingZone.longtitude)
            mapView.addAnnotation(annotation)
        }
    }
    
func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?//(MKAnnotationView?, MKMarkerAnnotationView)
{
    
    let annotationIdentifier = "MyMarker"
    var annoView = self.mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
    
    //let annotationIdentifierr = "pin"
    let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
    annotationView.markerTintColor = .blue  // default
    
    if annoView == nil
    {
        annoView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        annoView?.canShowCallout = true
        
        // isEmpty button
        let emptyBtn = UIButton(type: .detailDisclosure)
        emptyBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        emptyBtn.backgroundColor = UIColor.green
        emptyBtn.layer.borderColor = UIColor.darkGray.cgColor
        emptyBtn.layer.cornerRadius = 5
        emptyBtn.layer.masksToBounds = true
        emptyBtn.addTarget(self, action:#selector(self.isEmptyClicked), for: .touchUpInside)

        // isFull button
        let fullBtn = UIButton(type: .detailDisclosure)
        fullBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        fullBtn.backgroundColor = UIColor.gray
        fullBtn.layer.borderColor = UIColor.darkGray.cgColor
        fullBtn.layer.cornerRadius = 5
        fullBtn.layer.masksToBounds = true
        fullBtn.addTarget(self, action:#selector(self.isFullClicked), for: .touchUpInside)
        
        // isExtended button
        let extendedBtn = UIButton(type: .detailDisclosure)
        extendedBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        extendedBtn.backgroundColor = UIColor.blue
        extendedBtn.layer.borderColor = UIColor.darkGray.cgColor
        extendedBtn.layer.cornerRadius = 5
        extendedBtn.layer.masksToBounds = true
        extendedBtn.addTarget(self, action:#selector(self.isExtendedClicked), for: .touchUpInside)
        
        annoView!.annoViewDesign(arrangedSubviews: [emptyBtn, fullBtn, extendedBtn])              // three added info buttons
     }
     else
     {
         annoView?.annotation = annotation
     }
     //annoView = annotationView                 // returns color not buttons
    return annoView
}

    @objc func isEmptyClicked()
    {
        print("isEmpty Clicked")
        
        //let annotationView = MKMarkerAnnotationView()
        //annotationView.self.markerTintColor = UIColor.green
        //annotationView.markerTintColor = UIColor.gray
    }
    
    @objc func isFullClicked()
    {
        print("isFull Clicked")
        
    }
    
    @objc func isExtendedClicked()
    {
        print("isExtended Clicked")
    }
    
    /*switch annotation.title
    {
        case "1":
            isEmptyClicked()                                      // add available func
            annotationView.markerTintColor = UIColor.green
        case "B":                                                                // add extended func
            annotationView.markerTintColor = UIColor.blue
        case "3":                                                                 // add full func
            annotationView.markerTintColor = UIColor.red
        default:                                                                   // if nothing than be grey
            annotationView.markerTintColor = UIColor.gray
    }*/
}

extension MKAnnotationView                                                                              // design of annotation container
{

    func annoViewDesign(arrangedSubviews: [UIView])
    {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth, .flexibleHeight]
        stackView.translatesAutoresizingMaskIntoConstraints = false

        self.detailCalloutAccessoryView = stackView
    }
}

/*extension MKAnnotation                                                                            // design of annotation container
{

    func annoDesign(type: [UIButton])
    {
       // let btn:UIButton = UIButton(type: .detailDisclosure)
        let btn:UIButton = UIButton(type: UIButton.ButtonType.detailDisclosure)
        btn.setTitle("Detail Disclosure", for: UIControl.State.normal)
        btn.backgroundColor = UIColor.blue
        btn.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth, .flexibleHeight]
        btn.translatesAutoresizingMaskIntoConstraints = false
    
        self.view.addSubview(btn)
    }
}*/
