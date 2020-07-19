//
//  WeatherWeekdayCells.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 20/05/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

import UIKit

final class WeatherWeekdayCells: UITableViewCell {
    
    @IBOutlet weak var imageViewIcon: UIImageView?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var temperatureLabel: UILabel?
    
    static let identifier = "WeekCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    func configure(_ weatherData: WeatherModel) {
        self.imageViewIcon?.image = UIImage(named: weatherData.weatherStateAbbr) ?? UIImage()
        self.temperatureLabel?.text = (String(format: "%.1fºC ", weatherData.theTemp))
        self.dateLabel?.text = weatherData.applicableDate.string(format: .short)
    }
}
