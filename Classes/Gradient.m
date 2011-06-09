//
//  Gradient.m
//  iWhirl
//
//  Created by Matt Gallagher on 2009/08/21.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//	http://cocoawithlove.com/2009/08/adding-shadow-effects-to-uitableview.html

#import "Gradient.h"
#import <QuartzCore/QuartzCore.h>


@implementation Gradient

+(Class)layerClass {
	return [CAGradientLayer class];
}

- (void)setupGradientLayer
{
	CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
	gradientLayer.colors =
	[NSArray arrayWithObjects:
	 (id)[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor,
	 (id)[UIColor colorWithRed:0.45 green:0.85 blue:0.85 alpha:1.0].CGColor,
	 nil];
	self.backgroundColor = [UIColor clearColor];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
		gradientLayer.colors =
		[NSArray arrayWithObjects:
		 (id)[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor,
		 (id)[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0].CGColor,
		 nil];
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
