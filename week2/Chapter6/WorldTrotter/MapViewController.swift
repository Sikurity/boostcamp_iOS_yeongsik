//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by YeongsikLee on 2017. 7. 10..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var mapView: MKMapView!
    var locationManager = CLLocationManager()       /// 위치 관리자
    var pins: [MKPointAnnotation]?                  /// 맵 위에 찍힐 핀들
    
    var changeMapStatusSegment: UISegmentedControl! /// 맵 상태 변경 세그먼트
    var gotoUserLocationButton: UIButton!           /// 현재 위치로 이동 버튼
    var showNextPinbutton: UIButton!                /// 핀 생성 / 다음 핀으로 이동 버튼
    
    var currentPinNo: Int = 0
    
    override func viewDidLoad() {
        
        // super.viewDidLoad은 반드시 호출해준다
        super.viewDidLoad()

        // 지도 뷰 생성
        mapView = MKMapView()
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        // 지도 뷰를 뷰 컨트롤러의 view로 설정
        self.view = mapView
        
        changeMapStatusSegment = addChangeMapStatusSegment()
        gotoUserLocationButton = addGotoUserLocationButton()
        showNextPinbutton = addShowNextPinButton()
        
        // Do any additional setup after loading the view.
        print("MapViewController loaded its view")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 맵 상태 변경 세그먼트를 뷰에 추가
    func addChangeMapStatusSegment() -> UISegmentedControl{
        
        let segment = UISegmentedControl(items: ["표준", "동시", "위성"])
        
        segment.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segment.selectedSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        
        // 세그먼트 추가
        view.addSubview(segment)
        
        //  let topConstraint = segmentedControl.topAnchor.constraint(equalTo: self.view.topAnchor)
        //  let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        //  let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        
        let marginsGuide = self.view.layoutMarginsGuide
        
        // 제약조건 설정
        let segmentTopConstraint = segment.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        let segmentLeadingConstraint = segment.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor)
        let segmentTrailingConstraint = segment.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor)
        
        // 제약조건 적용
        segmentTopConstraint.isActive = true
        segmentLeadingConstraint.isActive = true
        segmentTrailingConstraint.isActive = true
        
        // 세그먼트가 변경 되었을 시 실행 될 컨트롤러 선택
        segment.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        
        return segment
    }
    
    // 맵을 현재 위치로 이동하도록 하는 버튼 추가
    func addGotoUserLocationButton() -> UIButton {
        
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        
        button.setTitle("현재 위치로", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // 버튼 추가
        view.addSubview(button)
        
        // 제약조건 설정
        let buttonBottomConstraint = button.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -8)
        let buttonCenterConstraint = button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        
        // 제약조건 적용
        buttonBottomConstraint.isActive = true
        buttonCenterConstraint.isActive = true
        
        // 버튼이 눌렸을 시 실행 될 컨트롤러 선택
        button.addTarget(self, action: #selector(gotoUserLocation(_:)), for: .touchUpInside)
        
        return button
    }
    
    // 맵을 현재 위치로 이동하도록 하는 버튼 추가
    func addShowNextPinButton() -> UIButton {
        
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        
        button.setTitle("기억된 지점 보기", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // 버튼 추가
        view.addSubview(button)
        
        // 제약조건 설정
        let buttonBottomConstraint = button.bottomAnchor.constraint(equalTo: gotoUserLocationButton.topAnchor, constant: -8)
        let buttonCenterConstraint = button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        
        // 제약조건 적용
        buttonBottomConstraint.isActive = true
        buttonCenterConstraint.isActive = true
        
        // 버튼이 눌렸을 시 실행 될 컨트롤러 선택
        button.addTarget(self, action: #selector(showNextPins(_:)), for: .touchUpInside)
        
        return button
    }
    
    func mapTypeChanged(_ segControl: UISegmentedControl) {
        
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    // 은메달 과제: 사용자 위치
    // 현재 위치로 이동 버튼이 눌렸을 때 실행되는 컨트롤러
    func gotoUserLocation(_ sender: Any) {
        
        // 위치 정보를 사용할 때 사용자에게 권한 요청
        locationManager.requestWhenInUseAuthorization()
        
        if let currentLocation = mapView.userLocation.location {
            let location = CLLocationCoordinate2DMake(
                currentLocation.coordinate.latitude,
                currentLocation.coordinate.longitude
            )
            
            setRegion(of: mapView, to: location)
        } else {
            print("No Location")
        }
    }
    
    // 은메달 과제: 사용자 위치
    // 맵을 위치 좌표로 이동
    func setRegion(of mapView: MKMapView, to locationCoord: CLLocationCoordinate2D){
        // 위도, 경도 출력
        print("Location: \(locationCoord)")
        
        let span = MKCoordinateSpanMake(0.1, 0.1) // 맵 척도
        let region = MKCoordinateRegion(center: locationCoord, span: span) // 척도를 적용한 현재 위치의 맵
        
        mapView.setRegion(region, animated: true) // 맵을 현재 위치가 보이도록
    }
    
    // 금메달 과제: 핀 놓기
    func showNextPins(_ sender: Any) {
        // 처음 눌렸을 때
        if pins == nil {
            pins = [MKPointAnnotation]()
            
            pins! += [MKPointAnnotation()]
            pins![0].coordinate =  CLLocationCoordinate2D(latitude: 37.861861, longitude: 127.747508)
            pins![0].title = "태어난 곳"
            
            mapView.addAnnotation(pins![0])
            
            pins! += [MKPointAnnotation()]
            pins![1].coordinate =  CLLocationCoordinate2D(latitude: 37.497071, longitude: 127.028582)
            pins![1].title = "부스트캠프"
            mapView.addAnnotation(pins![1])
            
            pins! += [MKPointAnnotation()]
            pins![2].coordinate =  CLLocationCoordinate2D(latitude: 37.550959, longitude: 126.990915)
            pins![2].title = "흥미로운곳"
            mapView.addAnnotation(pins![2])
            
            showNextPinbutton.setTitle("다음 핀으로", for: .normal)
            
        } else {    // 핀이 보이고 난 후 눌렸을 때
            currentPinNo = (currentPinNo + 1) % 3
            let location = CLLocationCoordinate2DMake(
                pins![currentPinNo].coordinate.latitude,
                pins![currentPinNo].coordinate.longitude
            )
            
            setRegion(of: mapView, to: location)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
