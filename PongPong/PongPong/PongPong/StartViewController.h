//
//  StartViewController.h
//  PongPong
//
//  Created by Ruud Visser on 28-10-14.
//  Copyright (c) 2014 Scrambled Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernamTextfield;
@property (weak, nonatomic) IBOutlet UIButton *addGameButton;
- (IBAction)addGame:(id)sender;

@end
