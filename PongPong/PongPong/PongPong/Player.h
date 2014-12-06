//
//  Player.h
//  PongPong
//
//  Created by Ruud Visser on 05-12-14.
//  Copyright (c) 2014 Scrambled Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Player : NSObject

@property (nonatomic) BOOL ready;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSNumber *score;
@property (nonatomic) CGFloat barPosition;

- (void)setFromDict:(NSDictionary *)dict;
- (NSDictionary *)getDict;

@end
