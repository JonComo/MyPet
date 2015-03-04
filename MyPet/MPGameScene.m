//
//  MPGameScene.m
//  MyPet
//
//  Created by Jon Como on 3/4/15.
//  Copyright (c) 2015 Jon Como. All rights reserved.
//

#import "MPGameScene.h"
#import "JCMath.h"
#import "MPPet.h"

@interface MPGameScene ()

@property (nonatomic, strong) MPPet *pet;
@property (nonatomic, weak) SKSpriteNode *nodeDragging;
@property (nonatomic, assign) CGPoint lastDragLocation;

@end

@implementation MPGameScene

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //init
        self.backgroundColor = [UIColor orangeColor];
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0.f, 0.f, size.width, size.height)];
        
        _pet = [[MPPet alloc] init];
        _pet.position = CGPointMake(size.width/2.f, size.height/2.f);
        [self addChild:_pet];
        [_pet createNetwork];
        
        //Hack - create looping animation so scene is always updated
        SKSpriteNode *loopSprite = [SKSpriteNode spriteNodeWithColor:[UIColor orangeColor] size:CGSizeMake(10, 10)];
        [self addChild:loopSprite];
        [loopSprite runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:0.1 duration:1]]];
    }
    
    return self;
}

- (void)update:(NSTimeInterval)currentTime {
    [self.pet update:currentTime];
    
    if (self.nodeDragging) {
        self.nodeDragging.position = self.lastDragLocation;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInNode:self];
    self.lastDragLocation = location;
    
    self.nodeDragging = nil;
    CGFloat distance = FLT_MAX;
    
    for (SKSpriteNode *child in self.children) {
        CGFloat testDist = [JCMath distanceBetweenPoint:location andPoint:child.position sorting:NO];
        if (testDist < distance) {
            self.nodeDragging = child;
            distance = testDist;
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInNode:self];
    
    CGFloat throwIntensity = 20.f;
    self.nodeDragging.physicsBody.velocity = CGVectorMake((location.x - self.lastDragLocation.x) * throwIntensity, (location.y - self.lastDragLocation.y) * throwIntensity);
    
    self.lastDragLocation = [[touches anyObject] locationInNode:self];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInNode:self];
    
    if (self.nodeDragging) {
        self.nodeDragging = nil;
    }
}

@end
