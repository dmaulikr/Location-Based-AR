//
//  FlipsideViewController.m
//  Around Me
//
//  Created by Jean-Pierre Distler on 30.01.13.
//  Copyright (c) 2013 Jean-Pierre Distler. All rights reserved.
//

#import "FlipsideViewController.h"
#import "Place.h"
#import "MarkerView.h"

@interface FlipsideViewController ()

@property (nonatomic, strong) AugmentedRealityController *arController;
@property (nonatomic, strong) NSMutableArray *geoLocations;

@end

@implementation FlipsideViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    if(!_arController) {
        _arController = [[AugmentedRealityController alloc] initWithView:[self view] parentViewController:self withDelgate:self];
    }
    
    [_arController setMinimumScaleFactor:0.5];
    [_arController setScaleViewsBasedOnDistance:YES];
    [_arController setRotateViewsBasedOnPerspective:YES];
    [_arController setDebugMode:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self geoLocations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)generateGeoLocations {
	//1
	[self setGeoLocations:[NSMutableArray arrayWithCapacity:[_locations count]]];
    
	//2
	for(Place *place in _locations) {
		//3
		ARGeoCoordinate *coordinate = [ARGeoCoordinate coordinateWithLocation:[place location] locationTitle:[place placeName]];
		//4
		[coordinate calibrateUsingOrigin:[_userLocation location]];
        
		MarkerView *markerView = [[MarkerView alloc] initWithCoordinate:coordinate delegate:self];
        [coordinate setDisplayView:markerView];
        
		//5
		[_arController addCoordinate:coordinate];
		[_geoLocations addObject:coordinate];
	}
}

- (void)didTapMarker:(ARGeoCoordinate *)coordinate {
}

- (NSMutableArray *)geoLocations {
	if(!_geoLocations) {
		[self generateGeoLocations];
	}
	return _geoLocations;
}

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

-(void)didUpdateHeading:(CLHeading *)newHeading {
    
}

-(void)didUpdateLocation:(CLLocation *)newLocation {
    
}

-(void)didUpdateOrientation:(UIDeviceOrientation)orientation {
    
}

@end
