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
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@end

@implementation PongViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    playerScore = 0;
    computerScore = 0;
    
    //playerBar.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height - 28);
    computerBar.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, 48); //28 + 20 di status bar
    
    _game = [[Game alloc] init];
    if(self.isMaster){
        _handle = [[self.gameRef childByAppendingPath:@"slave"] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            
            NSLog(@"Value: %@",snapshot.value);
            if(snapshot.value != (id)[NSNull null]){
                Player *slave = [[Player alloc] init];
                [slave setFromDict:snapshot.value];
                _game.slave = slave;
                [self setBar:slave.barPosition isOwnBar:NO];
            }
            
        }];
    }else{
        _handle = [[self.gameRef childByAppendingPath:@"master"] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            
            NSLog(@"Value: %@",snapshot.value);
            if(snapshot.value != (id)[NSNull null]){
                Player *master = [[Player alloc] init];
                [master setFromDict:snapshot.value];
                _game.master = master;
                [self setBar:master.barPosition isOwnBar:NO];
            }
        }];
    }
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"Gameref: %@",self.gameRef);

    ball.hidden = YES;
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
    playerStatusLabel.text = [NSString stringWithFormat:@"0"];
    computerStatusLabel.text = [NSString stringWithFormat:@"0"];
    
    playerBar.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height - 28);
    computerBar.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, 48); //28 + 20 of status bar
    
    //Half-court line
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.view.bounds];
    [shapeLayer setPosition:self.view.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor whiteColor] CGColor]];
    [shapeLayer setLineWidth:5.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:20],[NSNumber numberWithInt:20],nil]];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, [[UIScreen mainScreen] bounds].size.height /2);
    CGPathAddLineToPoint(path, NULL, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height /2);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    [[self.view layer] addSublayer:shapeLayer];
    
    ball.backgroundColor = [UIColor whiteColor];
    playerBar.backgroundColor = [UIColor whiteColor];
    computerBar.backgroundColor = [UIColor whiteColor];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *drag = [[event allTouches] anyObject];
    
    CGFloat x = [drag locationInView:self.view].x;
    [self setBar:x isOwnBar:YES];
    
    Player *player = [self getCurrentPlayer];
    player.barPosition = x;
    [self updateCurrentUser];
    
}

- (void)setBar:(CGFloat)x isOwnBar:(BOOL)ownBar{
    
    UIImageView *view;
    CGFloat y;
    if((ownBar && [self isMaster]) || (!ownBar && ![self isMaster])){
        view = playerBar;
        y = [[UIScreen mainScreen] bounds].size.height - 28;
    }else{
        view = computerBar;
        y = 28;
    }
    
    view.center = CGPointMake(x, y);
    
    if(view.center.x < 80)
        view.center = CGPointMake(80, view.center.y);
    
    if(view.center.x > [[UIScreen mainScreen] bounds].size.width - 80)
        view.center = CGPointMake([[UIScreen mainScreen] bounds].size.width - 80, view.center.y);
    
}

-(void)startTheGame {
    
    
    if([self isMaster]){
        NSDictionary *update = @{@"slave_ready" : @NO,
                                @"master_ready" : @NO};
        [self.gameRef updateChildValues:update withCompletionBlock:^(NSError *error, Firebase *ref) {
            if (error) {
                NSLog(@"Data could not be updated. %@",error);
            }
        }];
    }
    
    self.startButton.hidden = YES;
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
        self.startButton.hidden = NO;
        
        ball.hidden = YES;
        ball.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2);
        
        
        if (playerScore == 10) {
            self.startButton.hidden = YES;
            playerStatusLabel.text = [NSString stringWithFormat:@"WIN"];
            computerStatusLabel.text = [NSString stringWithFormat:@"LOOSE"];
        }
        
    }
    
    if (ball.center.y > playerBar.center.y) {
        computerScore++;
        computerStatusLabel.text = [NSString stringWithFormat:@"%d", computerScore];
        
        [timer invalidate];
        self.startButton.hidden = NO;
        
        ball.hidden = YES;
        ball.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2);
        
        if (computerScore == 10) {
            self.startButton.hidden = YES;
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
    Player *player = [self getCurrentPlayer];
    player.ready = YES;
    [self updateCurrentUser];
}

- (void)updateCurrentUser
{
    NSString *user;
    if([self isMaster]){
        user = @"master";
    }else{
        user = @"slave";
    }
    [[self.gameRef childByAppendingPath:user] updateChildValues:[[self getCurrentPlayer] getDict] withCompletionBlock:^(NSError *error, Firebase *ref) {
        if (error) {
            NSLog(@"Data could not be updated. %@",error);
        }
    }];
    
}

- (Player *)getCurrentPlayer{

    if([self isMaster]){
        return _game.master;
    }else{
        return _game.slave;
    }
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
