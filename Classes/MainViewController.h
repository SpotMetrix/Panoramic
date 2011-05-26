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

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, SM3DARDelegate, MKMapViewDelegate> 
{
    IBOutlet SM3DARMapView *mapView;
}

@property (nonatomic, retain) IBOutlet SM3DARMapView *mapView;

- (IBAction)showInfo;

@end
