//
//  RootViewController.h
//  NPNN
//
//  Created by Mayank Jain on 7/14/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "ViewController.h"
#import "EventsViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface RootViewController : UIViewController<LoginViewControllerDelegate, ViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIView *loginViewContainer;
@property (strong, nonatomic) IBOutlet UIView *tableViewContainer;

@property (strong, nonatomic) LoginViewController *loginVC;
@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) ViewController * VC;
@property (strong, nonatomic) EventsViewController * EVC;
@property (strong, nonatomic) NSMutableArray *posts;

@end
