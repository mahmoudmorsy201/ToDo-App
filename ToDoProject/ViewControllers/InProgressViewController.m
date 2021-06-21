//
//  ViewController.m
//  ToDoProject
//
//  Created by Mahmoud Morsy on 25/02/2021.
//

#import "InProgressViewController.h"
#import "InProgressTableViewCell.h"
#import "DetailsViewController.h"
#import "DoneViewController.h"
#import <UserNotifications/UserNotifications.h>


@interface InProgressViewController ()

@end

@implementation InProgressViewController {
    NSUserDefaults *def;
    NSMutableArray *searchToDo;
    UIImageView *result;
    BOOL isSearch;
    NSDate *dateNow;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    def = [NSUserDefaults standardUserDefaults];
    dateNow = [NSDate new];
    result = [self drawImage];
    if ([[def objectForKey:@"inProgressArray"] mutableCopy] == nil) {
        _inProgressArray = [NSMutableArray new];
    } else {
        _inProgressArray = [[def objectForKey:@"inProgressArray"] mutableCopy];
    }
    
    isSearch = false;
    self.inProgressSearch.delegate = self;

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    if (_inProgressDict != nil) {
        [_inProgressArray addObject:_inProgressDict];
        [def setObject:_inProgressArray forKey:@"inProgressArray"];
        [def synchronize];
        _inProgressDict = nil;
        [_inProgressTableView reloadData];
    }
}

#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearch) {
        return searchToDo.count;
    }
    _inProgressTableView.backgroundView = nil;

    return _inProgressArray.count;
}

