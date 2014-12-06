//
//  Game.h
//  PongPong
//
//  Created by Ruud Visser on 05-12-14.
//  Copyright (c) 2014 Scrambled Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface Game : NSObject

@property (nonatomic,retain) Player *master;
@property (nonatomic,retain) Player *slave;
@property (nonatomic) CGFloat ballX;
@property (nonatomic) CGFloat ballY;

- (void)setFromDict:(NSDictionary *)dict;
- (NSDictionary *)getDict;
@end
