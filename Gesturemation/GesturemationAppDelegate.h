//
//  GesturemationAppDelegate.h
//  Gesturemation
//
//  Created by Kevin Griffin on 5/7/11.
//  Copyright 2011 Chariot Solutions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GesturemationViewController;

@interface GesturemationAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet GesturemationViewController *viewController;

@end
