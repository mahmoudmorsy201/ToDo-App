//
//  AllToDoTableViewController.m
//  ToDoProject
//
//  Created by Mahmoud Morsy on 25/02/2021.
//

#import "AllToDoViewController.h"
#import "AllToDoTableViewCell.h"
#import "AddViewController.h"
#import "Model.h"
#import "DetailsViewController.h"
#import "InProgressViewController.h"
#import "DoneViewController.h"
#import <UserNotifications/UserNotifications.h>




@interface AllToDoViewController ()

@end


@implementation AllToDoViewController {
    NSUserDefaults *def;
    NSMutableArray *searchToDo;
    UIImageView *result;
    BOOL isSearch;
    NSDate *dateNow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    def = [NSUserDefaults standardUserDefaults];
    result = [self drawImage];
    dateNow = [NSDate new];
    
    if ([[def objectForKey:@"toDoArray"] mutableCopy] == nil) {
        _dictArray = [NSMutableArray new];
    } else {
        _dictArray = [[def objectForKey:@"toDoArray"] mutableCopy];
    }
    isSearch = FALSE;
    self.allToDoSearchBar.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:TRUE];
    [_allTableView reloadData];
}

#pragma mark- Add New ToDo
- (IBAction)addBtnTapped:(id)sender {
    AddViewController *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addViewController"];
    [self.navigationController pushViewController:addVC animated:YES];
    addVC.P = self;
}

#pragma mark- AddToDoProtocol Method

- (void)saveMehodDic:(NSMutableDictionary *)dict {
    [_dictArray addObject:dict];
    [def setObject:_dictArray forKey:@"toDoArray"];
    [def synchronize];
    [_allTableView reloadData];
}

