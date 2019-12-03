//
//  RIBsTreeViewer.swift
//  RIBsTreeViewerClient
//
//  Created by yuki tamazawa on 2019/01/16.
//  Copyright © 2019 minipro. All rights reserved.
//

import Foundation
import RxSwift
import RIBs

public enum RIBsTreeViewerOptions: String {
    case webSocketURL
}

@available(iOS 13.0, *)
public class RIBsTreeViewer {

    private let router: Routing
    private let webSocket: WebSocketTaskConnection
    private let disposeBag = DisposeBag()

    public init(router: Routing, option: [RIBsTreeViewerOptions: String]? = nil) {
        let url = option?[.webSocketURL]
        self.router = router

        if let url = url {
            self.webSocket = WebSocketTaskConnection.init(url: URL(string: url)!)
        } else {
            self.webSocket = WebSocketTaskConnection.init(url: URL(string: "wc://0.0.0.0:8080")!)
        }
        self.webSocket.delegate = self
        self.webSocket.connect()
    }

    public func start() {
        Observable<Int>.interval(RxTimeInterval.microseconds(200), scheduler: MainScheduler.instance)
            .map { [unowned self] _ in
                self.tree(router: self.router)
        }
        .distinctUntilChanged { a, b in
            NSDictionary(dictionary: a).isEqual(to: b)
        }
        .subscribe(onNext: { [weak self] in
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: $0)
                let jsonString = String(bytes: jsonData, encoding: .utf8)!
                self?.webSocket.send(text: jsonString)
            } catch {
                print(error)
            }
        })
            .disposed(by: disposeBag)
    }

    private func tree(router: Routing, appendImage: Bool = false) -> [String: Any] {
        var currentRouter = String(describing: type(of: router))
        if router is ViewableRouting {
            currentRouter += " (View) "
        }
        if router.children.isEmpty {
            return ["name": currentRouter, "children": []]
        } else {
            return ["name": currentRouter, "children": router.children.map { tree(router: $0, appendImage: appendImage) }]
        }
    }

    private func findRouter(target: String, router: Routing) -> Routing? {
        let currentRouter = String(describing: type(of: router))
        if target == currentRouter {
            return router
        } else if !router.children.isEmpty {
            return router.children.compactMap { findRouter(target: target, router: $0) }.first
        } else {
            return nil
        }
    }

    private func captureView(from targetRouter: String) -> Data? {
        guard let router = findRouter(target: targetRouter, router: router) as? ViewableRouting,
            let view = router.viewControllable.uiviewController.view,
            let captureImage = image(with: view) else {
                return nil
        }
        return captureImage.pngData()
    }

    private func image(with view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
}

@available(iOS 13.0, *)
extension RIBsTreeViewer: WebSocketConnectionDelegate {

    func onConnected(connection: WebSocketConnection) {
    }

    func onDisconnected(connection: WebSocketConnection, error: Error?) {
    }

    func onError(connection: WebSocketConnection, error: Error) {
    }

    func onMessage(connection: WebSocketConnection, text: String) {
        // text == routerName
        DispatchQueue.main.async {
            if let data = self.captureView(from: text) {
                self.webSocket.send(data: data)
            }
        }
    }

    func onMessage(connection: WebSocketConnection, data: Data) {
    }

}
