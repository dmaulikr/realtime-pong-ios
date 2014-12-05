//
//  Game.m
//  PongPong
//
//  Created by Ruud Visser on 05-12-14.
//  Copyright (c) 2014 Scrambled Apps. All rights reserved.
//

#import "Game.h"

@implementation Game

- (void)setFromDict:(NSDictionary *)dict{
    
    self.slaveReady = [[dict objectForKey:@"slave_ready"] boolValue];
    self.masterReady = [[dict objectForKey:@"master_ready"] boolValue];
    self.master = [dict objectForKey:@"master"];
    self.slave = [dict objectForKey:@"slave"];
    
}

@end
