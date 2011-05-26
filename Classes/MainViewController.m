//
//  MainViewController.m
//  Panoramic
//
//  Created by P. Mark Anderson on 2/20/10.
//  Copyright Spot Metrix, Inc. 2010. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"

@implementation MainViewController

@synthesize mapView;

- (void)dealloc 
{
    [mapView release];
    [super dealloc];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];    
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    
    [SM3DARMapView class];

    [mapView.sm3dar hideMap];
    
    // Since 3darLocationServicesDisabled is set to YES in 3dar.plist
    // load points manually.
    
    [self sm3darLoadPoints:mapView.sm3dar];    
}

- (SM3DARFixture *) addFixtureWithView:(UIView *)pointView atWorldCoordinate:(Coord3D)coord
{
    // Add a fixture to the scene. 
    // Fixtures are positioned relative to the camera perspective.
    
    SM3DARFixture *fixture = [[[SM3DARFixture alloc] init] autorelease];
    fixture.view = pointView;  

    [mapView.sm3dar addPointOfInterest:fixture];
    
    fixture.worldPoint = coord;
    
    return fixture;
}

#pragma mark -

- (void) addNorthLabel
{
    SM3DARRoundedLabel *exampleView = [[[SM3DARRoundedLabel alloc] init] autorelease];
    [exampleView setText:@"North" adjustSize:YES];
    
    Coord3D coord;
    coord.x = 0.0;
    coord.y = 1000.0;
    coord.z = 10.0;
    
    [self addFixtureWithView:exampleView atWorldCoordinate:coord];    
}

- (void) sm3darLoadPoints:(SM3DARController *)sm3dar
{
    // Add points to the 3DAR scene.
    
    [self addNorthLabel];

    [mapView addBackground];    
}

#pragma mark -
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller 
{
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo 
{
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

#pragma mark -

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)logoWasTapped 
{
	[self showInfo];    
}

@end
