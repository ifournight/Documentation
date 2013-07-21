//
//  NodeCell.m
//  Documentation
//
//  Created by Song Hui on 13-7-20.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "NodeCell.h"
#import "Appearance.h"
#import "SearchNode.h"

@implementation NodeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        UIImage *background = [[Appearance share] imageForTokenCellBackground];
        self.backgroundView = [[UIImageView alloc] initWithImage:background];
        
        _icon = [[UIImageView alloc] init];
        [self.contentView addSubview:_icon];
        
        _main = [[UILabel alloc] init];
        _main.backgroundColor = [UIColor clearColor];
        _main.numberOfLines = 0;
        [_main setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:_main];
        
        [self setupConstraints];
    }
    return self;
}

- (void)setNode:(SearchNode *)node
{
    if (_node != node) {
        _node = node;
        
        self.icon.image = [[Appearance share] imageForNodeType:_node.nodeType documentType:_node.documentType];
        [self.icon sizeToFit];
        
        NSAttributedString *mainAttributedText = [[NSAttributedString alloc] initWithString:_node.name
                                                                                 attributes:[[Appearance share] textAttributesForNodeMain]];
        self.main.attributedText = mainAttributedText;
        
        [self layoutIfNeeded];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setupConstraints
{
    NSDictionary *viewsDictionary = @{@"Icon" : self.icon,
                                      @"Main" : self.main};
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[Icon][Main]-10-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[Main]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary]];
    [self.main setPreferredMaxLayoutWidth:260.0];
    
}

- (CGSize)intrinsicContentSize
{
    if (self.node) {
        CGSize mainSize = self.main.intrinsicContentSize;
        
        CGFloat cellWidth = self.icon.intrinsicContentSize.width + mainSize.width + 10;
        CGFloat cellHeight = MAX(mainSize.height + 13, 44);
        
        return  CGSizeMake(cellWidth, cellHeight);
    }   else {
        return  CGSizeZero;
    }
}

@end
