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
@property (nonatomic, assign) CGFloat rollStrength;

@end

@implementation MPPet

-(instancetype)init {
    if (self = [super initWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"pet"]]]) {
        // init
        _symbol = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"symbol%i", arc4random()%3+1]]];
        [self addChild:_symbol];
        
        _jumpStrength = 26.f;
        _rollStrength = .001f;
        
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.texture.size.width/2.2f];
        _brain = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(70.f, 70.f)];
        //[self addChild:_brain];
    }
    
    return self;
}

- (void)createNetwork {
    self.inputNeurons = @{@"energy": [FNNeuron neuron]};
    
    __weak MPPet *weakSelf = self;
    self.outputNeurons = @{
                           @"jumpLeft": [FNNeuron neuronWithFire:^(float amplitude) {
                               [weakSelf jumpInDirection:CGVectorMake(-1.f, 1.f)];
                           }],
                           @"jumpRight": [FNNeuron neuronWithFire:^(float amplitude) {
                               [weakSelf jumpInDirection:CGVectorMake(1.f, 1.f)];
                           }],
                           @"rollLeft": [FNNeuron neuronWithFire:^(float amplitude) {
                               [weakSelf rollWithTorque:-1.f];
                           }],
                           @"rollRight": [FNNeuron neuronWithFire:^(float amplitude) {
                               [weakSelf rollWithTorque:1.f];
                           }],
                           @"chirp": [FNNeuron neuronWithFire:^(float amplitude) {
                               [weakSelf runAction:[SKAction playSoundFileNamed:[NSString stringWithFormat:@"chirp%i.wav", arc4random()%3 + 1] waitForCompletion:NO]];
                               [weakSelf.symbol runAction:[SKAction sequence:@[[SKAction scaleTo:(float)(arc4random()%20 + 70)/100.f duration:0.1f], [SKAction scaleTo:1.f duration:0.15f]]]];
                           }]};
    
    self.network = [[FNNetwork alloc] initWithLayers:4 neuronsPerLayer:3 inputs:[self.inputNeurons allValues] outputs:[self.outputNeurons allValues]];
}

- (void)jumpInDirection:(CGVector)direction {
    [self.physicsBody applyImpulse:CGVectorMake(direction.dx * self.jumpStrength, direction.dy * self.jumpStrength)];
}

- (void)rollWithTorque:(CGFloat)torque {
    [self.physicsBody applyAngularImpulse:torque * self.rollStrength];
}

-(void)update:(NSTimeInterval)currentTime {
    FNNeuron *energyNeuron = self.inputNeurons[@"energy"];
    [energyNeuron receiveImpulse:0.2f];
    
    [self rollUpright];
    
    self.symbol.zRotation -= (self.symbol.zRotation - self.physicsBody.angularVelocity) * .02f;
    //self.brain.texture = [SKTexture textureWithImage:[self.network renderWithSize:CGSizeMake(70, 70)]];
    //self.brain.zRotation = -self.zRotation;
}

- (void)rollUpright {
    [self.physicsBody applyTorque:-0.7*self.zRotation];
}

@end
