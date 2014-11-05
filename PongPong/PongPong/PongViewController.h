//
//  PongViewController.h
//  PongPong
//
//  Created by Ruud Visser on 05-11-14.
//  Copyright (c) 2014 Scrambled Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface PongViewController : UIViewController

@property (nonatomic,retain) Firebase *gameRef;

@end
