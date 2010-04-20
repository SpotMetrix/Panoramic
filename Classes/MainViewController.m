//
//  MainViewController.m
//  Panoramic
//
//  Created by P. Mark Anderson on 2/20/10.
//  Copyright Spot Metrix, Inc. 2010. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "SphereView.h"
#import "CubeView.h"

#define PANO_SPHERE_TEXTURE_NAME @"sphere.pano.png"
#define PANO_CUBE_TEXTURE_NAME @"cube.pano.png"

@implementation MainViewController

@synthesize point;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedController];
  sm3dar.delegate = self;
  [self.view addSubview:sm3dar.view];  
  [self.view sendSubviewToBack:sm3dar.view];  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];  
}

- (void) addFixtureWithView:(SM3DAR_PointView*)pointView {
  // create point
  self.point = [[SM3DAR_Fixture alloc] init];

  // give point a view
  point.view = pointView;  

  // add point to 3DAR scene
  SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedController];  
  [sm3dar addPointOfInterest:point];
}

- (void) addSphereWithTextureNamed:(NSString*)textureName {
  NSLog(@"Loading sphere texture: %@", textureName);
  SphereView *sphereView = [[SphereView alloc] initWithTextureNamed:textureName];
  [self addFixtureWithView:sphereView];
  [sphereView release];
}

- (void) addCubeWithTextureNamed:(NSString*)textureName {
  NSLog(@"Loading cube texture: %@", textureName);
  CubeView *cubeView = [[CubeView alloc] initWithTextureNamed:textureName];
  [self addFixtureWithView:cubeView];
  [cubeView release];
}

#pragma mark -
- (void) loadPointsOfInterest {
  NSString *textureName = PANO_SPHERE_TEXTURE_NAME;
  UIImage *texture = [UIImage imageNamed:textureName];
  
  if (texture) {
    [self addSphereWithTextureNamed:textureName];
    return;
  } 
  
  textureName = PANO_CUBE_TEXTURE_NAME;
  texture = [UIImage imageNamed:textureName];  
  
  if (texture) {
    [self addCubeWithTextureNamed:textureName];
    return;
    
  } else {
    NSLog(@"\n\n\nNo texture images found. Please include either %@ or %@ in your app's resource bundle.\n\n\n", 
        PANO_SPHERE_TEXTURE_NAME, PANO_CUBE_TEXTURE_NAME);
  }

}

#pragma mark -
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo {
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
  [point release];
  [super dealloc];
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation 
{
  NSLog(@"Stopping location updates");
  [manager stopUpdatingLocation];
}

- (void)logoWasTapped {
	[self showInfo];    
}

@end
