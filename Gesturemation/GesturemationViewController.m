//
//  GesturemationViewController.m
//  Gesturemation
//
//  Created by Kevin Griffin on 5/7/11.
//  Copyright 2011 Chariot Solutions LLC. All rights reserved.
//

#import "GesturemationViewController.h"
#import <QuartzCore/QuartzCore.h>
#define kStandardDuration 0.5f
#define kStandardPortraitHeight 460.0f
#define kStandardPortraitWidth 320.0f
#define kStandardLandscapeHeight 300.0f
#define kStandardLandscapeWidth 480.0f
#define kStandardZero 0.0f
#define kResetX 160.0f
#define kResetY 230.0f
#define kResetHeight 50.0f
#define kResetWidth 50.0f

@interface GesturemationViewController ()
//animations
- (void) moveViewOnY: (UIView *) moving toPosition: (NSNumber *) position;
- (void) moveViewOnX: (UIView *) moving toPosition: (NSNumber *) position;
- (CABasicAnimation *) createBasicAnimationWithKeyPath: (NSString *) keyPath andPosition: (NSNumber *) position;
- (CABasicAnimation *) createSimpleRotationAnimation;
- (void) reset;
- (CABasicAnimation *) createSimpleScaleAnimation;
//swipes
- (void) setupGestureSwipeRecognizers;
- (UISwipeGestureRecognizer *) createSwipeGestureRecognizerForSwipeDirection: (UISwipeGestureRecognizerDirection) direction;
- (void) handleSwipeFrom: (UIGestureRecognizer *) recognizer;
// taps
- (void) setupGestureTapRecognizers;
- (void) handleTapFrom: (UIGestureRecognizer *) recognizer;
- (void) handleTwoFingerTapFrom: (UIGestureRecognizer *) recognizer;
- (void) handleDoubleTapFrom: (UIGestureRecognizer *) recognizer;
- (void) handleLongPressFrom: (UIGestureRecognizer *) recognizer;
//pan
- (void) setupPanGestureRecognizer;
- (void) handlePanFrom: (UIPanGestureRecognizer *) recognizer;
//pinch
- (void) setupPinchGestureRecognizer;
- (void) handlePinchFrom: (UIPinchGestureRecognizer *) recognizer;
//rotate
- (void) setupRotationGestureRecognizer;
- (void) handleRotationFrom: (UIRotationGestureRecognizer *) recognizer;
//calculate distance
- (NSNumber *)calculateDistanceToScreenEdgeFor: (UISwipeGestureRecognizerDirection) swipeDirection;
//orientation helpers
- (CGFloat) getHeightForCurrentOrientation;
- (CGFloat) getWidthForCurrentOrientation;
@end

@implementation GesturemationViewController
@synthesize swipeLeftRecognizer, swipeRightRecognizer, swipeUpRecognizer, swipeDownRecognizer, tapRecognizer, doubleTapRecognizer, twoFingerTapRecognizer, longPressRecognizer, panRecognizer, pinchRecognizer, rotationRecognizer;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGestureSwipeRecognizers];
    [self setupGestureTapRecognizers];
    [self setupPanGestureRecognizer];
    [self setupPinchGestureRecognizer];
    [self setupRotationGestureRecognizer];
    NSLog(@"%f %f", [moveMe frame].size.height, [moveMe frame].size.width);
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

    swipeRightRecognizer = [self createSwipeGestureRecognizerForSwipeDirection:UISwipeGestureRecognizerDirectionRight];
    [view addGestureRecognizer:swipeRightRecognizer];

    swipeDownRecognizer = [self createSwipeGestureRecognizerForSwipeDirection:UISwipeGestureRecognizerDirectionDown];
    [view addGestureRecognizer:swipeDownRecognizer];

    swipeUpRecognizer = [self createSwipeGestureRecognizerForSwipeDirection:UISwipeGestureRecognizerDirectionUp];
    [view addGestureRecognizer:swipeUpRecognizer];

}

