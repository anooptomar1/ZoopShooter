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
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [[self view] addGestureRecognizer:panRecognizer];
        
        self.contentCreated = YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"%@, %lu", NSStringFromSelector(_cmd), (unsigned long)touches.count);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    NSLog(@"%@", NSStringFromSelector(_cmd));
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

- (void)handlePan:(UIPanGestureRecognizer *)sender {
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        CGPoint location = [sender locationInView:self.view];
        location = [self convertPointFromView:location];
        CGFloat dx = location.x - self.cannon.position.x;
        CGFloat dy = location.y = self.cannon.position.y;
        self.startingPoint = CGPointMake(dx, dy);
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        CGPoint location = [sender locationInView:self.view];
        location = [self convertPointFromView:location];
        CGFloat dx = location.x - self.cannon.position.x;
        CGFloat dy = location.y = self.cannon.position.y;
        CGFloat direction = sin(self.startingPoint.x * dy - self.startingPoint.y * dx);

        NSLog(@"direction: %f", direction);
        
        dx = [sender velocityInView:self.view].x;
        dy = [sender velocityInView:self.view].y;
        CGFloat speed = sqrt(dx*dx + dy*dy);
        [self.cannon.physicsBody applyAngularImpulse:speed * direction];
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
