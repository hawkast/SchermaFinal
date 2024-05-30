// PollingManager.swift
import Foundation

class PollingManager<T>: ObservableObject {
    let pollingInterval: TimeInterval
    private var pollingTimer: Timer?
    private var pollingAction: (() -> Void)?

    var isPolling: Bool {
        return pollingTimer != nil
    }

    init(pollingInterval: TimeInterval) {
        self.pollingInterval = pollingInterval
    }

    func startPolling(pollingAction: @escaping () -> Void) {
        self.pollingAction = pollingAction
        if pollingTimer == nil {
            self.pollingTimer = Timer.scheduledTimer(
                withTimeInterval: pollingInterval,
                repeats: true
            ) { _ in
                self.pollingAction?()
            }
        }
    }

    func stopPolling() {
        pollingTimer?.invalidate()
        pollingTimer = nil
        pollingAction = nil
    }
}
