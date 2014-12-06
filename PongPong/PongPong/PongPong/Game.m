//
//  Game.m
//  PongPong
//
//  Created by Ruud Visser on 05-12-14.
//  Copyright (c) 2014 Scrambled Apps. All rights reserved.
//

#import "Game.h"

@implementation Game

- (id)init{
    
    self = [super init];
    if(self){
        self.master = [[Player alloc] init];
        self.slave = [[Player alloc] init];
        self.ballX = 0.0;
        self.ballY = 0.0;
    }
    return self;
}

- (void)setFromDict:(NSDictionary *)dict{
    
    [self.master setFromDict:[dict objectForKey:@"master"]];
    [self.slave setFromDict:[dict objectForKey:@"slave"]];
    self.ballX = [[dict objectForKey:@"ball_x"] floatValue];
    self.ballY = [[dict objectForKey:@"ball_y"] floatValue];
    
}

- (NSDictionary *)getDict{
    
    return @{ @"master" : [self.master getDict], @"slave" : [self.slave getDict], @"ball_x" : [NSNumber numberWithFloat:self.ballX], @"ball_y" : [NSNumber numberWithFloat:self.ballY]};
    
}

@end
