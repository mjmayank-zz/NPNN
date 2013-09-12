//
//  EventsViewController.m
//  NPNN
//
//  Created by Mayank Jain on 7/15/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import "EventsViewController.h"
#import "Cell.h"
#import "UIColor+Hex.h"

@interface EventsViewController ()

@end

@implementation EventsViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
	[super viewWillAppear:animated];
    
	[self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setTitle:@"Events"];
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section{
    return [self.events count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil] objectAtIndex:0];
    }
    
    switch ([indexPath row] % 5) {
        case 0:
            cell.contentView.backgroundColor = [UIColor colorWithHexString:@"FF3443"];
            break;
        case 1:
            cell.contentView.backgroundColor = [UIColor colorWithHexString:@"47B9EB"];
            break;
        case 2:
            cell.contentView.backgroundColor = [UIColor colorWithHexString:@"FF9500"];
            break;
        case 3:
            cell.contentView.backgroundColor = [UIColor colorWithHexString:@"FFCC00"];
            break;
        case 4:
            cell.contentView.backgroundColor = [UIColor colorWithHexString:@"4cd964"];
            break;
        default:
            
            break;
    }
    
    cell.name.text = [self.events[[indexPath row]] objectForKey:@"name"];
    //    cell.number.text = self.array[[indexPath row]];
    cell.number.text = @"";
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FBRequest *request = [FBRequest requestForGraphPath:[NSString stringWithFormat:
                                                         @"%@/feed?access_token=%@", [self.events[[indexPath row]] objectForKey:@"eid" ],
                                                         FBSession.activeSession.accessTokenData.accessToken]];
    
    [request startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphObject> *user, NSError *error) {
         if (!error) {
//             NSLog(@"data2 %@",user);
             
             NSMutableArray * posts = [user objectForKey:@"data"];
             
             ViewController *view = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
             view.array = posts;
             [self.navigationController pushViewController:view animated:YES];
            [view setTitle:[self.events[[indexPath row]] objectForKey:@"name"]];
         }
     }];
    
}

@end
