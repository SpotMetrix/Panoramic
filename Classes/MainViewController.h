//
//  MainViewController.h
//  Panoramic
//
//  Created by P. Mark Anderson on 2/20/10.
//  Copyright Spot Metrix, Inc. 2010. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "FlipsideViewController.h"
#import "SM3DAR.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, SM3DAR_Delegate> 
{
  SM3DAR_Point *point;
}

@property (nonatomic, retain) SM3DAR_Point *point;

- (IBAction)showInfo;
- (void) addSphereWithTextureNamed:(NSString*)textureName;
- (void) addCubeWithTextureNamed:(NSString*)textureName;

@end
