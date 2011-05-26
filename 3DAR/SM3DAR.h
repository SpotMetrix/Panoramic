/*
 *  3DAR Version 0.9.5
 *
 *  SM3DAR.h
 *
 *  Copyright 2009 Spot Metrix, Inc. All rights reserved.
 *  http://3DAR.us
 *
 */

#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>


/*************************************************
 
 //
 // Typical usage: 
 //
 - (void) viewDidLoad 
 {
 self.mapView = [[[SM3DARMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)] autorelease]; 
 mapView.delegate = self;
 mapView.showsUserLocation = YES;
 
 [self.view addSubview:mapView];    
 
 [mapView init3DAR];
 } 
 
 - (void) sm3darLoadPoints:(SM3DARController *)sm3dar
 { 
 [mapView addAnnotation:myAnnotation];
 }
 
 ************************************************/

@protocol SM3DARPointProtocol;
@class SM3DARController;
typedef NSObject<SM3DARPointProtocol> SM3DARPoint;


//
//
//
@protocol SM3DARDelegate
@optional
- (void) sm3darViewDidLoad:(SM3DARController *)sm3dar;
- (void) sm3darLoadPoints:(SM3DARController *)sm3dar;
- (void) sm3dar:(SM3DARController *)sm3dar didChangeFocusToPOI:(SM3DARPoint*)newPOI fromPOI:(SM3DARPoint*)oldPOI;
- (void) sm3dar:(SM3DARController *)sm3dar didChangeSelectionToPOI:(SM3DARPoint*)newPOI fromPOI:(SM3DARPoint*)oldPOI;
- (void) sm3dar:(SM3DARController *)sm3dar didChangeOrientationYaw:(CGFloat)yaw pitch:(CGFloat)pitch roll:(CGFloat)roll;
- (void) sm3darWillInitializeOrigin:(SM3DARController *)sm3dar;
- (void) sm3darLogoWasTapped:(SM3DARController *)sm3dar;
- (void) sm3darDidShowMap:(SM3DARController *)sm3dar;
- (void) sm3darDidHideMap:(SM3DARController *)sm3dar;
- (void) mapAnnotationView:(MKAnnotationView*)annotationView calloutAccessoryControlTapped:(UIControl*)control;
@end

@protocol SM3DARMarkerCalloutViewDelegate
- (void) calloutViewWasTappedForPoint:(SM3DARPoint *)point;
@end

@class SM3DARMarkerCalloutView;

@interface SM3DARMapView : MKMapView <SM3DARDelegate, MKMapViewDelegate, SM3DARMarkerCalloutViewDelegate> {}

@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, retain) SM3DARMarkerCalloutView *calloutView;
@property (nonatomic, retain) UIView *hudView;
@property (nonatomic, retain) SM3DARController *sm3dar;
@property (nonatomic, assign) CGFloat mapZoomPadding;

- (void) init3DAR;
- (void) add3darContainer:(SM3DARController *)sm3dar;
- (void) zoomMapToFitPointsIncludingUserLocation:(BOOL)includeUser;
- (void) zoomMapToFit;
- (void) startCamera;
- (void) stopCamera;
- (void) addBackground;
- (void) moveToLocation:(CLLocation *)newLocation;
- (void) removeAllAnnotations;

@end

@interface SM3DARBasicPointAnnotation : MKPointAnnotation 
@property (nonatomic, retain) NSString *imageName;
@end


///////////////////////////
// Advanced usage follows.
///////////////////////////

@class SM3DARPointOfInterest;		
@class SM3DARSession;
@class SM3DARFocusView;

typedef struct
{
    CGFloat x, y, z;
} Coord3D;


//
//
//
@protocol SM3DARPointProtocol

@property (nonatomic, assign) Coord3D worldPoint;
@property (nonatomic, retain) UIView *view;
@property (nonatomic, retain) NSObject<SM3DARDelegate> *selectionDelegate;
@property (nonatomic, assign) BOOL canReceiveFocus;
@property (nonatomic, assign) BOOL hasFocus;
@property (nonatomic, assign) NSUInteger identifier;
@property (nonatomic, retain) NSString *title;

- (Coord3D) worldCoordinate;
- (void) translateX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;
- (Coord3D) unitVectorFromOrigin;

@optional

@property (nonatomic, assign) Coord3D worldPointVector;
- (void) step;

@end


@class SM3DARController;


//
//
//
@protocol SM3DARFocusDelegate

