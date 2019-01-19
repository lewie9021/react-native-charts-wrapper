//
//  ChartDateFormatter.swift
//  Charts
//
//  Created by lewie9021 on 2019/01/19.
//

import Foundation
import Charts

open class BarLineChartDateFormatter: NSObject, IValueFormatter, IAxisValueFormatter {
    open var chart: BarLineChartViewBase;
    open var timeUnit: String;
    
    public init(chart: BarLineChartViewBase, timeUnit: String) {
        self.chart = chart;
        self.timeUnit = timeUnit;
    }
    
    open func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return format(value)
    }
    
    open func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return format(value)
    }
    
    fileprivate func convertValueToMilliseconds(_ value: Double, _ timeUnit: String) -> Double {
        switch timeUnit {
        case "MILLISECONDS":
            return value / 1000.0
        case "SECONDS":
            return value;
        case "MINUTES":
            return value * 60
        case "HOURS":
            return value * 60 * 60
        case "DAYS":
            return value * 60 * 60 * 24
        default:
            return value / 1000.0
        }
    }
    
    fileprivate func getFormattedDate(_ date: Date, _ format: String) -> String {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = format;
        
        return dateFormatter.string(from: date);
    }
    
    fileprivate func format(_ value: Double) -> String {
        // Value is in seconds, even though the date set is milliseconds...
        let valueInMilliseconds = convertValueToMilliseconds(value, self.timeUnit);
        
        let date = Date(timeIntervalSince1970: valueInMilliseconds);
        let second = 1000.0;
        let minute = second * 60.0;
        let hour = minute * 60.0;
        let day = hour * 24.0;
        let month = day * 30.0;
        
        let dateFormatter = DateFormatter();
        let chartXAxis = self.chart.xAxis;
        
        // Get formatted year.
        // getFormattedDate(date, "yyyy");
        dateFormatter.dateFormat = "yyyy";
        let yearText = String(dateFormatter.string(from: date).suffix(2));
        
        // Get formatted month.
        // getFormattedDate(date, "MMM");
        dateFormatter.dateFormat = "MMM";
        let monthText = dateFormatter.string(from: date);
        
        if (chart.visibleXRange > month * 6.0) {
            chartXAxis.labelCount = 5;
            chartXAxis.axisMaxLabels = 5;
            
            return monthText + " '" + yearText;
        } else {
            chartXAxis.labelCount = 3;
            chartXAxis.axisMaxLabels = 3;
            
            dateFormatter.dateFormat = "d";
            let dayText = dateFormatter.string(from: date);
            
            return dayText + " " + monthText + " '" + yearText;
        }
    }
    
}