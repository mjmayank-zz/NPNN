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
        self.loginVC.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) choseCell:(int)cellIndex{
    for(NSDictionary * dict in self.events){
        NSLog(@"test test %@", dict);
        
//        NSString * url = [NSString stringWithFormat:
//                          @"https://graph.facebook.com/%@/feed?access_token=%@",
//                          [dict objectForKey:@"name"], FBSession.activeSession.accessTokenData.accessToken];
        
        FBRequest *request = [FBRequest requestForGraphPath:[NSString stringWithFormat:
                                                             @"%@/feed?access_token=%@", [self.events[cellIndex] objectForKey:@"eid" ],
                                                             FBSession.activeSession.accessTokenData.accessToken]];
        
        [request startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphObject> *user, NSError *error) {
             if (!error) {
                 NSLog(@"data2 %@",user);
                 
                 self.posts = [user objectForKey:@"data"];
                 
                 self.VC = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
                 self.VC.view.frame = self.view.bounds;
                 [self.view addSubview:self.VC.view];
                 self.VC.array = self.posts;
             }
         }];
    }

}

-(void) loggedIn
{

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
                                  NSLog(@"Result: %@", result);
                                  self.events = (NSMutableArray *)[result data];
                                  self.EVC = [[EventsViewController alloc] initWithNibName:@"EventsViewController" bundle:nil];
                                  self.EVC.view.frame = self.view.bounds;
                                  [self.view addSubview:self.EVC.view];
                                  self.EVC.delegate = self;
                                  self.EVC.array = self.events;
                                                                }
                          }];
    
    


    
//    NSString *query = @"SELECT stream FROM event WHERE eid = 631870753506928";
//    NSDictionary *queryParam = @{ @"q": query };
//    // Make the API request that uses FQL
//    [FBRequestConnection startWithGraphPath:@"/fql"
//                                 parameters:queryParam
//                                 HTTPMethod:@"GET"
//                          completionHandler:^(FBRequestConnection *connection,
//                                              id result,
//                                              NSError *error) {
//                              if (error) {
//                                  NSLog(@"Error: %@", [error localizedDescription]);
//                              } else {
//                                  NSLog(@"Result: %@", result);
//                              }
//                          }];
    
}

//631870753506928

@end
