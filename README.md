PathFinder README


File Explanations:
The Default view controller is controlled under PathFinderViewController. This View Controller collects the user’s name if it’s their first time using the app, and then tracks their movement as they walk around. This is the tracking half of the app, and the documentation dives further into specific functions that accomplish this task.

The next two view controllers, RouteTableViewController, and YourRouteTableViewController are table view controllers that list routes in two different ways. YourRouteTableViewController lists routes that the user has taken, while RouteTable ViewController lists routes that starts at the user’s current location. Both table cells are clickable, and change into a map view of the route controllers, and redefined in RouteTableViewCell and YourTableViewCell, respectively. Finally, the RouteDetail file is a small definition of functions to order the two tables based on distance or time. 

The final view controller, is PathFinderMapViewController. This view controller is linked to by all of the previous view controllers, and shows a route on a google map view. All the view controllers pass a route to this view controller, which then displays as a pop up inside the original view controller, allowing a user to go back and create a new route or view another route. 

How to Run:
In order to run the application through Xcode, the following packages must be installed:  
Social.framework  
  
   SystemConfiguration.framework  
  
  StoreKit.framework  
Security.framework  
  QuartzCore.framework  
  MobileCoreServices.framework
  libz.dylib
  CoreGraphics.framework
CFNetwork.framework
AudioToolbox.framework
Parse.framework
GoogleMaps.framework
libc++.dylib
OpenGLES.framework
libicucore.dylib
ImageIO.framework
GLKIt.framework
CoreData.framework
AVFoundation.framework
CoreLocation.framework
FacebookSDK.framework
UIKit.framework
Foundation.framework


To check or add directories, go to Build Settings, and then Link Binary with Libraries.

Once these directories are added, choose a build location, and press Run.