#pragma mark - Table View Delegate Methods

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
     InProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inProgressCell" forIndexPath:indexPath];
    
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
        if ([[self->searchToDo[indexPath.row]objectForKey:@"date"] compare:self->dateNow] == NSOrderedDescending) {
            [[cell isRemindedImage] setHidden:FALSE];
        }else {
            [[cell isRemindedImage] setHidden:TRUE];
        }
        
    }else {
        cell.titleLabel.text = [[_inProgressArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        
        if ([[[_inProgressArray objectAtIndex:indexPath.row] objectForKey:@"prio"] isEqualToString:@"Low"]) {
            [[cell prioImg] setTintColor:[UIColor greenColor]];
            
        } else if ([[[_inProgressArray objectAtIndex:indexPath.row] objectForKey:@"prio"] isEqualToString:@"Medium"]) {
            [[cell prioImg] setTintColor:[UIColor blueColor]];
        } else {
            [[cell prioImg] setTintColor:[UIColor redColor]];
        }
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MMM-yyyy hh:min a"];
        NSString *datePicker = [dateFormatter stringFromDate:[[_inProgressArray objectAtIndex:indexPath.row]objectForKey:@"dateCreated"]];
        
        cell.dateLabel.text = datePicker;
        if ([[self->_inProgressArray[indexPath.row]objectForKey:@"date"] compare:self->dateNow] == NSOrderedDescending) {
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
        if ([_inProgressArray containsObject:searchToDo[indexPath.row]]) {
            NSInteger ind = [_inProgressArray indexOfObject:searchToDo[indexPath.row]];
            detailVC.indexSearch = ind;
        }else {
            [_inProgressTableView reloadData];
        }
        [self.navigationController pushViewController:detailVC animated:YES];
        detailVC.P = self;
        
    }else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        DetailsViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
        detailVC.detailModelDict = _inProgressArray[indexPath.row];
        detailVC.index = indexPath;
        [self.navigationController pushViewController:detailVC animated:YES];
        
        detailVC.P = self;
    }
}

#pragma mark - Update Todo Protocol

-(void) updateMehodDic:(NSMutableDictionary *)updatedDict :(NSInteger)index :(NSInteger)indexSearch {
    
    if (isSearch) {
        if (updatedDict == nil) {
            [_inProgressTableView reloadData];
        }else {
            [_inProgressArray removeObjectAtIndex:indexSearch];
            [searchToDo removeObjectAtIndex: index];
            [searchToDo insertObject:updatedDict atIndex:index];
            [_inProgressArray addObject:searchToDo[index]];
            [def setObject:_inProgressArray forKey:@"inProgressArray"];
            [def synchronize];
            [_inProgressTableView reloadData];
        }
    }else {
        if (updatedDict == nil) {
            [_inProgressTableView reloadData];
        }else {
            [_inProgressArray removeObjectAtIndex: index];
            [_inProgressArray insertObject:updatedDict atIndex:index];
            [def setObject:_inProgressArray forKey:@"inProgressArray"];
            [def synchronize];
            [_inProgressTableView reloadData];
        }
    }
}


#pragma mark - Swipe Actions

-(UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    //delete
    UIContextualAction *delete =[UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
        title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self->isSearch) {
                if ([self->_inProgressArray containsObject:self->searchToDo[indexPath.row]]) {
                    NSInteger ind = [self->_inProgressArray indexOfObject:self->searchToDo[indexPath.row]];
                    [self->searchToDo removeObjectAtIndex:indexPath.row];
                    [self->_inProgressArray removeObjectAtIndex:ind];
                    [self->def setObject:self->_inProgressArray forKey:@"inProgressArray"];
                    [self->def synchronize];
                    [[self inProgressTableView] reloadData];
                }
            }else {
                [self.inProgressArray removeObjectAtIndex:indexPath.row];
                [self->def setObject:self->_inProgressArray forKey:@"inProgressArray"];
                [self->def synchronize];
                [[self inProgressTableView] reloadData];
            }
        }];
        
        [self alerActions:@"Do You Want To Delete A ToDo Item" :@"Please Click On Ok if You Want to delete" :ok];
        completionHandler(YES);
    }];
    [delete setImage:[UIImage imageNamed:@"Trash-Icon"]];
    
    //reminder
    
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
                if ([[self->searchToDo[indexPath.row]objectForKey:@"date"] compare:self->dateNow] == NSOrderedDescending) {
                    [[self->searchToDo objectAtIndex:indexPath.row] setObject:@"YES" forKey:@"isReminded"];
                    InProgressTableViewCell *cell = [self->_inProgressTableView cellForRowAtIndexPath:indexPath];
                    [[cell isRemindedImage] setImage:[UIImage imageNamed:@"4"]];
                    [[self->searchToDo objectAtIndex:indexPath.row] setObject:@"NO" forKey:@"isReminded"];
                    [self->def setObject:self->_inProgressArray forKey:@"inProgressArray"];
                    [self->def synchronize];
                    [self->_inProgressTableView reloadData];
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
                content.title = [self->_inProgressArray[indexPath.row]objectForKey:@"title"];
                content.body = [self->_inProgressArray[indexPath.row]objectForKey:@"detail"];
                content.sound = [UNNotificationSound defaultSound];
                NSDate *date = [self->_inProgressArray[indexPath.row]objectForKey:@"date"];
                NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
                              components:NSCalendarUnitYear +
                              NSCalendarUnitMonth + NSCalendarUnitDay +
                              NSCalendarUnitHour + NSCalendarUnitMinute +
                              NSCalendarUnitSecond fromDate:date];
                UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger
                  triggerWithDateMatchingComponents:triggerDate repeats:NO];

                NSString *identifier = [self->_inProgressArray[indexPath.row]objectForKey:@"title"];
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                                      content:content trigger:trigger];

                [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                    if (error != nil) {
                        NSLog(@"Something went wrong: %@",error);
                    }
                }];
                if ([[self->_inProgressArray[indexPath.row]objectForKey:@"date"] compare:self->dateNow] == NSOrderedDescending) {
                    [[self->_inProgressArray objectAtIndex:indexPath.row] setObject:@"YES" forKey:@"isReminded"];
                    InProgressTableViewCell *cell = [self->_inProgressTableView cellForRowAtIndexPath:indexPath];
                    [[cell isRemindedImage] setImage:[UIImage imageNamed:@"4"]];
                    [[self->_inProgressArray objectAtIndex:indexPath.row] setObject:@"NO" forKey:@"isReminded"];
                    [self->def setObject:self->_inProgressArray forKey:@"inProgressArray"];
                    [self->def synchronize];
                    [self->_inProgressTableView reloadData];
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

-(UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UIContextualAction *done =[UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal
        title:@"done" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSArray *viewControllers = [self.tabBarController viewControllers];
            UINavigationController *myNavController = (UINavigationController *)viewControllers[2];
            DoneViewController *doneVC = [[myNavController childViewControllers] firstObject];
            
            if (self->isSearch) {
                if ([self->_inProgressArray containsObject:self->searchToDo[indexPath.row]]) {
                    
                    NSInteger ind = [self->_inProgressArray indexOfObject:self->searchToDo[indexPath.row]];
                    doneVC.doneDict = self->_inProgressArray[ind];
                    [self->searchToDo removeObjectAtIndex:indexPath.row];
                    [self.inProgressArray removeObjectAtIndex:ind];
                    [self->def setObject:self->_inProgressArray forKey:@"inProgressArray"];
                    [self->def synchronize];
                    [[self inProgressTableView] reloadData];
                }
            }else {
                doneVC.doneDict = self->_inProgressArray[indexPath.row];
                [self.inProgressArray removeObjectAtIndex:indexPath.row];
                [self->def setObject:self->_inProgressArray forKey:@"inProgressArray"];
                [self->def synchronize];
                [[self inProgressTableView] reloadData];
            }
            [self.tabBarController setSelectedIndex:2];
        }];
        [self alerActions:@"Do You Want To Move This Item To Done" :@"Item Will be moved if you click OK" :ok];
        completionHandler(YES);
    }];
    [done setImage:[UIImage systemImageNamed:@"checkmark.circle.fill"]];
    done.backgroundColor =[UIColor greenColor];
    
    //swipe
    UISwipeActionsConfiguration *swipeActionConfig = [UISwipeActionsConfiguration configurationWithActions: @[done]];

    return swipeActionConfig;
    
}

#pragma mark - Search Bar Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if ([_inProgressSearch.text isEqual:@""]) {
        [_inProgressTableView reloadData];
        [_inProgressSearch resignFirstResponder];
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_inProgressTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        isSearch = FALSE;
    }else {
        isSearch = true;
        searchToDo = [NSMutableArray new];
        for (NSMutableDictionary* dict in _inProgressArray) {
            NSRange titleRange = [[dict objectForKey:@"title"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleRange.location != NSNotFound) {
                [searchToDo addObject:dict];

            }
        }
    }if(searchToDo.count == 0) {
        _inProgressTableView.backgroundView = result;
    }
    [_inProgressTableView reloadData];
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