- (void) setupGestureTapRecognizers {
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                            action:@selector(handleTapFrom:)];
    [tapRecognizer setDelegate:self];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setNumberOfTouchesRequired:1];
    [moveMe addGestureRecognizer:tapRecognizer];
    
    doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                  action:@selector(handleDoubleTapFrom:)];
    [doubleTapRecognizer setDelegate:self];
    [doubleTapRecognizer setNumberOfTapsRequired:2];
    [doubleTapRecognizer setNumberOfTouchesRequired:1];
    [[self view] addGestureRecognizer:doubleTapRecognizer];
    
    twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                    action:@selector(handleTwoFingerTapFrom:)];
    [twoFingerTapRecognizer setDelegate:self];
    [twoFingerTapRecognizer setNumberOfTapsRequired:1];
    [twoFingerTapRecognizer setNumberOfTouchesRequired:2];
    [[self view] addGestureRecognizer:twoFingerTapRecognizer];
    
    longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self 
                                                                action:@selector(handleLongPressFrom:)];
    [longPressRecognizer setDelegate:self];
    [[self view] addGestureRecognizer:longPressRecognizer];
    
}

- (void) setupPanGestureRecognizer {
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(handlePanFrom:)];
    [panRecognizer setDelegate:self];
    [moveMe addGestureRecognizer:panRecognizer];
}

- (void) setupPinchGestureRecognizer {
    pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                action:@selector(handlePinchFrom:)];
    [pinchRecognizer setDelegate:self];
    [[self view] addGestureRecognizer:pinchRecognizer];
}

- (void) setupRotationGestureRecognizer {
    rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                                action:@selector(handleRotationFrom:)];
    [rotationRecognizer setDelegate:self];
    [[self view] addGestureRecognizer:rotationRecognizer];
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
        [self moveViewOnX:moveMe 
               toPosition:[self calculateDistanceToScreenEdgeFor:UISwipeGestureRecognizerDirectionLeft]];
    }
    if ([recognizer direction] == UISwipeGestureRecognizerDirectionRight) {
        [self moveViewOnX:moveMe 
               toPosition:[self calculateDistanceToScreenEdgeFor:UISwipeGestureRecognizerDirectionRight]];
    }
    if ([recognizer direction] == UISwipeGestureRecognizerDirectionUp) {
        [self moveViewOnY:moveMe 
               toPosition:[self calculateDistanceToScreenEdgeFor:UISwipeGestureRecognizerDirectionUp]];
    }
    if ([recognizer direction] == UISwipeGestureRecognizerDirectionDown) {
        [self moveViewOnY:moveMe 
               toPosition:[self calculateDistanceToScreenEdgeFor:UISwipeGestureRecognizerDirectionDown]];
    }
}

- (void) handleTapFrom: (UITapGestureRecognizer *) recognizer {
    [[moveMe layer] addAnimation:[self createSimpleRotationAnimation] forKey:@"360"];
}

- (void) handleTwoFingerTapFrom:(UIGestureRecognizer *)recognizer {
    [UIView animateWithDuration:0.5 animations:^{ 
        //jaja I should roate back
        [[moveMe layer] removeAllAnimations];
        [[moveMe layer] setFrame:CGRectMake([moveMe frame].origin.x, [moveMe frame].origin.y, kResetWidth, kResetHeight)];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.5 animations:^{ 
            [moveMe setCenter:CGPointMake(kResetX, kResetY)];
        } completion:^(BOOL finished){
        }];
    }];
}

- (void) handleDoubleTapFrom: (UITapGestureRecognizer *) recognizer {
    CABasicAnimation *fadey = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadey setToValue:[NSNumber numberWithFloat:0.1f]];
    [fadey setDuration:1.0f];
    [fadey setAutoreverses:YES];
    [[moveMe layer] addAnimation:fadey forKey:@"fadey"];    
}

- (void) handlePanFrom: (UIPanGestureRecognizer *) recognizer {
    [[recognizer view] setCenter:[recognizer locationInView:[self view]]];
}

