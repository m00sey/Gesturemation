//
//  GesturemationViewController.m
//  Gesturemation
//
//  Created by Kevin Griffin on 5/7/11.
//  Copyright 2011 Chariot Solutions LLC. All rights reserved.
//

#import "GesturemationViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface GesturemationViewController ()
- (void) moveViewOnY: (UIView *) moving toPosition: (NSNumber *) position;
- (void) moveViewOnX: (UIView *) moving toPosition: (NSNumber *) position;
- (CABasicAnimation *) createBasicAnimationWithKeyPath: (NSString *) keyPath andPosition: (NSNumber *) position;

- (void) setupGestureSwipeRecognizers;
- (UISwipeGestureRecognizer *) createSwipeGestureRecognizerForSwipeDirection: (UISwipeGestureRecognizerDirection) direction;
- (void) handleSwipeFrom: (UIGestureRecognizer *) recognizer;
@end

@implementation GesturemationViewController
@synthesize swipeLeftRecognizer, swipeRightRecognizer, swipeUpRecognizer, swipeDownRecognizer;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGestureSwipeRecognizers];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Gesture Recognizer set up
- (void) setupGestureSwipeRecognizers {
    UIView * view = [self view];
    swipeLeftRecognizer = [self createSwipeGestureRecognizerForSwipeDirection:UISwipeGestureRecognizerDirectionLeft];
    [view addGestureRecognizer:swipeLeftRecognizer];
    [swipeLeftRecognizer release];

    swipeRightRecognizer = [self createSwipeGestureRecognizerForSwipeDirection:UISwipeGestureRecognizerDirectionRight];
    [view addGestureRecognizer:swipeRightRecognizer];
    [swipeRightRecognizer release];

    swipeDownRecognizer = [self createSwipeGestureRecognizerForSwipeDirection:UISwipeGestureRecognizerDirectionDown];
    [view addGestureRecognizer:swipeDownRecognizer];
    [swipeDownRecognizer release];

    swipeUpRecognizer = [self createSwipeGestureRecognizerForSwipeDirection:UISwipeGestureRecognizerDirectionUp];
    [view addGestureRecognizer:swipeUpRecognizer];
    [swipeUpRecognizer release];

}

- (UISwipeGestureRecognizer *) createSwipeGestureRecognizerForSwipeDirection: (UISwipeGestureRecognizerDirection) direction {
    UISwipeGestureRecognizer *generic = [[UISwipeGestureRecognizer alloc] initWithTarget:self 
                                                            action:@selector(handleSwipeFrom:)];
    [generic setDelegate:self];
    [generic setDirection:direction];
    return generic;
}

#pragma mark - Handle Gesture Recognizer Actions
- (void) handleSwipeFrom: (UISwipeGestureRecognizer *) recognizer {
    if ([recognizer direction] == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
    }
    if ([recognizer direction] == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"swipe right");
    }
    if ([recognizer direction] == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
    }
    if ([recognizer direction] == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
    }
}

#pragma mark - Basic Animations

- (void) moveViewOnY: (UIView *) moving toPosition: (NSNumber *) position{
    
    CABasicAnimation *move = [self createBasicAnimationWithKeyPath:@"transform.translation.y" 
                                                       andPosition:position];
    [[moving layer] addAnimation:move forKey:@"move along y"];
}

- (void) moveViewOnX: (UIView *) moving toPosition: (NSNumber *) position{
    
    CABasicAnimation *move = [self createBasicAnimationWithKeyPath:@"transform.translation.x" 
                                                       andPosition:position];
    [[moving layer] addAnimation:move forKey:@"move along x"];
}

- (CABasicAnimation *) createBasicAnimationWithKeyPath: (NSString *) keyPath andPosition: (NSNumber *) position {
    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:keyPath];
    [move setFromValue:[NSNumber numberWithFloat:0.0f]];
    [move setToValue:position];
    [move setRemovedOnCompletion:YES];
    [move setFillMode:kCAFillModeForwards];
    
    return move;
}

#pragma mark - Memory Management
- (void)dealloc {
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
