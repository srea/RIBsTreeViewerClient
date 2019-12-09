![](https://img.shields.io/github/license/srea/RIBsTreeViewerClient.svg) 
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
# RIBsTreeViewer

![](./docs/logo.png)  

Real Time viewing attached RIBs Tree on Browser

## Demo

![](./docs/demo.gif)  

## Carthage

### Cartfile

```shell
github "srea/RIBsTreeViewerClient"
```

### Build Phase

![](./docs/Carthage_BuildPhase.png)  
![](./docs/Carthage_Embedded.png)

Carthage CopyFrameworks (ONLY DEBUG)

```shell
 if [ ${CONFIGURATION%%-*} == "Debug" ]; then
    /usr/local/bin/carthage copy-frameworks
 fi
```

### Implementation

```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        ... 

        launchRouter.launch(from: window)
        #if DEBUG
        startRIBsTreeViewer(launchRouter: launchRouter)
        #endif
        return true
    }

}

// MARK: - RIBsTreeViewer

#if DEBUG
import RIBsTreeViewerClient

@available(iOS 13.0, *)
var RIBsTreeViewerHolder: RIBsTreeViewerImpl? = nil

extension AppDelegate {
    private func startRIBsTreeViewer(launchRouter: Routing) {
        if #available(iOS 13.0, *) {
            RIBsTreeViewerHolder = RIBsTreeViewerImpl.init(router: launchRouter,
                                                           option: [.webSocketURL: "ws://192.168.1.10:8080/"])
            RIBsTreeViewerHolder?.start()
        } else {
            DEBUGLOG { "RIBsTreeViewer is not supported on this OS version." }
        }
    }
}
#endif

```

## WebSocket Server

```shell
$ yarn install
$ node index.js
```

## Browser

```shell
$ yarn install
$ npx webpack
$ open ./public/index.html
```
