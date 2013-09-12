//
//  RootViewController.m
//  NPNN
//
//  Created by Mayank Jain on 7/14/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.view addSubview:self.loginVC.view];
//        self.loginVC.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    self.nav = [[UINavigationController alloc] initWithRootViewController:self.loginVC];
    
    // and then something like:
    [self presentViewController:self.nav animated:NO completion:nil];
    [self.nav setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//631870753506928

@end
