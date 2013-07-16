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
    return [self.array count];
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
    
    NSLog(@"test");
    
    cell.name.text = [self.array[[indexPath row]] objectForKey:@"name"];
    //    cell.number.text = self.array[[indexPath row]];
    cell.number.text = @"";
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate choseCell:[indexPath row]];
    
}

@end
