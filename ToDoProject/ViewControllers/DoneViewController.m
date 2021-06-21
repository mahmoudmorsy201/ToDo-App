//
//  DoneViewController.m
//  ToDoProject
//
//  Created by Mahmoud Morsy on 25/02/2021.
//

#import "DoneViewController.h"
#import "DoneTableViewCell.h"
#import "DetailsViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface DoneViewController ()

@end

@implementation DoneViewController {
    NSUserDefaults *def;
    NSMutableArray *searchToDo;
    UIImageView *result;
    BOOL isSearch;
    NSDate *nowDate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    def = [NSUserDefaults standardUserDefaults];
    nowDate = [NSDate new];
    result = [self drawImage];
    if ([[def objectForKey:@"doneArray"] mutableCopy] == nil) {
        _doneArray = [NSMutableArray new];
    } else {
        _doneArray = [[def objectForKey:@"doneArray"] mutableCopy];
    }
    isSearch = false;
    self.doneSearchBar.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:TRUE];
    
    if (_doneDict !=nil) {
        [_doneArray addObject:_doneDict];
        [def setObject:_doneArray forKey:@"doneArray"];
        [def synchronize];
        _doneDict = nil;
        [_doneTableView reloadData];
    }
}

#pragma mark- tableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearch) {
        return searchToDo.count;
    }
    _doneTableView.backgroundView = nil;
    return _doneArray.count;
}

