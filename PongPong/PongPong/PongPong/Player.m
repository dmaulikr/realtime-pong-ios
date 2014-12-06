//
//  Player.m
//  PongPong
//
//  Created by Ruud Visser on 05-12-14.
//  Copyright (c) 2014 Scrambled Apps. All rights reserved.
//

#import "Player.h"

@implementation Player


- (id)init{
    
    self = [super init];
    if(self){
        self.name = @"";
        self.ready = NO;
        self.barPosition = 0.0;
        self.score = [NSNumber numberWithInt:0];
    }
    return self;
}

- (void)setFromDict:(NSDictionary *)dict{
    
    self.ready = [[dict objectForKey:@"ready"] boolValue];
    self.name = [dict objectForKey:@"name"];
    self.score = [dict objectForKey:@"score"];
    self.barPosition = [[dict objectForKey:@"bar_position"] floatValue];
}

- (NSDictionary *)getDict{
    
    return @{ @"ready" : [NSNumber numberWithBool:self.ready], @"name" : self.name, @"score" : self.score, @"bar_position" : [NSNumber numberWithFloat:self.barPosition]};
    
}

@end
