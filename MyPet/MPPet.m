//
//  MPPet.m
//  MyPet
//
//  Created by Jon Como on 3/4/15.
//  Copyright (c) 2015 Jon Como. All rights reserved.
//

#import "MPPet.h"
#import "JCMath.h"

#import "FNNetwork.h"

@interface MPPet ()

@property (nonatomic, strong) NSDictionary *inputNeurons;
@property (nonatomic, strong) NSDictionary *outputNeurons;
@property (nonatomic, strong) FNNetwork *network;

@property (nonatomic, strong) SKSpriteNode *brain;

@property (nonatomic, assign) CGFloat jumpStrength;

@end

@implementation MPPet

-(instancetype)init {
    if (self = [super initWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"pet"]]]) {
        // init
        
        _jumpStrength = 60.f;
        
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.texture.size.width];
        _brain = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(100.f, 100.f)];
        [self addChild:_brain];
    }
    
    return self;
}

- (void)createNetwork {
    self.inputNeurons = @{@"energy": [FNNeuron neuron]};
    
    __weak MPPet *weakSelf = self;
    self.outputNeurons = @{@"rollLeft": [FNNeuron neuronWithFire:^(float amplitude) {
        [weakSelf jumpInDirection:CGVectorMake(-1.f, 1.f)];
    }], @"rollRight": [FNNeuron neuronWithFire:^(float amplitude) {
        [weakSelf jumpInDirection:CGVectorMake(1.f, 1.f)];
    }]};
    
    self.network = [[FNNetwork alloc] initWithLayers:4 neuronsPerLayer:6 inputs:[self.inputNeurons allValues] outputs:[self.outputNeurons allValues]];
}

- (void)jumpInDirection:(CGVector)direction {
    [self.physicsBody applyImpulse:CGVectorMake(direction.dx * self.jumpStrength, direction.dy * self.jumpStrength)];
}

-(void)update:(NSTimeInterval)currentTime {
    FNNeuron *energyNeuron = self.inputNeurons[@"energy"];
    [energyNeuron receiveImpulse:0.02f];
    
    [self rollUpright];
    
    self.brain.texture = [SKTexture textureWithImage:[self.network renderWithSize:CGSizeMake(100, 100)]];
    self.brain.zRotation = -self.zRotation;
    self.brain.position = [JCMath pointFromPoint:CGPointZero pushedBy:100.f inDirection:-self.zRotation];
}

- (void)rollUpright {
    [self.physicsBody applyTorque:-0.7*self.zRotation];
}

@end
