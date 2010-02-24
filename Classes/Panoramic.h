//
//  PanoramicAppDelegate.h
//  Panoramic
//
//  Created by P. Mark Anderson on 2/20/10.
//  Copyright Spot Metrix, Inc. 2010. All rights reserved.
//

@class MainViewController;

@interface Panoramic : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;

@end

