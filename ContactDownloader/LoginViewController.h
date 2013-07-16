//
//  LoginViewController.h
//  ContactDownloader
//
//  Created by Mayank Jain on 7/13/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import "ViewController.h"
@protocol LoginViewControllerDelegate <NSObject>
@required
- (void) loggedIn;

@end

@interface LoginViewController : ViewController
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic, assign) id  delegate;
- (IBAction)buttonPressed:(id)sender;

@end
