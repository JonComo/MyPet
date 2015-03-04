//
//  MPPet.h
//  MyPet
//
//  Created by Jon Como on 3/4/15.
//  Copyright (c) 2015 Jon Como. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MPPet : SKSpriteNode

- (void)createNetwork;
- (void)update:(NSTimeInterval)currentTime;

@end
