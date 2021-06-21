//
//  IntroViewController.m
//  ToDoProject
//
//  Created by Mahmoud Morsy on 06/03/2021.
//

#import "IntroViewController.h"
#import "AllToDoViewController.h"

@interface IntroViewController ()

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)getStartedTapped:(id)sender {
    UITabBarController * tab =[self.storyboard instantiateViewControllerWithIdentifier:@"tab"];
    [tab setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:tab animated:TRUE completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
