//
//  GameScene.m
//  ZoopShooter
//
//  Created by Tom Hartnett on 5/29/15.
//  Copyright (c) 2015 Tom Hartnett. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()
@property BOOL contentCreated;
@property SKNode *cannon;
@property CGPoint startingPoint;
@end

@implementation GameScene

- (void)didMoveToView:(SKView *)view {
    
    if (!self.contentCreated) {
        
        [self createSceneContents];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [[self view] addGestureRecognizer:tapRecognizer];
        
        self.contentCreated = YES;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (touches.count != 1)
        return;
    
    NSLog(@"%@, %lu", NSStringFromSelector(_cmd), (unsigned long)touches.count);
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    float dY = self.cannon.position.y - location.y;
    float dX = self.cannon.position.x - location.x;
    float angle = (atan2f(dY, dX)) + 1.571f;
    self.cannon.zRotation = angle;
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)sender {
    
    // Down     = 8
    // Up       = 4
    // Left     = 2
    // Right    = 1
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"%lu, %@ StateEnded", (unsigned long)sender.direction, NSStringFromSelector(_cmd));
    } else {
        
        NSLog(@"%lu %@", (unsigned long)sender.direction, NSStringFromSelector(_cmd));
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender {

    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if (fabs(self.cannon.physicsBody.angularVelocity) > 0) {
        self.cannon.physicsBody.angularVelocity = 0;
    }
}

- (void)createSceneContents {
    
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsWorld.gravity = CGVectorMake(0,0); // disable gravity
    
    self.cannon = [self newCannon];
    self.cannon.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.cannon.frame) / 2);
    [self addChild:self.cannon];
}

- (SKShapeNode *)newCannon {
    
    SKShapeNode *wheel = [SKShapeNode shapeNodeWithCircleOfRadius:50];
    wheel.fillColor = [UIColor grayColor];
    wheel.strokeColor = [UIColor grayColor];
    wheel.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:50];
    wheel.physicsBody.affectedByGravity = NO;
    wheel.physicsBody.angularDamping = 0.9;
    wheel.physicsBody.mass = 1000;
    
    NSLog(@"cannon mass:  %f", wheel.physicsBody.mass);
    
    SKSpriteNode *light1 = [self newLight];
    light1.position = CGPointMake(0, 40);
    [wheel addChild:light1];
    
    return wheel;
}

- (SKSpriteNode *)newLight {
    
    SKSpriteNode *light = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(8,8)];
    
    return light;
}

@end
