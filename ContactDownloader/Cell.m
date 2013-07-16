//
//  Cell.m
//  ContactDownloader
//
//  Created by Mayank Jain on 7/13/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import "Cell.h"
#import "UIColor+Hex.h"

@implementation Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.number.textColor = [UIColor colorWithHexString:@"cccccc"];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
