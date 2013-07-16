//
//  EventsViewController.h
//  NPNN
//
//  Created by Mayank Jain on 7/15/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import "ViewController.h"

@protocol ViewControllerDelegate <NSObject>
@required
- (void) choseCell:(int)cellIndex;

@end


@interface EventsViewController : ViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) id<ViewControllerDelegate>  delegate;

@end
