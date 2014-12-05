//
//  GameTableViewCell.h
//  PongPong
//
//  Created by Ruud Visser on 28-10-14.
//  Copyright (c) 2014 Scrambled Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartViewController.h"
#import <Firebase/Firebase.h>

@interface GameTableViewCell : UITableViewCell

@property (nonatomic, retain) Firebase *gameRef;
@property (weak, nonatomic) IBOutlet UILabel *playerName;
@property (weak,nonatomic) StartViewController *delegate;


- (IBAction)joinGame:(id)sender;
@end