- (void) handleLongPressFrom:(UIGestureRecognizer *)recognizer {
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        [animationGroup setAnimations:[NSArray arrayWithObjects:[self createSimpleRotationAnimation],
                                       [self createSimpleScaleAnimation], nil]];
        [animationGroup setDuration:1.0f];
        [animationGroup setAutoreverses:YES];
        [[moveMe layer] addAnimation:animationGroup forKey:@"group action"];
    }
}

- (void) handlePinchFrom: (UIPinchGestureRecognizer *) recognizer {
    if ([recognizer state] == UIGestureRecognizerStateEnded) {
        CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [scale setToValue:[NSNumber numberWithFloat:[recognizer scale]]];
        [scale setDuration:0.0];
        [scale setRemovedOnCompletion:NO];
        [scale setFillMode:kCAFillModeForwards];
        [[moveMe layer] addAnimation:scale forKey:@"scaleing for realz"];
    }
}

- (void) handleRotationFrom:(UIRotationGestureRecognizer *)recognizer {
    lastAngle = [recognizer rotation];
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [rotate setFromValue:[NSNumber numberWithFloat:0]];
    [rotate setToValue:[NSNumber numberWithFloat:lastAngle]];
    [rotate setDuration:0.0f];
    [rotate setRemovedOnCompletion:NO];
    [rotate setFillMode:kCAFillModeForwards];
    [[moveMe layer] addAnimation:rotate forKey:@"rotate"];
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
    [move setRemovedOnCompletion:NO];
    [move setFillMode:kCAFillModeForwards];
    [move setDuration:kStandardDuration];
    [move setAutoreverses:YES];

    return move;
}

- (CABasicAnimation *) createSimpleRotationAnimation {
    CABasicAnimation *fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [fullRotation setFromValue:[NSNumber numberWithFloat:0]];
    [fullRotation setToValue:[NSNumber numberWithFloat:((360*M_PI)/180)]];
    [fullRotation setDuration:0.5f];
    return fullRotation;
}

- (CABasicAnimation *) createSimpleScaleAnimation {
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [scale setToValue:[NSNumber numberWithFloat:10.0f]];
    [scale setDuration:1.0f];
    return scale;
}

- (void) reset {
    [moveMe setCenter:CGPointMake(kResetX, kResetY)];
    [[moveMe layer] removeAllAnimations];
}

#pragma mark - Calculate distance

- (NSNumber *)calculateDistanceToScreenEdgeFor: (UISwipeGestureRecognizerDirection) swipeDirection {
    
    if (swipeDirection == UISwipeGestureRecognizerDirectionLeft) {
        return [NSNumber numberWithFloat:0-[moveMe frame].origin.x];
    } else if (swipeDirection == UISwipeGestureRecognizerDirectionRight) {
        return [NSNumber numberWithFloat:(([self getWidthForCurrentOrientation] - [moveMe frame].origin.x) - [moveMe frame].size.width)];
    } else if (swipeDirection == UISwipeGestureRecognizerDirectionUp) {
        return [NSNumber numberWithFloat:0-[moveMe frame].origin.y];
    } else {
        //UISwipeGestureRecognizerDirectionDown
        return [NSNumber numberWithFloat:(([self getHeightForCurrentOrientation] - [moveMe frame].origin.y) - [moveMe frame].size.height)];
    }
    return [NSNumber numberWithFloat:0.0f];
}

- (CGFloat) getHeightForCurrentOrientation {
    if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        return kStandardPortraitHeight;
    }
    return kStandardLandscapeHeight;
}

- (CGFloat) getWidthForCurrentOrientation {
    if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        return kStandardPortraitWidth;
    }
    return kStandardLandscapeWidth;
}

#pragma mark - Memory Management
- (void)dealloc {
    [swipeUpRecognizer release];
    [swipeDownRecognizer release];
    [swipeLeftRecognizer release];
    [swipeRightRecognizer release];
    [tapRecognizer release];
    [doubleTapRecognizer release];
    [twoFingerTapRecognizer release];
    [longPressRecognizer release];
    [panRecognizer release];
    [pinchRecognizer release];
    [rotationRecognizer release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
