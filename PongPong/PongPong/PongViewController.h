//
//  PongViewController.h
//  PongPong
//
//  Created by Ruud Visser on 05-11-14.
//  Copyright (c) 2014 Scrambled Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

int Y;
int X;
int playerScore;
int computerScore;

@interface PongViewController : UIViewController{
    IBOutlet UIImageView *ball;
    IBOutlet UIButton *startButton;
    IBOutlet UIImageView *computerBar;
    IBOutlet UIImageView *playerBar;
    IBOutlet UILabel *computerStatusLabel;
    IBOutlet UILabel *playerStatusLabel;
    
    NSTimer *timer;
}

-(IBAction)startButton:(id)sender;
-(void)ballMovement;
// Method for second player movement
//-(void)computerMove;
-(void)collisioDetection;

@property (nonatomic) BOOL isMaster;
@property (nonatomic,retain) Firebase *gameRef;

@end
