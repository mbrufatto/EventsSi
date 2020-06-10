//
//  EventTableViewCell.swift
//  EventsSi
//
//  Created by Marcio Habigzang Brufatto on 09/06/20.
//  Copyright © 2020 Mantra Tech. All rights reserved.
//

import UIKit
import Kingfisher

class EventTableViewCell: UITableViewCell {
    
    static let identifier = "EventTableViewCell"
    
    fileprivate let eventImage = UIImageView()
    fileprivate let eventDate = UILabel()
    fileprivate let eventTitle = UILabel()
    fileprivate let eventPlace = UILabel()
    
    private var networkManagerProtocol: NetworkManagerProtocol!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.networkManagerProtocol = NetworkManager()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var event: Event! {
        didSet {
            self.setupEventImage()
            eventDate.text = event.date
            eventTitle.text = event.title
            
            self.networkManagerProtocol.getAddressByLatitudeAndLongitude(latitude: event.latitude, longitude: event.longitude, completion: { address in
                self.eventPlace.text = "\(address.road) - \(address.city)"
            })
        }
    }
    
    private func setupEventImage() {
        eventImage.kf.indicatorType = .activity
        eventImage.kf.setImage(with: URL(string: event.image)) { result in            
            switch result {
            case .success(let value):
                self.eventImage.image = value.image
            case .failure:
                self.eventImage.image = UIImage(named: "festa")
                self.eventImage.kf.cancelDownloadTask()
            }
        }
    }
    
    func setupViews() {
        eventImage.translatesAutoresizingMaskIntoConstraints = false
        eventDate.translatesAutoresizingMaskIntoConstraints = false
        eventTitle.translatesAutoresizingMaskIntoConstraints = false
        eventPlace.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(eventImage)
        contentView.addSubview(eventDate)
        contentView.addSubview(eventTitle)
        contentView.addSubview(eventPlace)
        
        eventImage.contentMode = .scaleToFill
        eventImage.layer.cornerRadius = 5.0
        eventImage.clipsToBounds = true
        
        eventTitle.font = .boldSystemFont(ofSize: 16.0)
        eventTitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        eventTitle.lineBreakMode = .byTruncatingTail
        eventDate.font = .systemFont(ofSize: 14)
        eventDate.textColor = .orange
        eventPlace.font = .systemFont(ofSize: 14)
        eventPlace.textColor = .gray
        eventPlace.numberOfLines = 0
        
        let marginGuide = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            eventImage.widthAnchor.constraint(equalToConstant: 110),
            eventImage.heightAnchor.constraint(equalToConstant: 80),
            eventImage.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 8),
            eventImage.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            eventImage.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            eventTitle.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 8),
            eventTitle.leadingAnchor.constraint(equalTo: eventImage.trailingAnchor, constant: 8),
            eventTitle.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            eventDate.topAnchor.constraint(equalTo: eventTitle.bottomAnchor, constant: 10),
            eventDate.leadingAnchor.constraint(equalTo: eventImage.trailingAnchor, constant: 8),
        ])
        
        NSLayoutConstraint.activate([
            eventPlace.topAnchor.constraint(equalTo: eventDate.bottomAnchor, constant: 8),
            eventPlace.leadingAnchor.constraint(equalTo: eventImage.trailingAnchor, constant: 8),
            eventPlace.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            eventPlace.bottomAnchor.constraint(equalTo: eventImage.bottomAnchor)
        ])
    }
}
