//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Medina Huseynova on 31.07.25.
//
import AppMetricaCore

final class AnalyticsService {
    static let shared = AnalyticsService()
    
    private init() {}
    
    func activate() {
        print("AnalyticsService activated")
    }
    
    func reportEvent(event: String, screen: String, item: String? = nil) {
        var parameters: [String: Any] = [
            "event": event,
            "screen": screen
        ]
        if let item = item {
            parameters["item"] = item
        }
        
        AppMetrica.reportEvent(name: "user_action", parameters: parameters)
        print("[Analytics] user_action:", parameters)
    }
}
