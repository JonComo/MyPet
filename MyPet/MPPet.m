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
@property (nonatomic, strong) SKSpriteNode *symbol;

@property (nonatomic, assign) CGFloat jumpStrength;

@end

@implementation MPPet

-(instancetype)init {
    if (self = [super initWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"pet"]]]) {
        // init
        _symbol = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"symbol"]];
        [self addChild:_symbol];
        
        _jumpStrength = 30.f;
        
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.texture.size.width/2.2f];
        _brain = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(70.f, 70.f)];
        //[self addChild:_brain];
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
    [energyNeuron receiveImpulse:0.05f];
    
    [self rollUpright];
    
    self.symbol.zRotation = -self.zRotation + self.physicsBody.angularVelocity * 0.2f;
    //self.brain.texture = [SKTexture textureWithImage:[self.network renderWithSize:CGSizeMake(70, 70)]];
    //self.brain.zRotation = -self.zRotation;
}

- (void)rollUpright {
    [self.physicsBody applyTorque:-0.7*self.zRotation];
}

@end
