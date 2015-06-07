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
    
    // Get deltaX and deltaY.
    CGFloat dx = self.startingPoint.x - location.x;
    CGFloat dy = self.startingPoint.y - location.y;

    CGFloat d;
    if (fabs(dx) > fabs(dy)) {
        // dx is bigger.
        d = dx;
        // Check where touch is in relation to cannon and rotate cannon appropriately.
        if (location.y < self.cannon.position.y)
            d *= -1;
        
    } else {
        // dy is bigger.
        d = dy;
        // Check where touch is in relation to cannon and rotate cannon appropriately.
        if (location.x > self.cannon.position.x)
            d *= -1;
    }
    
    // Convert to radians.
    d = d * 0.0174532925;
    
    // Adjust cannon rotation.
    self.cannon.zRotation += d;
    
    // Save location for next touchesMoved event.
    self.startingPoint = location;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)didSimulatePhysics {
    
    // Remove missiles that have flown off-screen.
    [self enumerateChildNodesWithName:@"missile" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0 || node.position.y > self.frame.size.height || node.position.x < 0 || node.position.x > self.frame.size.width) {
            [node removeFromParent];
        }
    }];
}

- (void)handleTap:(UITapGestureRecognizer *)sender {

    // Need to correct angle by PI/2 for some unknown reason.
    CGFloat angle = self.cannon.zRotation + M_PI_2;
    // Get new missile.
    SKShapeNode *missile = [self newMissile];
    // Calculate missile position as point on circle at appropriate angle.
    CGFloat x = self.cannon.position.x + self.cannon.frame.size.width/2 * cos(angle);
    CGFloat y = self.cannon.position.y + self.cannon.frame.size.height/2 * sin(angle);
    missile.position = CGPointMake(x, y);
    
    NSLog(@"cx: %f, cy: %f, x: %f, y: %f, a: %f, cos(a): %f, sin(a): %f, w: %f, h: %f", self.cannon.position.x, self.cannon.position.y, x, y, angle, cos(angle), sin(angle), self.cannon.frame.size.width, self.cannon.frame.size.height);
    
    [self addChild:missile];
    
    [missile.physicsBody applyImpulse:CGVectorMake(100 * cos(angle), 100 * sin(angle))];
}

- (void)createSceneContents {
    
    self.backgroundColor = [SKColor colorWithRed:78.0/255.0 green:10.0/255.0 blue:136.0/255.0 alpha:1.0];
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
    missile.physicsBody.dynamic = YES;
    missile.physicsBody.restitution = 0.0;
    missile.physicsBody.linearDamping = 0.0;
    missile.physicsBody.angularDamping = 0.0;
    missile.physicsBody.mass = 1;
    missile.name = @"missile";
    
    return missile;
}

@end