#pragma mark- Update Protocol
-(void) updateMehodDic:(NSMutableDictionary *)updatedDict :(NSInteger)index :(NSInteger)indexSearch {
    
    if (isSearch) {
        if (updatedDict == nil) {
            [_allTableView reloadData];
        }else {
            [_dictArray removeObjectAtIndex:indexSearch];
            [searchToDo removeObjectAtIndex: index];
            [searchToDo insertObject:updatedDict atIndex:index];
            [_dictArray addObject:searchToDo[index]];
            [def setObject:_dictArray forKey:@"toDoArray"];
            [def synchronize];
            [_allTableView reloadData];
        }
    }else {
        if (updatedDict == nil) {
            [_allTableView reloadData];
        }else {
            [_dictArray removeObjectAtIndex: index];
            [_dictArray insertObject:updatedDict atIndex:index];
            [def setObject:_dictArray forKey:@"toDoArray"];
            [def synchronize];
            [_allTableView reloadData];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (isSearch) {
        return searchToDo.count;
    }else {
        _allTableView.backgroundView = nil;
        return _dictArray.count;
    }
}

#pragma mark - Table View Delegate Methods

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AllToDoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allCell" forIndexPath:indexPath];
    
    if (isSearch) {
        cell.titleLabel.text = [[searchToDo objectAtIndex:indexPath.row] objectForKey:@"title"];
        
        if ([[[searchToDo objectAtIndex:indexPath.row] objectForKey:@"prio"] isEqualToString:@"Low"]) {
            [[cell prioImageView] setTintColor:[UIColor greenColor]];
            
        } else if ([[[searchToDo objectAtIndex:indexPath.row] objectForKey:@"prio"] isEqualToString:@"Medium"]) {
            [[cell prioImageView] setTintColor:[UIColor blueColor]];
        } else {
            [[cell prioImageView] setTintColor:[UIColor redColor]];
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
        cell.titleLabel.text = [[_dictArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        
        if ([[[_dictArray objectAtIndex:indexPath.row] objectForKey:@"prio"] isEqualToString:@"Low"]) {
            [[cell prioImageView] setTintColor:[UIColor greenColor]];
            
        } else if ([[[_dictArray objectAtIndex:indexPath.row] objectForKey:@"prio"] isEqualToString:@"Medium"]) {
            [[cell prioImageView] setTintColor:[UIColor blueColor]];
        } else {
            [[cell prioImageView] setTintColor:[UIColor redColor]];
        }
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MMM-yyyy hh:min a"];
        NSString *datePicker = [dateFormatter stringFromDate:[[_dictArray objectAtIndex:indexPath.row]objectForKey:@"dateCreated"]];
        cell.dateLabel.text = datePicker;
        
        if ([[self->_dictArray[indexPath.row]objectForKey:@"date"] compare:self->dateNow] == NSOrderedDescending) {
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
        if ([_dictArray containsObject:searchToDo[indexPath.row]]) {
            NSInteger ind = [_dictArray indexOfObject:searchToDo[indexPath.row]];
            detailVC.indexSearch = ind;
        }else {
            [_allTableView reloadData];
        }
        [self.navigationController pushViewController:detailVC animated:YES];
        
        
        detailVC.P = self;
        
    }else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        DetailsViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
        detailVC.detailModelDict = _dictArray[indexPath.row];
        detailVC.index = indexPath;
        [self.navigationController pushViewController:detailVC animated:YES];
        
        detailVC.P = self;
    }
}


#pragma mark - Swipe actions


-(UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    //delete
    UIContextualAction *delete =[UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
                                                                        title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self->isSearch) {
                if ([self->_dictArray containsObject:self->searchToDo[indexPath.row]]) {
                    NSInteger ind = [self->_dictArray indexOfObject:self->searchToDo[indexPath.row]];
                    [self->searchToDo removeObjectAtIndex:indexPath.row];
                    [self->_dictArray removeObjectAtIndex:ind];
                    [self->def setObject:self->_dictArray forKey:@"toDoArray"];
                    [self->def synchronize];
                    [[self allTableView] reloadData];
                }
            }else {
                [self.dictArray removeObjectAtIndex:indexPath.row];
                [self->def setObject:self->_dictArray forKey:@"toDoArray"];
                [self->def synchronize];
                [[self allTableView] reloadData];
            }
        }];
        [self alerActions:@"Do You Want To Delete A ToDo Item" :@"Please Click On Ok if You Want to delete" :ok];
        completionHandler(YES);
    }];
    [delete setImage:[UIImage imageNamed:@"Trash-Icon"]];
    
    
#pragma mark- Reminder Swipe
    
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
                        AllToDoTableViewCell *cell = [self->_allTableView cellForRowAtIndexPath:indexPath];
                        [[cell isRemindedImage] setImage:[UIImage imageNamed:@"4"]];
                        [[self->searchToDo objectAtIndex:indexPath.row] setObject:@"NO" forKey:@"isReminded"];
                        [self->def setObject:self->_dictArray forKey:@"toDoArray"];
                        [self->def synchronize];
                        [self->_allTableView reloadData];
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
                    content.title = [self->_dictArray[indexPath.row]objectForKey:@"title"];
                    content.body = [self->_dictArray[indexPath.row]objectForKey:@"detail"];
                    content.sound = [UNNotificationSound defaultSound];
                    NSDate *date = [self->_dictArray[indexPath.row]objectForKey:@"date"];
                    NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
                                  components:NSCalendarUnitYear +
                                  NSCalendarUnitMonth + NSCalendarUnitDay +
                                  NSCalendarUnitHour + NSCalendarUnitMinute +
                                  NSCalendarUnitSecond fromDate:date];
                    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger
                      triggerWithDateMatchingComponents:triggerDate repeats:NO];

                    NSString *identifier = [self->_dictArray[indexPath.row]objectForKey:@"title"];
                    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                                          content:content trigger:trigger];

                    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                        if (error != nil) {
                            NSLog(@"Something went wrong: %@",error);
                        }
                    }];
                    if ([[self->_dictArray[indexPath.row]objectForKey:@"date"] compare:self->dateNow] == NSOrderedDescending) {
                        [[self->_dictArray objectAtIndex:indexPath.row] setObject:@"YES" forKey:@"isReminded"];
                        AllToDoTableViewCell *cell = [self->_allTableView cellForRowAtIndexPath:indexPath];
                        [[cell isRemindedImage] setImage:[UIImage imageNamed:@"4"]];
                        [[self->_dictArray objectAtIndex:indexPath.row] setObject:@"NO" forKey:@"isReminded"];
                        [self->def setObject:self->_dictArray forKey:@"toDoArray"];
                        [self->def synchronize];
                        [self->_allTableView reloadData];
                    }else {
                        UIAlertAction *handle = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                        [self alerActions:@"Please Edit Your Reminder Date" :@"Please Set The Reminder Date in edit View" :handle];
                    }
                }
                
    }];
        [self alerActions:@"Do You Want To Set A reminder" :@"Reminder Will Be Set On Your Reminder Date" :ok];
        completionHandler(YES);
    }];
    
    [reminder setImage:[UIImage imageNamed:@"4"]];
    reminder.backgroundColor =[UIColor orangeColor];
    
    UISwipeActionsConfiguration *swipeActionConfig = [UISwipeActionsConfiguration configurationWithActions:@[delete,reminder]];
    return swipeActionConfig;
}

