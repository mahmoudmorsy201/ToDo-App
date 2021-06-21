//
//  DetailsViewController.m
//  ToDoProject
//
//  Created by Mahmoud Morsy on 01/03/2021.
//

#import "DetailsViewController.h"
#import "UpdateViewController.h"
#import "Model.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
        self.navigationItem.leftBarButtonItem = newBackButton;
    
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editBtnTapped)];
    
    [self.navigationItem setRightBarButtonItem:editBtn];
    _titleLabel.text = [_detailModelDict objectForKey:@"title"];
    _detailLabel.text = [_detailModelDict objectForKey:@"detail"];
    _prioLabel.text = [_detailModelDict objectForKey:@"prio"];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy hh:min a"];
    NSString *datePicker = [dateFormatter stringFromDate:[_detailModelDict objectForKey:@"date"]];
    _dateLabel.text = datePicker;
    
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"dd-MMM-yyyy hh:min a"];
    NSString *dateCreated = [dateFormatter stringFromDate:[_detailModelDict objectForKey:@"dateCreated"]];
    _dateCreatedLabel.text = dateCreated;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:TRUE];
    self.view.backgroundColor = [UIColor systemGray4Color];
}

- (void) back:(UIBarButtonItem *)sender {

    [_P updateMehodDic:_selectedModelDict :_index.row :_indexSearch];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:TRUE];
}


-(void) editBtnTapped {
    
    UpdateViewController *updateVc = [self.storyboard instantiateViewControllerWithIdentifier:@"updateViewController"];
    
    [self.navigationController pushViewController:updateVc animated:YES];
    
    updateVc.editDict = _detailModelDict;
    updateVc.index = _index;
    updateVc.indexSearch = _indexSearch;
    
    updateVc.P = self;
}

-(void) updateMehodDic:(NSMutableDictionary *)updatedDict :(NSInteger)index :(NSInteger)indexSearch {
    _selectedModelDict = updatedDict;
    _titleLabel.text = [_selectedModelDict objectForKey:@"title"];
    _detailLabel.text = [_selectedModelDict objectForKey:@"detail"];
    _prioLabel.text = [_selectedModelDict objectForKey:@"prio"];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy hh:min a"];
    NSString *datePicker = [dateFormatter stringFromDate:[_selectedModelDict objectForKey:@"date"]];
    _dateLabel.text = datePicker;
}



@end
