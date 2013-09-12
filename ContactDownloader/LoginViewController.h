//
//  LoginViewController.h
//  ContactDownloader
//
//  Created by Mayank Jain on 7/13/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import "ViewController.h"

@interface LoginViewController : ViewController

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)buttonPressed:(id)sender;

@end
