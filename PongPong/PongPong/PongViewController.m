//
//  PongViewController.m
//  PongPong
//
//  Created by Ruud Visser on 05-11-14.
//  Copyright (c) 2014 Scrambled Apps. All rights reserved.
//

#import "PongViewController.h"

@interface PongViewController ()

@end

@implementation PongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"Gameref: %@",self.gameRef);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [self.gameRef removeValue];
    
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