-(void)pointDidGainFocus:(SM3DARPoint*)point;
@optional
-(void)pointDidLoseFocus:(SM3DARPoint*)point;
-(void)updatePositionAndOrientation:(CGFloat)screenOrientationRadians;

@end


//
//
//
@interface SM3DARController : UIViewController <UIAccelerometerDelegate, CLLocationManagerDelegate, MKMapViewDelegate> {
}

@property (assign) BOOL mapIsVisible;
@property (assign) BOOL originInitialized;
@property (nonatomic, retain) MKMapView *map;
@property (nonatomic, retain) UILabel *statusLabel;
@property (nonatomic, retain) UIImagePickerController *camera;
@property (nonatomic, assign) NSObject<SM3DARDelegate> *delegate;
@property (nonatomic, retain) NSArray *pointsOfInterest;
@property (nonatomic, retain) SM3DARPoint *focusedPOI;
@property (nonatomic, retain) SM3DARPoint *selectedPOI;
@property (nonatomic, assign) Class markerViewClass;
@property (nonatomic, retain) NSString *mapAnnotationImageName;
@property (nonatomic, retain) NSObject<SM3DARFocusDelegate> *focusView;
@property (nonatomic, assign) CGFloat screenOrientationRadians;
@property (nonatomic, retain) UIView *glView;
@property (nonatomic, retain) UIView *hudView;
@property (nonatomic, retain) UIView *compassView;
@property (nonatomic, assign) CGFloat nearClipMeters;
@property (nonatomic, assign) CGFloat farClipMeters;
@property (assign) NSTimeInterval locationUpdateInterval;
@property (nonatomic, assign) Coord3D worldPointTransform;
@property (nonatomic, assign) Coord3D worldPointVector;
@property (nonatomic, retain) UIButton *iconLogo;
@property (nonatomic, retain) CLLocation *userLocation;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLHeading *heading;
@property (nonatomic, assign) Coord3D currentPosition;
@property (nonatomic, assign) Coord3D downVector;
@property (nonatomic, assign) Coord3D northVector;
@property (nonatomic, assign) CGFloat currentYaw;
@property (nonatomic, assign) CGFloat currentPitch;
@property (nonatomic, assign) CGFloat currentRoll;
@property (nonatomic, assign) CGFloat mapZoomPadding;
@property (nonatomic, assign) CGFloat cameraAltitudeMeters;
@property (nonatomic, assign) BOOL running;
@property (nonatomic, retain) SM3DARPoint *backgroundPoint;

