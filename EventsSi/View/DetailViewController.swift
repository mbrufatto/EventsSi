//
//  DetailViewController.swift
//  EventsSi
//
//  Created by Marcio Habigzang Brufatto on 09/06/20.
//  Copyright © 2020 Mantra Tech. All rights reserved.
//

import UIKit
import Kingfisher
import MapKit

class DetailEventViewController: UIViewController {

    //MARK: - Properties
    var eventId: String?
    var detailEventViewModel: DetailEventViewModelProtocol
    
    private var event: Event?
    private var eventImage = UIImageView()
    private var eventTitle = UILabel()
    private var eventRoad = UILabel()
    private var eventCityAndState = UILabel()
    private var eventPrice = UILabel()
    private var eventDescription = UILabel()
    private var eventMap = MKMapView()
    private var btnShare = UIButton(type: .roundedRect)
    private var btnCheckin = UIButton(type: .roundedRect)
    private let stackBtns = UIStackView()
    private let viewBtn = UIView()
    
    private lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    
    //MARK: - Views
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.frame = self.view.bounds
        view.contentSize = contentViewSize
        view.autoresizingMask = .flexibleHeight
        view.bounces = true
        view.showsHorizontalScrollIndicator = true
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.frame.size = contentViewSize
        return view
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Center of container view"
        return label
    }()
    
    //MARK: - View Controller Lifecycle
    
    init(detailEventViewModelProtocol: DetailEventViewModelProtocol? = nil) {
        self.detailEventViewModel = detailEventViewModelProtocol ?? DetailEventViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Detalhes do Evento"
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(containerView)
        
        self.loadEvent()
    }
    
    private func loadEvent() {
        guard let eventId = eventId else { return }
        self.detailEventViewModel.getEvent(eventId: eventId, completion: { event in
            DispatchQueue.main.async {
                self.event = event
                self.setupComponents()
                self.setupConstraints()
            }
        })
    }
    
    internal func setupComponents() {
        self.view.addSubview(self.scrollView)
        
        self.containerView.backgroundColor = .white
        
        if let event = self.event {
            
            self.loadImage()
            self.containerView.addSubview(self.eventImage)
            self.containerView.addSubview(eventTitle)
            
            self.containerView.addSubview(self.eventRoad)
            self.containerView.addSubview(self.eventCityAndState)
            self.containerView.addSubview(self.eventPrice)
            self.containerView.addSubview(self.stackBtns)
            self.containerView.addSubview(self.eventDescription)
            self.containerView.addSubview(self.eventMap)
            
            self.detailEventViewModel.loadAddress(latitude: event.latitude, longitude: event.longitude, completion: { address in
                
                 var contentSize: CGFloat = 320
                
                self.eventTitle.text = event.title
                self.eventTitle.font = .boldSystemFont(ofSize: 20)
                self.eventTitle.numberOfLines = 0
                contentSize += self.estimatedHeightOfLabel(text: event.title, font: .boldSystemFont(ofSize: 20)) + 8
                
                self.eventRoad.text = address.road
                self.eventRoad.font = .systemFont(ofSize: 16)
                self.eventRoad.numberOfLines = 0
                self.eventRoad.textColor = .gray
                contentSize += self.estimatedHeightOfLabel(text: address.road, font: .systemFont(ofSize: 16)) + 8
                
                self.eventCityAndState.text = "\(address.city) - \(address.state)"
                self.eventCityAndState.numberOfLines = 0
                self.eventCityAndState.font = .systemFont(ofSize: 16)
                self.eventCityAndState.textColor = .gray
                contentSize += self.estimatedHeightOfLabel(text: "\(address.city) - \(address.state)", font: .systemFont(ofSize: 16)) + 8
                
                self.eventPrice.text = event.price.formatCurrency()
                self.eventPrice.numberOfLines = 0
                self.eventPrice.font = .systemFont(ofSize: 16)
                self.eventPrice.textColor = .gray
                contentSize += self.estimatedHeightOfLabel(text: event.price.formatCurrency(), font: .systemFont(ofSize: 16)) + 8
        
                self.stackBtns.distribution = .fillEqually
                self.stackBtns.alignment = .fill
                self.stackBtns.spacing = 10
                self.stackBtns.axis = .horizontal

                self.btnCheckin.setTitle("Check-in", for: .normal)
                self.btnCheckin.setTitleColor(.gray, for: .normal)
                self.btnCheckin.layer.borderColor = UIColor.gray.cgColor
                self.btnCheckin.layer.borderWidth = 1
                self.btnCheckin.layer.cornerRadius = 10
                
                self.btnShare.setTitle("Compartilhar", for: .normal)
                self.btnShare.setTitleColor(.gray, for: .normal)
                self.btnShare.layer.borderColor = UIColor.gray.cgColor
                self.btnShare.layer.borderWidth = 1
                self.btnShare.layer.cornerRadius = 10

                self.stackBtns.addArrangedSubview(self.btnCheckin)
                self.stackBtns.addArrangedSubview(self.btnShare)
                contentSize += 48
                
                self.eventDescription.text = event.description
                self.eventDescription.numberOfLines = 0
                self.eventDescription.font = .systemFont(ofSize: 17)
                contentSize += self.estimatedHeightOfLabel(text: self.eventDescription.text!, font: .systemFont(ofSize: 17))
                
                let latitude =  (event.latitude as NSString).doubleValue
                let longitude = (event.longitude as NSString).doubleValue
                
                self.setCoordinateInMap(latitude: latitude, longitude: longitude, title: event.title)
                
                contentSize += 290
                
                self.setNewContentSize(size: contentSize)
            })
        }
    }
    
    private func loadImage() {
        eventImage.kf.indicatorType = .activity
        eventImage.kf.setImage(with: URL(string: self.event!.image)) { result in
            switch result {
            case .success(let value):
                self.eventImage.image = value.image
            case .failure:
                self.eventImage.image = UIImage(named: "festa")
                self.eventImage.kf.cancelDownloadTask()
            }
        }
    }
    
    private func estimatedHeightOfLabel(text: String, font: UIFont) -> CGFloat {

        let size = CGSize(width: view.frame.width - 16, height: 1000)

        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

        let attributes = [NSAttributedString.Key.font: font]

        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height

        return rectangleHeight
    }
    
    private func setCoordinateInMap(latitude: CLLocationDegrees, longitude: CLLocationDegrees, title: String) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 200, longitudinalMeters: 200)
        
        self.eventMap.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = title
        self.eventMap.addAnnotation(annotation)
    }
    
    internal func setupConstraints() {
        self.eventImage.translatesAutoresizingMaskIntoConstraints = false
        self.eventTitle.translatesAutoresizingMaskIntoConstraints = false
        self.eventRoad.translatesAutoresizingMaskIntoConstraints = false
        self.eventCityAndState.translatesAutoresizingMaskIntoConstraints = false
        self.eventPrice.translatesAutoresizingMaskIntoConstraints = false
        self.eventDescription.translatesAutoresizingMaskIntoConstraints = false
        self.eventMap.translatesAutoresizingMaskIntoConstraints = false
        self.stackBtns.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.eventImage.topAnchor.constraint(equalTo: containerView.topAnchor),
            self.eventImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            self.eventImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            self.eventImage.heightAnchor.constraint(equalToConstant: 320),
            
            self.eventTitle.topAnchor.constraint(equalTo: self.eventImage.bottomAnchor, constant: 8),
            self.eventTitle.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 8),
            self.eventTitle.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 8),
            
            self.eventRoad.topAnchor.constraint(equalTo: self.eventTitle.bottomAnchor, constant: 8),
            self.eventRoad.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 8),
            self.eventRoad.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 8),
            
            self.eventCityAndState.topAnchor.constraint(equalTo: self.eventRoad.bottomAnchor, constant: 8),
            self.eventCityAndState.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 8),
            self.eventCityAndState.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 8),
            
            self.eventPrice.topAnchor.constraint(equalTo: self.eventCityAndState.bottomAnchor, constant: 8),
            self.eventPrice.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 8),
            self.eventPrice.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 8),
            
            self.stackBtns.topAnchor.constraint(equalTo: self.eventPrice.bottomAnchor, constant: 8),
            self.stackBtns.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 8),
            self.stackBtns.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -8),
            self.stackBtns.heightAnchor.constraint(equalToConstant: 30),
            
            self.eventDescription.topAnchor.constraint(equalTo: self.stackBtns.bottomAnchor, constant: 8),
            self.eventDescription.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 8),
            self.eventDescription.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -8),
            
            self.eventMap.topAnchor.constraint(equalTo: self.eventDescription.bottomAnchor, constant: 8),
            self.eventMap.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 8),
            self.eventMap.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -8),
            self.eventMap.heightAnchor.constraint(equalToConstant: 269),
            self.eventMap.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -8)
        ])
    }
    
    private func doCheckin(name: String, email: String) {
        self.detailEventViewModel.doCheckin(eventId: self.event!.id, name: name, email: email, completion: { result in
            if result {
                self.showAlert(title: "Sucesso", message: "Seu checkin foi realizado com sucesso")
            } else {
                self.showAlert(title: "Erro", message: "Algum erro ocorreu durante o check-in")
            }
        })
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func setNewContentSize(size: CGFloat) {
        
        self.containerView.frame.size.height = size
        self.scrollView.contentSize.height = size
    }
}
