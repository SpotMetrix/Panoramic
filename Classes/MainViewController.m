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

#define PANO_SPHERE_TEXTURE_NAME @"sphere.pano" // Can be .png or .jpg
#define PANO_CUBE_TEXTURE_NAME @"cube.pano"

@implementation MainViewController

@synthesize point;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedController];
    sm3dar.delegate = self;
    [self.view addSubview:sm3dar.view];
    
    // Since 3darLocationServicesDisabled is set to YES in 3dar.plist, 
    // call loadPointsOfInterest directly.
    [self loadPointsOfInterest];
    
}

- (void) addFixtureWithView:(SM3DAR_PointView*)pointView 
{
    // create point
    self.point = [[SM3DAR_Fixture alloc] init];
    
    // give point a view
    point.view = pointView;  
    
    // add point to 3DAR scene
    SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedController];  
    [sm3dar addPointOfInterest:point];
}

- (void) addSphereWithTextureNamed:(NSString*)textureName 
{
    SphereView *sphereView = [[SphereView alloc] initWithTextureNamed:textureName];
    [self addFixtureWithView:sphereView];
    [sphereView release];
}

- (void) addCubeWithTextureNamed:(NSString*)textureName 
{
    CubeView *cubeView = [[CubeView alloc] initWithTextureNamed:textureName];
    [self addFixtureWithView:cubeView];
    [cubeView release];
}

- (BOOL) validImage:(UIImage*)image 
{
	return (image && image.size.width > 0.0 && image.size.height > 0.0);    
}

#pragma mark -
- (void) loadPointsOfInterest 
{
    // NOTE: If you are having trouble updating the images, 
    // trying doing a clean build, and also uninstall the app.
    
    // Try loading the spherical PNG first.
    NSString *textureName = [PANO_SPHERE_TEXTURE_NAME stringByAppendingString:@".png"];
    NSLog(@"Attempting to load %@", textureName);
    UIImage *texture = [UIImage imageNamed:textureName];

    // Next try loading the spherical JPG.    
    if (![self validImage:texture])
    {
        textureName = [PANO_SPHERE_TEXTURE_NAME stringByAppendingString:@".jpg"];
        NSLog(@"Attempting to load %@", textureName);
        texture = [UIImage imageNamed:textureName];
    }        
    
    // Use the spherical image if one was found.
    if ([self validImage:texture])
    {
        [self addSphereWithTextureNamed:textureName];
        return;
    } 
    
    // If no spherical image was found, try loading a cubical PNG.
    textureName = [PANO_CUBE_TEXTURE_NAME stringByAppendingString:@".png"];
    NSLog(@"Attempting to load %@", textureName);
    texture = [UIImage imageNamed:textureName];  

    // Next try loading the cubical JPG.    
	if (![self validImage:texture])
    {
        textureName = [PANO_CUBE_TEXTURE_NAME stringByAppendingString:@".jpg"];
        NSLog(@"Attempting to load %@", textureName);
        texture = [UIImage imageNamed:textureName];
    }        
    
    if (![self validImage:texture])
    {
        [self addCubeWithTextureNamed:textureName];
        return;
        
    } 
    else 
    {
        NSLog(@"\n\n\nNo texture images found. Please include either %@ or %@ .png or .jpg in your app's resource bundle.\n\n\n", 
              PANO_SPHERE_TEXTURE_NAME, PANO_CUBE_TEXTURE_NAME);
    }
    
    [[SM3DAR_Controller sharedController] resume];
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

- (void)dealloc 
{
    [point release];
    [super dealloc];
}

- (void)logoWasTapped 
{
	[self showInfo];    
}

@end