+ (void)printMemoryUsage:(NSString*)message;
+ (void)printMatrix:(CATransform3D)t;
+ (Coord3D) worldCoordinateFor:(CLLocation*)location;
+ (Coord3D) unitVector:(Coord3D)coord;
- (id)initWithDelegate:(NSObject<SM3DARDelegate> *)delegate;
- (void)forceRelease;
- (void)setFrame:(CGRect)newFrame;
- (void)addPoint:(SM3DARPoint*)point;
- (void)addPointOfInterest:(SM3DARPoint*)point;
- (void)addPointsOfInterest:(NSArray*)points;
- (void)addPointsOfInterest:(NSArray*)points addToMap:(BOOL)addToMap;
- (void)removePointOfInterest:(SM3DARPoint*)point removeFromMap:(BOOL)removeFromMap;
- (void)removePointOfInterest:(SM3DARPoint*)point;
- (void)removePointsOfInterest:(NSArray*)points removeFromMap:(BOOL)removeFromMap;
- (void)removePointsOfInterest:(NSArray*)points;
- (void)removeAllPointsOfInterest;
- (void)removeAllPointsOfInterest:(BOOL)removeFixtures;
- (void)replaceAllPointsOfInterestWith:(NSArray*)points;
- (NSString*)loadJSONFromFile:(NSString*)fileName;
- (void)loadMarkersFromJSONFile:(NSString*)fileName;
- (void)loadMarkersFromJSON:(NSString*)json;
- (NSString*)loadCSVFromFile:(NSString*)fileName;
- (void)loadMarkersFromCSVFile:(NSString*)fileName hasHeader:(BOOL)hasHeader;
- (void)loadMarkersFromCSV:(NSString*)csv hasHeader:(BOOL)hasHeader;
- (SM3DARPointOfInterest*)initPointOfInterest:(NSDictionary*)properties;
- (SM3DARPointOfInterest*)initPointOfInterestWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude altitude:(CGFloat)altitude title:(NSString*)poiTitle subtitle:(NSString*)poiSubtitle markerViewClass:(Class)poiMarkerViewClass properties:(NSDictionary*)properties;
- (SM3DARPointOfInterest*)initPointOfInterest:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude altitude:(CGFloat)altitude title:(NSString*)poiTitle subtitle:(NSString*)poiSubtitle markerViewClass:(Class)poiMarkerViewClass properties:(NSDictionary*)properties;
- (void)addPointOfInterestWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude altitude:(CGFloat)altitude title:(NSString*)poiTitle subtitle:(NSString*)poiSubtitle markerViewClass:(Class)poiMarkerViewClass properties:(NSDictionary*)properties;
- (BOOL)changeCurrentLocation:(CLLocation*)newLocation;
- (BOOL)displayPoint:(SM3DARPoint*)poi;
- (void)startCamera;
- (void)stopCamera;
- (void)suspend;
- (void)resume;
- (CATransform3D)cameraTransform;
- (Coord3D)cameraPosition;
- (void)debug:(NSString*)message;
- (CGRect)logoFrame;
- (BOOL)isTiltLookMode;
- (void)toggleLookMode;
- (NSString*)exportPointsOfInterestAsJSON;
- (NSString*)exportPointsOfInterestAsCSV;
- (void)initMap;
- (void)toggleMap;
- (void)showMap;
- (void)hideMap;
- (void)zoomMapToFit;
- (void)zoomMapToFitPointsIncludingUserLocation:(BOOL)includeUser;
- (void)setCurrentMapLocation:(CLLocation *)location;
- (void)fadeMapToAlpha:(CGFloat)alpha;
- (BOOL)setMapVisibility;
- (void)annotateMap;
- (void)centerMapOnCurrentLocation;
- (Coord3D)solarPosition;
- (Coord3D)solarPositionScaled:(CGFloat)meters;
- (void)initOrigin;
- (Coord3D)ray:(CGPoint)screenPoint;
- (void) setCameraAltitudeMeters:(CGFloat)altitude;
- (void) setCameraPosition:(Coord3D)coordRelativeToOrigin;

@end


//
//
//
@interface SM3DARFixture : NSObject <SM3DARPointProtocol> {
}

@property (nonatomic, assign) CGFloat gearPosition;
@property (nonatomic, assign) BOOL canReceiveFocus;
@property (nonatomic, assign) BOOL hasFocus;
@property (nonatomic, assign) NSUInteger identifier;
@property (nonatomic, retain) NSString *title;

- (CGFloat)gearSpeed;
- (NSInteger)numberOfTeethInGear;
- (void) gearHasTurned;
- (Coord3D) unitVectorFromOrigin;

@end