#pragma mark- tableView Delegate methods

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"doneCell" forIndexPath:indexPath];
    
    if (isSearch) {
        cell.titleLabel.text = [[searchToDo objectAtIndex:indexPath.row] objectForKey:@"title"];
        
        if ([[[searchToDo objectAtIndex:indexPath.row] objectForKey:@"prio"] isEqualToString:@"Low"]) {
            [[cell prioImg] setTintColor:[UIColor greenColor]];
            
        } else if ([[[searchToDo objectAtIndex:indexPath.row] objectForKey:@"prio"] isEqualToString:@"Medium"]) {
            [[cell prioImg] setTintColor:[UIColor blueColor]];
        } else {
            [[cell prioImg] setTintColor:[UIColor redColor]];
        }
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MMM-yyyy hh:min a"];
        NSString *datePicker = [dateFormatter stringFromDate:[[searchToDo objectAtIndex:indexPath.row]objectForKey:@"dateCreated"]];
        
        cell.dateLabel.text = datePicker;
        if ([[self->searchToDo[indexPath.row]objectForKey:@"date"] compare:self->nowDate] == NSOrderedDescending) {
            [[cell isRemindedImage] setHidden:FALSE];
        }else {
            [[cell isRemindedImage] setHidden:TRUE];
        }
    }else {
        cell.titleLabel.text = [[_doneArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        
        if ([[[_doneArray objectAtIndex:indexPath.row] objectForKey:@"prio"] isEqualToString:@"Low"]) {
            [[cell prioImg] setTintColor:[UIColor greenColor]];
            
        } else if ([[[_doneArray objectAtIndex:indexPath.row] objectForKey:@"prio"] isEqualToString:@"Medium"]) {
            [[cell prioImg] setTintColor:[UIColor blueColor]];
        } else {
            [[cell prioImg] setTintColor:[UIColor redColor]];
        }
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MMM-yyyy hh:min a"];
        NSString *datePicker = [dateFormatter stringFromDate:[[_doneArray objectAtIndex:indexPath.row]objectForKey:@"dateCreated"]];
        
        cell.dateLabel.text = datePicker;
        if ([[self->_doneArray[indexPath.row]objectForKey:@"date"] compare:self->nowDate] == NSOrderedDescending) {
            [[cell isRemindedImage] setHidden:FALSE];
        }else {
            [[cell isRemindedImage] setHidden:TRUE];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (isSearch) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        DetailsViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
        detailVC.detailModelDict = searchToDo[indexPath.row];
        detailVC.index = indexPath;
        if ([_doneArray containsObject:searchToDo[indexPath.row]]) {
            NSInteger ind = [_doneArray indexOfObject:searchToDo[indexPath.row]];
            detailVC.indexSearch = ind;
        }else {
            [_doneTableView reloadData];
        }
        [self.navigationController pushViewController:detailVC animated:YES];
        detailVC.P = self;
        
    }else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        DetailsViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
        detailVC.detailModelDict = _doneArray[indexPath.row];
        detailVC.index = indexPath;
        [self.navigationController pushViewController:detailVC animated:YES];
        detailVC.P = self;
    }
    
}

#pragma mark- Update Protocol

-(void) updateMehodDic:(NSMutableDictionary *)updatedDict :(NSInteger)index :(NSInteger)indexSearch {
    
    if (isSearch) {
        if (updatedDict == nil) {
            [_doneTableView reloadData];
        }else {
            [_doneArray removeObjectAtIndex:indexSearch];
            [searchToDo removeObjectAtIndex: index];
            [searchToDo insertObject:updatedDict atIndex:index];
            [_doneArray addObject:searchToDo[index]];
            [def setObject:_doneArray forKey:@"inProgressArray"];
            [def synchronize];
            [_doneTableView reloadData];
        }
    }else {
        if (updatedDict == nil) {
            [_doneTableView reloadData];
        }else {
            [_doneArray removeObjectAtIndex: index];
            [_doneArray insertObject:updatedDict atIndex:index];
            [def setObject:_doneArray forKey:@"doneArray"];
            [def synchronize];
            [_doneTableView reloadData];
        }
    }
}

#pragma mark- Swipe Actions

-(UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIContextualAction *delete =[UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
        title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self->isSearch) {
                if ([self->_doneArray containsObject:self->searchToDo[indexPath.row]]) {
                    NSInteger ind = [self->_doneArray indexOfObject:self->searchToDo[indexPath.row]];
                    [self->searchToDo removeObjectAtIndex:indexPath.row];
                    [self->_doneArray removeObjectAtIndex:ind];
                    [self->def setObject:self->_doneArray forKey:@"doneArray"];
                    [self->def synchronize];
                    [[self doneTableView] reloadData];
                }
            }else {
                [self.doneArray removeObjectAtIndex:indexPath.row];
                [self->def setObject:self->_doneArray forKey:@"doneArray"];
                [self->def synchronize];
                [[self doneTableView] reloadData];
            }
        }];
        [self alerActions:@"Do You Want To Delete A ToDo Item" :@"Please Click On Ok if You Want to delete" :ok];
        completionHandler(YES);
    }];
    [delete setImage:[UIImage imageNamed:@"Trash-Icon"]];
    
    UIContextualAction *reminder =[UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal
                                                                          title:@"Reminder" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (self->isSearch) {
                UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
                [center requestAuthorizationWithOptions:options
                                      completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (!granted) {
                        NSLog(@"Something went wrong");
                    }
                }];
                UNMutableNotificationContent *content = [UNMutableNotificationContent new];
                content.title = [self->searchToDo[indexPath.row]objectForKey:@"title"];
                content.body = [self->searchToDo[indexPath.row]objectForKey:@"detail"];
                content.sound = [UNNotificationSound defaultSound];
                NSDate *date = [self->searchToDo[indexPath.row]objectForKey:@"date"];
                NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
                              components:NSCalendarUnitYear +
                              NSCalendarUnitMonth + NSCalendarUnitDay +
                              NSCalendarUnitHour + NSCalendarUnitMinute +
                              NSCalendarUnitSecond fromDate:date];
                UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger
                  triggerWithDateMatchingComponents:triggerDate repeats:NO];

                NSString *identifier = [self->searchToDo[indexPath.row]objectForKey:@"title"];
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                                      content:content trigger:trigger];

                [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                    if (error != nil) {
                        NSLog(@"Something went wrong: %@",error);
                    }
                }];
                
                if ([[self->searchToDo[indexPath.row]objectForKey:@"date"] compare:self->nowDate] == NSOrderedDescending) {
                    [[self->searchToDo objectAtIndex:indexPath.row] setObject:@"YES" forKey:@"isReminded"];
                    DoneTableViewCell *cell = [self->_doneTableView cellForRowAtIndexPath:indexPath];
                    [[cell isRemindedImage] setImage:[UIImage imageNamed:@"4"]];
                    [[self->searchToDo objectAtIndex:indexPath.row] setObject:@"NO" forKey:@"isReminded"];
                    [self->def setObject:self->_doneArray forKey:@"doneArray"];
                    [self->def synchronize];
                    [self->_doneTableView reloadData];
                }else {
                    UIAlertAction *handle = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                    [self alerActions:@"Please Edit Your Reminder Date" :@"Please Set The Reminder Date in edit View" :handle];
                }
            }else {
                UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
                [center requestAuthorizationWithOptions:options
                                      completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (!granted) {
                        NSLog(@"Something went wrong");
                    }
                }];
                UNMutableNotificationContent *content = [UNMutableNotificationContent new];
                content.title = [self->_doneArray[indexPath.row]objectForKey:@"title"];
                content.body = [self->_doneArray[indexPath.row]objectForKey:@"detail"];
                content.sound = [UNNotificationSound defaultSound];
                NSDate *date = [self->_doneArray[indexPath.row]objectForKey:@"date"];
                NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
                              components:NSCalendarUnitYear +
                              NSCalendarUnitMonth + NSCalendarUnitDay +
                              NSCalendarUnitHour + NSCalendarUnitMinute +
                              NSCalendarUnitSecond fromDate:date];
                UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger
                  triggerWithDateMatchingComponents:triggerDate repeats:NO];

                NSString *identifier = [self->_doneArray[indexPath.row]objectForKey:@"title"];
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                                      content:content trigger:trigger];

                [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                    if (error != nil) {
                        NSLog(@"Something went wrong: %@",error);
                    }
                }];
                if ([[self->_doneArray[indexPath.row]objectForKey:@"date"] compare:self->nowDate] == NSOrderedDescending) {
                    [[self->_doneArray objectAtIndex:indexPath.row] setObject:@"YES" forKey:@"isReminded"];
                    DoneTableViewCell *cell = [self->_doneTableView cellForRowAtIndexPath:indexPath];
                    [[cell isRemindedImage] setImage:[UIImage imageNamed:@"4"]];
                    [[self->_doneArray objectAtIndex:indexPath.row] setObject:@"NO" forKey:@"isReminded"];
                    [self->def setObject:self->_doneArray forKey:@"doneArray"];
                    [self->def synchronize];
                    [self->_doneTableView reloadData];
                }else {
                    UIAlertAction *handle = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                    [self alerActions:@"Please Edit Your Reminder Date" :@"Please Set The Reminder Date in edit View" :handle];
                }
            }
        }];
        [self alerActions:@"Do You Want To Set A reminder" :@"Reminder Will Be Set On Your Date ToDo" :ok];
        completionHandler(YES);
    }];
    
    [reminder setImage:[UIImage imageNamed:@"4"]];
    reminder.backgroundColor =[UIColor orangeColor];
    UISwipeActionsConfiguration *swipeActionConfig = [UISwipeActionsConfiguration configurationWithActions:@[delete,reminder]];
    return swipeActionConfig;
}

#pragma mark- SearchBar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if ([_doneSearchBar.text isEqual:@""]) {
        [_doneTableView reloadData];
        [_doneSearchBar resignFirstResponder];
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_doneTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        isSearch = FALSE;
    }else {
        isSearch = true;
        searchToDo = [NSMutableArray new];
        for (NSMutableDictionary* dict in _doneArray) {
            NSRange titleRange = [[dict objectForKey:@"title"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleRange.location != NSNotFound) {
                [searchToDo addObject:dict];

            }
        }
    }if(searchToDo.count == 0) {
        _doneTableView.backgroundView = result;
    }
    [_doneTableView reloadData];
}

#pragma mark- UIAlerts Function
-(void) alerActions :(NSString *) info :(NSString *) msg :(UIAlertAction*) action {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:info message: msg preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion: nil];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:cancel];
    [alert addAction: action];
}

#pragma mark- draw method
                                   
-(UIImageView *)drawImage {
    CGRect newFrame = CGRectMake( self.view.center.x-50  ,self.view.center.y -50, 100, 100);
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"2"]];
    imageView.frame = newFrame;
    return imageView;
}

@end
