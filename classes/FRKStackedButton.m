//
//  FRKStackedButton.m
//  FRKStackedButton
//
//  Created by Francois Courville on 2015-06-19.
//  Copyright (c) 2015 Frankacy. All rights reserved.
//

#import "FRKStackedButton.h"
#import <objc/runtime.h>

@interface FRKStackedButton ()

@property(nonatomic, assign) UIEdgeInsets frk_backingTitleEdgeInsets;
@property(nonatomic, assign) UIEdgeInsets frk_backingImageEdgeInsets;
@property(nonatomic, assign) UIEdgeInsets frk_backingContentEdgeInsets;

@end

@implementation FRKStackedButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (!self) return nil;
    
    [self defaultValues];
    
    return self;
}

- (void)defaultValues {
    _imageSpacing = 20.0;
}

#pragma mark - Debug

- (void)showContentFrames:(BOOL)showContentFrames {
    NSDictionary *debugConstraints = @{ [UIColor redColor] : self.titleLabel,
                                        [UIColor blueColor] : self.imageView,
                                        [UIColor greenColor] : self };
    
    [debugConstraints enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setBorderForView:(UIView *)obj withColor:(UIColor *)key];
    }];
}

- (void)setBorderForView:(UIView *)view withColor:(UIColor *)color {
    view.layer.borderColor = [color CGColor];
    view.layer.borderWidth = 1;
}

#pragma mark - Custom Inset Management

- (void)setTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets {
    if (!UIEdgeInsetsEqualToEdgeInsets(titleEdgeInsets, _frk_backingTitleEdgeInsets)) {
        _frk_backingTitleEdgeInsets = titleEdgeInsets;
        [self setNeedsLayout];
    }
}

- (void)setImageEdgeInsets:(UIEdgeInsets)imageEdgeInsets {
    if (!UIEdgeInsetsEqualToEdgeInsets(imageEdgeInsets, _frk_backingImageEdgeInsets)) {
        _frk_backingImageEdgeInsets = imageEdgeInsets;
        [self setNeedsLayout];
    }
}

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
    if (!UIEdgeInsetsEqualToEdgeInsets(contentEdgeInsets, _frk_backingContentEdgeInsets)) {
        _frk_backingContentEdgeInsets = contentEdgeInsets;
        [self setNeedsLayout];
    }
}

#pragma mark - View drawing

- (void)layoutSubviews {
    [self centerImageAndTitle:self.imageSpacing];
    
    [super layoutSubviews];
}

- (void)centerImageAndTitle:(float)spacing {
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    // raise the image and push it right to center it
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    imageInsets = UIEdgeInsetsSum(imageInsets, self.frk_backingImageEdgeInsets);
    if (!UIEdgeInsetsEqualToEdgeInsets(imageInsets, self.imageEdgeInsets)) {
        [self setUnderlyingInsetsWithName:@"_imageEdgeInsets" value:imageInsets];
    }
    
    // lower the text and push it left to center it
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);
    titleInsets = UIEdgeInsetsSum(titleInsets, self.frk_backingImageEdgeInsets);
    if (!UIEdgeInsetsEqualToEdgeInsets(titleInsets, self.titleEdgeInsets)) {
        [self setUnderlyingInsetsWithName:@"_titleEdgeInsets" value:titleInsets];
    }
    
    CGFloat removedWidth = imageSize.width < titleSize.width ? imageSize.width : titleSize.width;
    CGFloat addedHeight = imageSize.height < titleSize.height ? imageSize.height : titleSize.height;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake((addedHeight + spacing)/2, -removedWidth/2, (addedHeight + spacing)/2, -removedWidth/2);
    contentInsets = UIEdgeInsetsSum(contentInsets, self.frk_backingContentEdgeInsets);
    if (!UIEdgeInsetsEqualToEdgeInsets(contentInsets, self.contentEdgeInsets)) {
        [self setUnderlyingInsetsWithName:@"_contentEdgeInsets" value:contentInsets];
    }
    
}

- (void)setUnderlyingInsetsWithName:(NSString *)propertyName value:(UIEdgeInsets)insets {
    UIEdgeInsets *buttonInsets = getIvarPointer(self, [propertyName cStringUsingEncoding:NSUTF8StringEncoding]);
    if (buttonInsets) {
        *buttonInsets = insets;
    }
}

static void* getIvarPointer(id object, char const *name) {
    Ivar ivar = class_getInstanceVariable(object_getClass(object), name);
    if (!ivar) return 0;
    return (uint8_t*)(__bridge void*)object + ivar_getOffset(ivar);
}

static UIEdgeInsets UIEdgeInsetsSum(UIEdgeInsets insets1, UIEdgeInsets insets2) {
    return UIEdgeInsetsMake(insets1.top + insets2.top,
                            insets1.left + insets2.left,
                            insets1.bottom + insets2.bottom,
                            insets1.right + insets2.right);
}

@end
