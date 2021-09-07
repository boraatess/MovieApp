//
//  SplashViewController.swift
//  OmdbMovieApp
//
//  Created by bora on 2.09.2021.
//

import UIKit
import Firebase

class SplashViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    let screen = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
        setupRemoteConfigDefaults()
        fetchRemoteConfig()
        titleLabel.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+4) {
            let nav = UINavigationController(rootViewController: ListViewController())
            nav.modalPresentationStyle = .fullScreen
            //self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    func setupRemoteConfigDefaults() {
        // let defaultValues = ["labelText" : "LOODOS" as NSObject ]
        //RemoteConfig.remoteConfig().setDefaults(defaultValues)
    }
    
    func fetchRemoteConfig() {
        let debugSettings = RemoteConfigSettings()
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        remoteConfig.configSettings = settings
        RemoteConfig.remoteConfig().configSettings = debugSettings
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: 2) { [weak self] (status, error) in
            guard error == nil else {
                print("Got an error fetching remote values \(error?.localizedDescription ?? "error")")
                let alert = UIAlertController(title: "Network Connection Error", message: "Please check your wifi/cellular connection", preferredStyle: .alert)
                let action = UIAlertAction(title: "Go Settings", style: .default) { (action) in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }
                let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    }
                }
                alert.addAction(cancel)
                alert.addAction(action)
                self?.present(alert, animated: true, completion: nil)
                return
            }
            print("Retrieved values from the cloud!")
            self?.titleLabel.isHidden = false
            RemoteConfig.remoteConfig().fetchAndActivate()
            self?.updateRemoteConfigValues()
        }
    }
    
    func updateRemoteConfigValues() {
        let labelText = RemoteConfig.remoteConfig().configValue(forKey: "labelText").stringValue ?? ""
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        print("Label text: \(labelText)")
        titleLabel.text = labelText
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) {
            let vc = ListRouter().prepareView()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
}
