import bb.cascades 1.3
import Network.LoginController 1.0
import bb.cascades 1.2

TabbedPane {
    id: mainTab
    showTabsOnActionBar: false
    activeTab: tabHome
    
    Menu.definition: MenuDefinition {
        actions: [
            ActionItem {
                title: qsTr("Policy")
                imageSource: "asset:///images/icon_about.png"
                onTriggered: {
                    about.open();
                }
            },
            ActionItem {
                title: qsTr("Settings")
                imageSource: "asset:///images/icon_settings.png"
                onTriggered: {
                    settings.open();
                }
            },
            ActionItem {
                title: loginController.notif ? " [ON]" : " [OFF]"
                imageSource: "asset:///images/icon_notification.png"
                onTriggered: {
                    loginController.notif = !loginController.notif;
                }
            
            }
        ]
    }  
    
    
    Tab { //First tab
        // Localized text with the dynamic translation and locale updates support
        id: tabHome
        title: qsTr("Contacts") + Retranslate.onLocaleOrLanguageChanged
        ActionBar.placement: ActionBarPlacement.OnBar
        imageSource: "asset:///images/contact.png"
        
        delegateActivationPolicy: TabDelegateActivationPolicy.Default
        
        delegate: Delegate {
            source: "Contacts.qml"
        }
    
    } //End of home tab
    
    /*
    Tab {
        id: tabRoom
        title: qsTr("Rooms")
        ActionBar.placement: ActionBarPlacement.OnBar
        imageSource: "asset:///images/chat_room.png"
        
        delegate: Delegate {
            source: "Rooms.qml"
        }

    }
    */
    
    Tab {
        id: tabDrive
        title: qsTr("Drive")
        ActionBar.placement: ActionBarPlacement.InOverflow
        imageSource: "asset:///images/icon_drive.png"
        
        delegate: Delegate {
            source: "Drive.qml"
        }
    }
    
    onCreationCompleted: {
        if(!loginController.isLogged()) {
            welcome.open();
        }
    }
        
    attachedObjects: [
        Delegate {
            id: welcomeDelegate
            source: "Welcome.qml"
            
        },
        Sheet {
            id: welcome
            content: welcomeDelegate.object
            onOpenedChanged: {
                if (opened)
                    welcomeDelegate.active = true;
            }
            onClosed: {
                welcomeDelegate.active = false;
            }
        },
        Sheet {
            id: settings
            Settings {
                onDone: {
                    settings.close();
                }
            }
        },
        Sheet {
            id: about
            Policy {
                onDone: {
                    about.close();
                }
            }
        },
        LoginController {
            id: loginController
       }
    ]
    
}