//
//
//
@interface SM3DARPointOfInterest : CLLocation <MKAnnotation, SM3DARPointProtocol> {
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSDictionary *properties;
@property (nonatomic, retain) NSURL *dataURL;
@property (nonatomic, assign) NSObject<SM3DARDelegate> *delegate;
@property (nonatomic, retain) UIView *view;
@property (nonatomic, assign) Class annotationViewClass;
@property (nonatomic, retain) NSString *mapAnnotationImageName;
@property (nonatomic, assign) BOOL canReceiveFocus;
@property (nonatomic, assign) BOOL hasFocus;
@property (nonatomic, assign) NSUInteger identifier;
@property (nonatomic, assign) CGFloat gearPosition;

- (id)initWithLocation:(CLLocation*)loc properties:(NSDictionary*)props;
- (id)initWithLocation:(CLLocation*)loc title:(NSString*)title subtitle:(NSString*)subtitle url:(NSURL*)url;
- (CGFloat)distanceInMetersFrom:(CLLocation*)otherPoint;
- (CGFloat)distanceInMetersFromCurrentLocation;
- (NSString*)formattedDistanceInMetersFrom:(CLLocation*)otherPoint;
- (NSString*)formattedDistanceInMetersFromCurrentLocation;
- (CGFloat)distanceInMilesFrom:(CLLocation*)otherPoint;
- (CGFloat)distanceInMilesFromCurrentLocation;
- (NSString*)formattedDistanceInMilesFrom:(CLLocation*)otherPoint;
- (NSString*)formattedDistanceInMilesFromCurrentLocation;
- (NSString*)formattedDistanceFromCurrentLocationWithUnits;
- (BOOL)isInView:(CGPoint*)point;
- (CATransform3D)objectTransform;
- (CGFloat)gearSpeed;
- (NSInteger)numberOfTeethInGear;
- (void) gearHasTurned;
- (Coord3D) unitVectorFromOrigin;

@end


//
//
//
@interface SM3DARPointView : UIView {
}

@property (nonatomic, retain) SM3DARPoint *point;

- (void) buildView;
- (CGAffineTransform) pointTransform;
- (void) didReceiveFocus;
- (void) didLoseFocus;
- (void) resizeFrameAround:(UIView*)targetView;

@end


//
//
//
@interface SM3DARMarkerView : SM3DARPointView {
}

@property (nonatomic, retain) SM3DARPointOfInterest *poi;

- (id)initWithPointOfInterest:(SM3DARPointOfInterest*)pointOfInterest;

@end


//
//
//
@interface SM3DARIconMarkerView : SM3DARMarkerView {
}

@property (nonatomic, retain) UIImageView *icon;

- (id)initWithPointOfInterest:(SM3DARPointOfInterest*)pointOfInterest imageName:(NSString *)imageName;
+ (NSString*)randomIconName;

@end


//
//
//
@interface SM3DARGLMarkerView : SM3DARMarkerView {
}

- (void) drawInGLContext;

@end


//
//
//
@interface SM3DARFocusView : UIView<SM3DARFocusDelegate> {
}

@property (nonatomic, retain) SM3DARPoint *focusPoint;
@property (nonatomic, retain) UILabel *content;
@property (nonatomic, assign) BOOL showDistance;
@property (nonatomic, assign) BOOL showTitle;
@property (nonatomic, assign) BOOL useMetricUnits;
@property (nonatomic, assign) CGPoint centerOffset;

- (void)buildView;
@end


//
//
//
@interface Texture : NSObject {
}

@property (nonatomic) unsigned int handle;

+ (Texture*) newTexture;
+ (Texture*) newTextureFromImage:(CGImageRef)image;
+ (Texture*) newTextureFromResource:(NSString*)resource;
- (void) replaceTextureFromResource:(NSString*)resource;
- (void) replaceTextureWithImage:(CGImageRef)image;
@end


//
//
//
@interface Geometry : NSObject {
}

@property (nonatomic) BOOL cullFace;

+ (Geometry *) newOBJFromResource:(NSString *)resource;
+ (void) displayHemisphereWithTexture:(Texture *)texture;
+ (void) displaySphereWithTexture:(Texture *)texture;
- (void) displayWireframe;
- (void) displayFilledWithTexture:(Texture *)texture;
- (void) displayShaded:(UIColor *)color;
@end


//
//
//
@interface SM3DARCustomAnnotationView : MKAnnotationView { 
}
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, retain) SM3DARPointOfInterest *poi;
@end


//
//
//
@interface SM3DARTexturedGeometryView : SM3DARPointView {}

@property (nonatomic) double zrot;
@property (nonatomic, retain) UIColor *color;
@property (nonatomic, retain) Geometry *geometry;
@property (nonatomic, retain) Texture *texture;
@property (nonatomic, retain) NSString *textureName;
@property (nonatomic, retain) NSURL *textureURL;
@property (nonatomic, assign) CGFloat sizeScalar;

- (id) initWithTextureNamed:(NSString*)name;
- (id) initWithTextureURL:(NSURL*)url;
- (id) initWithOBJ:(NSString*)objName textureNamed:(NSString*)textureName;
- (void) drawInGLContext;
- (void) updateTexture:(UIImage*)textureImage;
- (void) updateImage:(UIImage*)newImage;
- (UIImage*) resizeImage:(UIImage*)originalImage;
@end


//
//
//
@interface SM3DARRoundedLabel : UILabel
@property (nonatomic, assign) CGFloat maxWidth;
- (void)setText:(NSString*)newText adjustSize:(BOOL)adjustSize;
@end


#define SM3DAR_POI_LATITUDE @"latitude"
#define SM3DAR_POI_ALTITUDE @"altitude"
#define SM3DAR_POI_LONGITUDE @"longitude"
#define SM3DAR_POI_TITLE @"title"
#define SM3DAR_POI_SUBTITLE @"subtitle"
#define SM3DAR_POI_URL @"url"
#define SM3DAR_POI_VIEW_CLASS_NAME @"view_class_name"
#define SM3DAR_POI_DEFAULT_VIEW_CLASS_NAME @"SM3DARIconMarkerView"
