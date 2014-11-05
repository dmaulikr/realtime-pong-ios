//
//  StartViewController.m
//  PongPong
//
//  Created by Ruud Visser on 28-10-14.
//  Copyright (c) 2014 Scrambled Apps. All rights reserved.
//

#import "StartViewController.h"
#import "GameTableViewCell.h"
#import "PongViewController.h"
#import <Firebase/Firebase.h>

@interface StartViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_games;
    Firebase *_gamesRef;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (nonatomic, retain) NSString *username;
@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Firebase setLoggingEnabled:YES];
    
    _games = [[NSMutableArray alloc] init];
    
    _gamesRef = [[Firebase alloc] initWithUrl:@"https://fiery-inferno-4044.firebaseio.com/games"];
    
    __block BOOL initialLoad = YES;

    
    [_gamesRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        [_games addObject:snapshot.value];
        // Reload the table view so the new message will show up.
        if (!initialLoad) {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:([_games count]-1) inSection:0];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationTop];
        }
    }];
    [_gamesRef observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        int index = (int)[_games indexOfObject:snapshot.value];
        [_games removeObjectAtIndex:index];
        // Reload the table view so the new message will show up.
        if (!initialLoad) {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:index inSection:0];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationRight];
        }
    }];
    
    // Value event fires right after we get the events already stored in the Firebase repo.
    // We've gotten the initial messages stored on the server, and we want to run reloadData on the batch.
    // Also set initialAdds=NO so that we'll reload after each additional childAdded event.
    [_gamesRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        // Reload the table view so that the intial messages show up
        [self.tableView reloadData];
        initialLoad = NO;
    }];
    // Do any additional setup after loading the view.
}
- (IBAction)start:(id)sender {
    
    self.username = self.usernamTextfield.text;
    [self.usernamTextfield resignFirstResponder];
    [UIView animateWithDuration:0.6 animations:^{
        [self.startButton setAlpha:0];
        [self.usernamTextfield setAlpha:0];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 animations:^{
            [self.tableView setAlpha:1];
            [self.addGameButton setAlpha:1];
        }];
    }];
}

- (void)addGame:(id)sender{
    
    NSDictionary *game = @{@"master" : self.username, @"slave": @""};
    NSLog(@"Add game: %@",game);
    [[_gamesRef childByAutoId] setValue:game withCompletionBlock:^(NSError *error, Firebase *ref) {
        if (error) {
            NSLog(@"Data could not be saved. %@",error);
        } else {
            
            [self performSegueWithIdentifier:@"startGame" sender:ref];
            
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"startGame"]){
        PongViewController *pvc = (PongViewController *)segue.destinationViewController;
        pvc.gameRef = (Firebase *)sender;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_games count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GameTableViewCell *gtvc = (GameTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"gameCell"];
    NSDictionary *game = [_games objectAtIndex:indexPath.row];
    [gtvc.playerName setText:game[@"master"]];
    
    return gtvc;
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
