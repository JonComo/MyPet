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

@property (nonatomic, strong) NSMutableArray *pets;

@property (nonatomic, weak) SKSpriteNode *nodeDragging;
@property (nonatomic, assign) CGPoint lastDragLocation;

@property (nonatomic, strong) SKSpriteNode *background;

@end

@implementation MPGameScene

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //init
        SKTexture *bgTex = [SKTexture textureWithImageNamed:@"bg"];
        bgTex.filteringMode = SKTextureFilteringLinear;
        _background = [[SKSpriteNode alloc] initWithTexture:bgTex];
        _background.xScale = _background.yScale = 2.f;
        _background.position = CGPointMake(size.width/2.f, size.height/2.f);
        [self addChild:_background];
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0.f, 35.f, size.width, size.height)];
        
        self.pets = [NSMutableArray array];
        
        // Add some friends
        for (int i = 0; i<3; i++) {
            MPPet *otherPet = [MPPet new];
            otherPet.position = CGPointMake(size.width/2.f, size.height/2.f);
            [self addChild:otherPet];
            [otherPet createNetwork];
            [self.pets addObject:otherPet];
        }
        
        //Hack - create looping animation so scene is always updated
        SKSpriteNode *loopSprite = [SKSpriteNode spriteNodeWithColor:[UIColor orangeColor] size:CGSizeMake(10, 10)];
        [self addChild:loopSprite];
        [loopSprite runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:0.1 duration:1]]];
        
        //Add some toys
        for (int i = 0; i<10; i++) {
            SKTexture *blockTex = [SKTexture textureWithImageNamed:@"block"];
            blockTex.filteringMode = SKTextureFilteringLinear;
            SKSpriteNode *block = [[SKSpriteNode alloc] initWithTexture:blockTex color:[UIColor whiteColor] size:CGSizeMake(40.f, 40.f)];
            block.position = CGPointMake(size.width/2.f, size.height/2.f);
            [self addChild:block];
            block.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:block.size];
        }
    }
    
    return self;
}

- (void)update:(NSTimeInterval)currentTime {
    for (MPPet *pet in self.pets) {
        [pet update:currentTime];
    }
    
    if (self.nodeDragging) {
        self.nodeDragging.position = self.lastDragLocation;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInNode:self];
    self.lastDragLocation = location;
    
    self.nodeDragging = nil;
    CGFloat distance = FLT_MAX;
    
    NSMutableArray *draggable = [self.children mutableCopy];
    [draggable removeObject:self.background];
    for (SKSpriteNode *child in draggable) {
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
