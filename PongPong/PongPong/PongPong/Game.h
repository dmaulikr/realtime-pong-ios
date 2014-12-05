//
//  Game.h
//  PongPong
//
//  Created by Ruud Visser on 05-12-14.
//  Copyright (c) 2014 Scrambled Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game : NSObject

@property (nonatomic) BOOL slaveReady;
@property (nonatomic) BOOL masterReady;
@property (nonatomic,retain) NSString *slave;
@property (nonatomic,retain) NSString *master;

- (void)setFromDict:(NSDictionary *)dict;

@end