-(UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    //inProgress
    UIContextualAction *inProgress =[UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal
                                                                            title:@"InProgress" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSArray *viewControllers = [self.tabBarController viewControllers];
            UINavigationController *myNavController = (UINavigationController *)viewControllers[1];
            InProgressViewController *inProgressVc = [[myNavController childViewControllers] firstObject];
            if (self->isSearch) {
                if ([self->_dictArray containsObject:self->searchToDo[indexPath.row]]) {
                    NSInteger ind = [self->_dictArray indexOfObject:self->searchToDo[indexPath.row]];
                    inProgressVc.inProgressDict = self->_dictArray[ind];
                    [self->searchToDo removeObjectAtIndex:indexPath.row];
                    [self.dictArray removeObjectAtIndex:ind];
                    [self->def setObject:self->_dictArray forKey:@"toDoArray"];
                    [self->def synchronize];
                    [[self allTableView] reloadData];
                    
                }
            }else {
                inProgressVc.inProgressDict = self->_dictArray[indexPath.row];
                [self.tabBarController setSelectedIndex:1];
                
                [self.dictArray removeObjectAtIndex:indexPath.row];
                [self->def setObject:self->_dictArray forKey:@"toDoArray"];
                [self->def synchronize];
                [[self allTableView] reloadData];
            }
            [self.tabBarController setSelectedIndex:1];
        }];
        
        [self alerActions:@"Do You Want To Move This Item To inProgress" :@"Item Will be moved if you click OK" :ok];
        completionHandler(YES);
    }];
    [inProgress setImage:[UIImage systemImageNamed:@"increase.indent"]];
    inProgress.backgroundColor =[UIColor blueColor];
    
    
    //done
    UIContextualAction *done =[UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal
                                                                      title:@"done" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSArray *viewControllers = [self.tabBarController viewControllers];
            UINavigationController *myNavController = (UINavigationController *)viewControllers[2];
            DoneViewController *doneVC = [[myNavController childViewControllers] firstObject];
            doneVC.doneDict = self->_dictArray[indexPath.row];
            if (self->isSearch) {
                if ([self->_dictArray containsObject:self->searchToDo[indexPath.row]]) {
                    NSInteger ind = [self->_dictArray indexOfObject:self->searchToDo[indexPath.row]];
                    doneVC.doneDict = self->_dictArray[ind];
                    [self->searchToDo removeObjectAtIndex:indexPath.row];
                    [self.dictArray removeObjectAtIndex:ind];
                    [self->def setObject:self->_dictArray forKey:@"toDoArray"];
                    [self->def synchronize];
                    [[self allTableView] reloadData];
                }
            }else {
                doneVC.doneDict = self->_dictArray[indexPath.row];
                [self.dictArray removeObjectAtIndex:indexPath.row];
                [self->def setObject:self->_dictArray forKey:@"toDoArray"];
                [self->def synchronize];
                [[self allTableView] reloadData];
            }
            [self.tabBarController setSelectedIndex:2];
        }];
        [self alerActions:@"Do You Want To Move This Item To Done" :@"Item Will be moved if you click OK" :ok];
        completionHandler(YES);
    }];
    [done setImage:[UIImage systemImageNamed:@"checkmark.circle.fill"]];
    done.backgroundColor =[UIColor greenColor];
    
    //swipe
    UISwipeActionsConfiguration *swipeActionConfig = [UISwipeActionsConfiguration configurationWithActions: @[inProgress, done]];
    
    
    return swipeActionConfig;
}

#pragma mark - UISearchBar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if ([_allToDoSearchBar.text isEqual:@""]) {
        _allTableView.backgroundView = nil;
        [_allTableView reloadData];
        [_allToDoSearchBar resignFirstResponder];
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _allTableView.backgroundView = nil;
    [_allTableView reloadData];
    [_allToDoSearchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        isSearch = FALSE;
    }else {
        isSearch = true;
        searchToDo = [NSMutableArray new];
        for (NSMutableDictionary* dict in _dictArray) {
            NSRange titleRange = [[dict objectForKey:@"title"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleRange.location != NSNotFound) {
                [searchToDo addObject:dict];
            }
        }
    }
    if(searchToDo.count == 0) {
        _allTableView.backgroundView = result;
    }
    [_allTableView reloadData];
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
