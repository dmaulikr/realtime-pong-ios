//
//  PongViewController.m
//  PongPong
//
//  Created by Ruud Visser on 05-11-14.
//  Copyright (c) 2014 Scrambled Apps. All rights reserved.
//

#import "PongViewController.h"
#import "Game.h"

@interface PongViewController ()
{
    FirebaseHandle _handle;
    Game *_game;
}
@end

@implementation PongViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    playerScore = 0;
    computerScore = 0;
    
    computerStatusLabel.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 3);
    playerStatusLabel.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, 2 * [[UIScreen mainScreen] bounds].size.height / 3);
    
    playerBar.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height - 28);
    computerBar.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, 48); //28 + 20 di status bar
    
    _game = [[Game alloc] init];
    _handle = [self.gameRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"New data: %@",snapshot.value);
        if(snapshot.value == (id)[NSNull null]){
            _game = nil;
            [self dismissViewControllerAnimated:YES completion:^{
                [[[UIAlertView alloc] initWithTitle:@"" message:@"Other user quited the game" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }];
        }else{
            [_game setFromDict:snapshot.value];
            if(_game.masterReady && _game.slaveReady){
                NSLog(@"Start game!");
            }
        }
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"Gameref: %@",self.gameRef);

    ball.hidden = YES;
    [startButton setTitle:@"Start" forState:UIControlStateNormal];
    playerStatusLabel.text = [NSString stringWithFormat:@"0"];
    computerStatusLabel.text = [NSString stringWithFormat:@"0"];
    
    playerBar.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height - 28);
    computerBar.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, 48); //28 + 20 di status bar
    
    ball.backgroundColor = [UIColor blackColor];
    playerBar.backgroundColor = [UIColor blackColor];
    computerBar.backgroundColor = [UIColor blackColor];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *drag = [[event allTouches] anyObject];
    playerBar.center = [drag locationInView:self.view];
    
    if(playerBar.center.y > [[UIScreen mainScreen] bounds].size.height - 28)
        playerBar.center = CGPointMake(playerBar.center.x, [[UIScreen mainScreen] bounds].size.height - 28);
    
    if(playerBar.center.y < [[UIScreen mainScreen] bounds].size.height - 28)
        playerBar.center = CGPointMake(playerBar.center.x, [[UIScreen mainScreen] bounds].size.height - 28);
    
    if(playerBar.center.x < 80)
        playerBar.center = CGPointMake(80, playerBar.center.y);
    
    if(playerBar.center.x > [[UIScreen mainScreen] bounds].size.width - 80)
        playerBar.center = CGPointMake([[UIScreen mainScreen] bounds].size.width - 80, playerBar.center.y);
    
}

-(IBAction)startButton:(id)sender {
    startButton.hidden = YES;
    ball.hidden = NO;
    
    Y = arc4random() % 11;
    Y -= 5;
    
    X = arc4random() % 11;
    X -= 5;
    
    if (Y == 0)
        Y=1;
    
    if (X == 0)
        X=1;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(ballMovement) userInfo:nil repeats:YES];
    
}

-(void)ballMovement {
    ball.center = CGPointMake(ball.center.x + X, ball.center.y + Y);
    
    [self collisioDetection];
    
    if (ball.center.x < 20)
        X= 0-X;
    
    if (ball.center.x > [[UIScreen mainScreen] bounds].size.width - 20)
        X = 0-X;
    
    if (ball.center.y < computerBar.center.y) {
        playerScore++;
        playerStatusLabel.text = [NSString stringWithFormat:@"%d", playerScore];
        
        [timer invalidate];
        startButton.hidden = NO;
        
        ball.hidden = YES;
        ball.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2);
        
        
        if (playerScore == 10) {
            startButton.hidden = YES;
            playerStatusLabel.text = [NSString stringWithFormat:@"WIN"];
            computerStatusLabel.text = [NSString stringWithFormat:@"LOOSE"];
        }
        
    }
    
    if (ball.center.y > playerBar.center.y) {
        computerScore++;
        computerStatusLabel.text = [NSString stringWithFormat:@"%d", computerScore];
        
        [timer invalidate];
        startButton.hidden = NO;
        
        ball.hidden = YES;
        ball.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2);
        
        if (computerScore == 10) {
            startButton.hidden = YES;
            playerStatusLabel.text = [NSString stringWithFormat:@"LOOSE"];
            computerStatusLabel.text = [NSString stringWithFormat:@"WIN"];
        }
        
    }
    
    
}

-(void)collisioDetection {
    if (CGRectIntersectsRect(playerBar.frame, ball.frame)) {
        Y = arc4random() % 5;
        Y = 0-Y;
    }
    
    if (CGRectIntersectsRect(computerBar.frame, ball.frame))
        Y = arc4random() % 5;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startGame:(id)sender {
    NSDictionary *update;
    if([self isMaster]){
        update = @{@"master_ready" : @YES};
    }else{
        update = @{@"slave_ready" : @YES};
    }
    [self.gameRef updateChildValues:update withCompletionBlock:^(NSError *error, Firebase *ref) {
        if (error) {
            NSLog(@"Data could not be updated. %@",error);
        }
    }];
    
    
}
- (IBAction)goBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    NSLog(@"Dissappear!");
    if([self isBeingDismissed] && _game != nil){
        if(self.isMaster){
            [self.gameRef removeValue];
        }else{
            NSDictionary *update = @{@"slave" : @""};
            [self.gameRef updateChildValues:update withCompletionBlock:^(NSError *error, Firebase *ref) {
                if (error) {
                    NSLog(@"Data could not be updated. %@",error);
                }
            }];
        }
        [self.gameRef removeAuthEventObserverWithHandle:_handle];
    }
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
