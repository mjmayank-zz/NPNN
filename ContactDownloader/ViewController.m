//
//  ViewController.m
//  ContactDownloader
//
//  Created by Mayank Jain on 7/13/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import "ViewController.h"
#import "Cell.h"
#import "UIColor+Hex.h"
#import "AppDelegate.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    }
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                
                
            }];
        }
    }

}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
	[self.navigationController setNavigationBarHidden:NO animated:YES];
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
    
    cell.name.text = [[self.array[[indexPath row]] objectForKey:@"from"] objectForKey:@"name"];
    cell.number.text = [self.array[[indexPath row]] objectForKey:@"message"];

    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    FBRequest *request = [FBRequest requestForGraphPath:[NSString stringWithFormat:
                                                         @"%@?access_token=%@", [[self.array[[indexPath row]] objectForKey:@"from"] objectForKey:@"id"],
                                                         FBSession.activeSession.accessTokenData.accessToken]];
    
    [request startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphObject> *user, NSError *error) {
         if (!error) {
             if([user objectForKey:@"first_name"] && [user objectForKey:@"last_name"]){
                 [self saveContactToiOS:[user objectForKey:@"first_name"] lastName:[user objectForKey:@"last_name"] withNumber:[self.array[[indexPath row]] objectForKey:@"message"]];
             }
             
             [self.array removeObjectAtIndex:[indexPath row]];
             switch ([indexPath row] % 5) {
                 case 0:
                     [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                     break;
                 case 1:
                     [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                     break;
                 case 2:
                     [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
                     break;
                 case 3:
                     [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
                     break;
                 case 4:
                     [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
                     break;
                 default:
                     
                     break;
             }
         }
     }];
    
}

-(void) saveContactToiOS:(NSString *)name lastName:(NSString *)lastName withNumber:(NSString *)number {
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    CFErrorRef * error = NULL;
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            // First time access has been granted, add the contact
            NSLog(@"not determined");
            [self saveContactToiOS:name lastName:lastName withNumber:number];
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        NSLog(@"authorized");
        ABRecordRef person = ABPersonCreate(); // create a person
        
        ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABPersonPhoneProperty);
        
        ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFTypeRef) number,kABPersonPhoneMobileLabel, NULL);

        ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, error);
        ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFTypeRef)(name) , nil);
        ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFTypeRef)(lastName), nil);
        
        ABAddressBookAddRecord(addressBook, person, nil); //add the new person to the record
        ABAddressBookSave(addressBook, nil); //save the record
        CFRelease(person); // relase the ABRecordRef  variable
    }
    else {
        NSLog(@"denied");
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
    
}


@end
