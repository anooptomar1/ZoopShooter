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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (touches.count != 1)
        return;
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    self.startingPoint = location;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (touches.count != 1)
        return;
    
    if ([self.cannon hasActions])
        return;
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    // Get deltaX & deltaY
    CGFloat dx = self.startingPoint.x - location.x;
    CGFloat dy = self.startingPoint.y - location.y;

    CGFloat d;
    if (fabs(dx) > fabs(dy)) {
        // dx is bigger
        d = dx;
    } else {
        // dy is bigger
        d = dy;
    }
    
    // Convert to radians
    d = d * 0.0174532925;
    
    self.cannon.zRotation += d;
    
    self.startingPoint = location;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
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
    
    SKSpriteNode *light1 = [self newLight];
    light1.position = CGPointMake(0, 40);
    [wheel addChild:light1];
    
    return wheel;
}

- (SKSpriteNode *)newLight {
    
    SKSpriteNode *light = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(8,8)];
    
    return light;
}

- (SKShapeNode *)newMissile {
    
    SKShapeNode *missile = [SKShapeNode shapeNodeWithCircleOfRadius:5.0];
    missile.fillColor = [UIColor redColor];
    missile.strokeColor = [UIColor redColor];
    missile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:5.0];
    missile.physicsBody.affectedByGravity = NO;
    missile.physicsBody.mass = 100;
    
    return missile;
}

@end
