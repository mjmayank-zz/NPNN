//
//  LoginViewController.m
//  ContactDownloader
//
//  Created by Mayank Jain on 7/13/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];
        
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] initWithPermissions:[NSArray arrayWithObjects:@"user_events", @"friends_events", @"read_stream",  nil]];

        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
//            [self.delegate loggedIn];
            
            AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
            
            [FBSession setActiveSession:appDelegate.session];
            
            [FBRequestConnection
             startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                               id<FBGraphUser> user,
                                               NSError *error) {
                 if (!error) {
                     NSString *userInfo = @"";
                     
                     // Example: typed access (name)
                     // - no special permissions required
                     userInfo = [userInfo
                                 stringByAppendingString:
                                 [NSString stringWithFormat:@"Name: %@\n\n",
                                  user.name]];
                     
                     
                 }
                 
             }];
            
            NSString *query =
            @"SELECT eid, name FROM event WHERE eid IN ( \
            SELECT eid from event_member WHERE uid = me()   \
            )";
            // Set up the query parameter
            NSDictionary *queryParam = @{ @"q": query };
            // Make the API request that uses FQL
            //    __block NSArray * test;
            [FBRequestConnection startWithGraphPath:@"/fql" parameters:queryParam HTTPMethod:@"GET"
                                  completionHandler:^(FBRequestConnection *connection,
                                                      id result,
                                                      NSError *error) {
                                      if (error) {
                                          NSLog(@"Error: %@", [error localizedDescription]);
                                      } else {
//                                          NSLog(@"Result: %@", result);
                                          
                                          EventsViewController * EVC = [[EventsViewController alloc] initWithNibName:@"EventsViewController" bundle:nil];
                                          EVC.events = (NSMutableArray *)[result data];
                                          [self.navigationController pushViewController:EVC animated:YES];
                                      }
                                  }];
            
        }];
    }
}
@end
