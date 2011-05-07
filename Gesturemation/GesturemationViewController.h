//
//  GesturemationViewController.h
//  Gesturemation
//
//  Created by Kevin Griffin on 5/7/11.
//  Copyright 2011 Chariot Solutions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GesturemationViewController : UIViewController <UIGestureRecognizerDelegate> {
    IBOutlet UIView *moveMe;
    
    UISwipeGestureRecognizer *swipeLeftRecognizer;
    UISwipeGestureRecognizer *swipeRightRecognizer;
    UISwipeGestureRecognizer *swipeUpRecognizer;
    UISwipeGestureRecognizer *swipeDownRecognizer;
    
    UITapGestureRecognizer   *tapRecognizer;
    UITapGestureRecognizer   *doubleTapRecognizer;
    
    UIPanGestureRecognizer   *panRecognizer;
}
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeLeftRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeRightRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeUpRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeDownRecognizer;
@property (nonatomic, retain) UITapGestureRecognizer   *tapRecognizer;
@property (nonatomic, retain) UITapGestureRecognizer   *doubleTapRecognizer;
@property (nonatomic, retain) UIPanGestureRecognizer   *panRecognizer;
@end
