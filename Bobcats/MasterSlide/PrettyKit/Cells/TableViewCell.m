//
//  TableViewCell
//  GreenBeansMerch
//
//  Created by Burchfield, Neil on 1/12/13.
//  Copyright (c) 2013 Burchfield, Neil. All rights reserved.
//


#import "TableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Drawing.h"

#define shadow_margin                          4
#define default_shadow_opacity                 0.7

#define contentView_margin                     2

#define default_radius                         10

#define default_border_color                   [UIColor colorWithHex:0xBCBCBC]
#define default_separator_color                [UIColor colorWithHex:0xCDCDCD]

#define default_selection_gradient_start_color [UIColor colorWithHex:0x0089F9]
#define default_selection_gradient_end_color   [UIColor colorWithHex:0x0054EA]


typedef enum {
    CellBackgroundBehaviorNormal = 0,
    CellBackgroundBehaviorSelected,
} CellBackgroundBehavior;

typedef enum {
    CellBackgroundGradientNormal = 0,
    CellBackgroundGradientSelected,
} CellBackgroundGradient;



@interface TableViewCell (Private)

- (float) shadowMargin;
- (BOOL) tableViewIsGrouped;

@end

@implementation TableViewCell (Private)
- (BOOL) tableViewIsGrouped {
    return _tableViewStyle == UITableViewStyleGrouped;
} /* tableViewIsGrouped */


- (float) shadowMargin {
    return [self tableViewIsGrouped] ? shadow_margin : 0;
} /* shadowMargin */


@end

@interface TableViewCellBackground : UIView

@property (nonatomic, assign) TableViewCell *cell;
@property (nonatomic, assign) CellBackgroundBehavior behavior;

- (id) initWithFrame :(CGRect)frame behavior :(CellBackgroundBehavior)behavior;

@end

@implementation TableViewCellBackground
@synthesize cell;
@synthesize behavior;


- (CGPathRef) createRoundedPath :(CGRect)rect {
    if (!self.cell.cornerRadius) {
        return [UIBezierPath bezierPathWithRect:rect].CGPath;
    }

    UIRectCorner corners;

    switch (self.cell.position) {
        case TableViewCellPositionTop :
            corners = UIRectCornerTopLeft | UIRectCornerTopRight;
            break;
        case TableViewCellPositionMiddle :
            corners = 0;
            break;
        case TableViewCellPositionBottom :
            corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            break;
        default :
            corners = UIRectCornerAllCorners;
            break;
    } /* switch */

    UIBezierPath *thePath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                  byRoundingCorners:corners
                                                        cornerRadii:CGSizeMake(self.cell.cornerRadius, self.cell.cornerRadius)];
    return thePath.CGPath;
} /* createRoundedPath */


- (CGGradientRef) newGradientFromType :(CellBackgroundGradient)type {
    switch (type) {
        case CellBackgroundGradientSelected :
            return [self.cell newSelectionGradient];

        default :
            return [self.cell newNormalGradient];
    } /* switch */
} /* newGradientFromType */


- (void) drawGradient :(CGRect)rect type :(CellBackgroundGradient)type {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);

    CGPathRef path;
    path = [self createRoundedPath:rect];

    CGContextAddPath(ctx, path);

    CGGradientRef gradient = [self newGradientFromType:type];

    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));

    CGContextClip(ctx);
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);

    CGContextRestoreGState(ctx);
} /* drawGradient */


- (void) drawBackground :(CGRect)rect {
    if ((self.behavior == CellBackgroundBehaviorSelected)
        && (self.cell.selectionStyle != UITableViewCellSelectionStyleNone)) {
        [self drawGradient:rect type:CellBackgroundGradientSelected];
        return;
    }

    if (self.cell.gradientStartColor && self.cell.gradientEndColor) {
        [self drawGradient:rect type:CellBackgroundGradientNormal];
        return;
    }

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);

    // draws body
    CGPathRef path;
    path = [self createRoundedPath:rect];

    CGContextAddPath(ctx, path);

    CGContextSetFillColorWithColor(ctx, self.cell.backgroundColor.CGColor);
    CGContextFillPath(ctx);

    CGContextRestoreGState(ctx);
} /* drawBackground */


- (void) drawSingleLineSeparator :(CGRect)rect {
    [Drawing drawLineAtHeight:CGRectGetMaxY(rect)
                         rect:rect
                        color:self.cell.customSeparatorColor
                        width:1];
} /* drawSingleLineSeparator */


- (void) drawEtchedSeparator :(CGRect)rect {
    [Drawing drawLineAtHeight:CGRectGetMaxY(rect) - 1
                         rect:rect
                        color:self.cell.customSeparatorColor
                        width:0.5];
    [Drawing drawLineAtHeight:CGRectGetMaxY(rect) - 0.5
                         rect:rect
                        color:[UIColor whiteColor]
                        width:1];

} /* drawEtchedSeparator */


- (void) drawLineSeparator :(CGRect)rect {
    switch (self.cell.customSeparatorStyle) {
        case UITableViewCellSeparatorStyleSingleLine :
            [self drawSingleLineSeparator:rect];
            break;
        case UITableViewCellSeparatorStyleSingleLineEtched :
            [self drawEtchedSeparator:rect];
        default :
            break;
    } /* switch */
} /* drawLineSeparator */


- (void) fixShadow :(CGContextRef)ctx rect :(CGRect)rect {
    if ((self.cell.position == TableViewCellPositionTop) || (self.cell.position == TableViewCellPositionAlone)) {
        return;
    }

    CGContextSaveGState(ctx);
    CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGContextSetStrokeColorWithColor(ctx, self.cell.borderColor.CGColor);
    CGContextSetLineWidth(ctx, 5);

    UIColor *shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:self.cell.shadowOpacity];
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, -1), 3, shadowColor.CGColor);

    CGContextStrokePath(ctx);

    CGContextRestoreGState(ctx);

} /* fixShadow */


- (void) drawBorder :(CGRect)rect shadow :(BOOL)shadow {
    float shadowShift = 0.5 * self.cell.dropsShadow;

    CGRect innerRect = CGRectMake(rect.origin.x + shadowShift, rect.origin.y + shadowShift,
                                  rect.size.width - shadowShift * 2, rect.size.height - shadowShift * 2);

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    if (shadow) {
        [self fixShadow:ctx rect:innerRect];
    }


    CGContextSaveGState(ctx);

    // draws body

    CGPathRef path = [self createRoundedPath:innerRect];
    CGContextAddPath(ctx, path);

    if (shadow) {
        UIColor *shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:self.cell.shadowOpacity];
        CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 3, shadowColor.CGColor);
    }
    CGContextSetStrokeColorWithColor(ctx, self.cell.borderColor.CGColor);
    CGContextSetLineWidth(ctx, 2 - shadowShift);
    CGContextStrokePath(ctx);

    CGContextRestoreGState(ctx);
} /* drawBorder */


- (CGRect) innerFrame :(CGRect)frame {
    float y = 0;
    float h = 0;

    float shadowMargin = [self.cell shadowMargin];

    switch (self.cell.position) {
        case TableViewCellPositionAlone :
            h += shadowMargin;
        case TableViewCellPositionTop :
            y = shadowMargin;
            h += shadowMargin;
            break;
        case TableViewCellPositionBottom :
            h = shadowMargin;
            break;
        default :
            break;
    } /* switch */

    return CGRectMake(frame.origin.x + shadowMargin,
                      frame.origin.y + y,
                      frame.size.width - shadowMargin * 2,
                      frame.size.height - h);
} /* innerFrame */


- (void) drawRect :(CGRect)initialRect {
    CGRect rect = [self innerFrame:initialRect];

    [self drawBorder:rect shadow:self.cell.dropsShadow];

    [self drawBackground:rect];

    switch (self.cell.position) {
        case TableViewCellPositionAlone :
        case TableViewCellPositionBottom :
            if (self.cell.tableViewIsGrouped) {
                break;
            }
        default :
            [self drawLineSeparator:CGRectMake(rect.origin.x, rect.origin.y,
                                               rect.size.width, rect.size.height)];
            break;

    } /* switch */
} /* drawRect */


- (void) dealloc {
    self.cell = nil;
} /* dealloc */


- (id) initWithFrame :(CGRect)frame behavior :(CellBackgroundBehavior)bbehavior {
    if (self = [super initWithFrame:frame]) {
        self.contentMode = UIViewContentModeRedraw;
        self.behavior = bbehavior;
        self.backgroundColor = [UIColor clearColor];
    }

    return self;
} /* initWithFrame */


@end






@implementation TableViewCell
@synthesize position, dropsShadow, borderColor, tableViewBackgroundColor;
@synthesize customSeparatorColor, selectionGradientStartColor, selectionGradientEndColor;
@synthesize cornerRadius;
@synthesize customBackgroundColor, gradientStartColor, gradientEndColor;
@synthesize shadowOpacity, customSeparatorStyle;


- (void) dealloc {
    [self.contentView removeObserver:self forKeyPath:@"frame"];
    self.borderColor = nil;
    self.tableViewBackgroundColor = nil;
    self.customSeparatorColor = nil;
    self.selectionGradientStartColor = nil;
    self.selectionGradientEndColor = nil;
    self.customBackgroundColor = nil;
    self.gradientStartColor = nil;
    self.gradientEndColor = nil;
} /* dealloc */


- (void) initializeVars {
    // default values
    self.position = TableViewCellPositionMiddle;
    self.dropsShadow = YES;
    self.borderColor = default_border_color;
    self.tableViewBackgroundColor = [UIColor clearColor];
    self.customSeparatorColor = default_separator_color;
    self.selectionGradientStartColor = default_selection_gradient_start_color;
    self.selectionGradientEndColor = default_selection_gradient_end_color;
    self.cornerRadius = default_radius;
    self.shadowOpacity = default_shadow_opacity;
    self.customSeparatorStyle = UITableViewCellSeparatorStyleSingleLine;
} /* initializeVars */


- (id) initWithStyle :(UITableViewCellStyle)style reuseIdentifier :(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self.contentView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld context:nil];


        TableViewCellBackground *bg = [[TableViewCellBackground alloc] initWithFrame:self.frame
                                                                            behavior:CellBackgroundBehaviorNormal];
        bg.cell = self;
        self.backgroundView = bg;

        bg = [[TableViewCellBackground alloc] initWithFrame:self.frame
                                                   behavior:CellBackgroundBehaviorSelected];
        bg.cell = self;
        self.selectedBackgroundView = bg;

        [self initializeVars];
    }
    return self;
} /* initWithStyle */


+ (TableViewCellPosition) positionForTableView :(UITableView *)tableView indexPath :(NSIndexPath *)indexPath {

    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:indexPath.section] == 1) {
        return TableViewCellPositionAlone;
    }
    if (indexPath.row == 0) {
        return TableViewCellPositionTop;
    }
    if (indexPath.row + 1 == [tableView.dataSource tableView:tableView numberOfRowsInSection:indexPath.section]) {
        return TableViewCellPositionBottom;
    }

    return TableViewCellPositionMiddle;
} /* positionForTableView */


+ (CGFloat) neededHeightForPosition :(TableViewCellPosition)position tableStyle :(UITableViewStyle)style {
    if (style == UITableViewStylePlain) {
        return 0;
    }

    switch (position) {
        case TableViewCellPositionBottom :
        case TableViewCellPositionTop :
            return shadow_margin;

        case TableViewCellPositionAlone :
            return shadow_margin * 2;

        default :
            return 0;
    } /* switch */
} /* neededHeightForPosition */


+ (CGFloat) tableView :(UITableView *)tableView neededHeightForIndexPath :(NSIndexPath *)indexPath {
    TableViewCellPosition position = [TableViewCell positionForTableView:tableView indexPath:indexPath];
    return [TableViewCell neededHeightForPosition:position tableStyle:tableView.style];
} /* tableView */


- (void) prepareForTableView :(UITableView *)tableView indexPath :(NSIndexPath *)indexPath {
    _tableViewStyle = tableView.style;
    self.position = [TableViewCell positionForTableView:tableView indexPath:indexPath];
} /* prepareForTableView */


// Avoids contentView's frame auto-updating. It calculates the best size, taking
// into account the cell's margin and so.
- (void) observeValueForKeyPath :(NSString *)keyPath ofObject :(id)object change :(NSDictionary *)change context :(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        UIView *contentView = (UIView *)object;
        CGRect originalFrame = contentView.frame;

        float shadowMargin = [self shadowMargin];

        float y = contentView_margin;
        switch (self.position) {
            case TableViewCellPositionTop :
            case TableViewCellPositionAlone :
                y += shadowMargin;
                break;
            default :
                break;
        } /* switch */
        float diffY = y - originalFrame.origin.y;

        if (diffY != 0) {
            CGRect rect = CGRectMake(originalFrame.origin.x + shadowMargin,
                                     originalFrame.origin.y + diffY,
                                     originalFrame.size.width - shadowMargin * 2,
                                     originalFrame.size.height - contentView_margin * 2 - [TableViewCell neededHeightForPosition:self.position tableStyle:_tableViewStyle]);
            contentView.frame = rect;
        }
    }
} /* observeValueForKeyPath */


- (void) prepareForReuse {
    [super prepareForReuse];
    [self.backgroundView setNeedsDisplay];
    [self.selectedBackgroundView setNeedsDisplay];
} /* prepareForReuse */


- (void) setTableViewBackgroundColor :(UIColor *)aBackgroundColor {
    [aBackgroundColor copy];
    if (tableViewBackgroundColor != nil) {
    }
    tableViewBackgroundColor = aBackgroundColor;

    self.backgroundView.backgroundColor = aBackgroundColor;
    self.selectedBackgroundView.backgroundColor = aBackgroundColor;
} /* setTableViewBackgroundColor */


- (CGRect) innerFrame {
    float topMargin = 0;
    float bottomMargin = 0;
    float shadowMargin = [self shadowMargin];

    switch (self.position) {
        case TableViewCellPositionTop :
            topMargin = shadowMargin;
        case TableViewCellPositionMiddle :
            // let the separator to be painted, but separator is only painted
            // in grouped table views
            bottomMargin = [self tableViewIsGrouped] ? 1 : 0;
            break;
        case TableViewCellPositionAlone :
            topMargin = shadowMargin;
            bottomMargin = shadowMargin;
            break;
        case TableViewCellPositionBottom :
            bottomMargin = shadowMargin;
            break;
        default :
            break;
    } /* switch */


    CGRect frame = CGRectMake(self.backgroundView.frame.origin.x + shadowMargin,
                              self.backgroundView.frame.origin.y + topMargin,
                              self.backgroundView.frame.size.width - shadowMargin * 2,
                              self.backgroundView.frame.size.height - topMargin - bottomMargin);

    return frame;
} /* innerFrame */


- (CAShapeLayer *) mask {
    UIRectCorner corners = 0;

    switch (self.position) {
        case TableViewCellPositionTop :
            corners = UIRectCornerTopLeft | UIRectCornerTopRight;
            break;
        case TableViewCellPositionAlone :
            corners = UIRectCornerAllCorners;
            break;
        case TableViewCellPositionBottom :
            corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            break;
        default :
            break;
    } /* switch */

    CGRect maskRect = CGRectMake(0, 0,
                                 self.innerFrame.size.width,
                                 self.innerFrame.size.height);

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:maskRect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = maskRect;
    maskLayer.path = maskPath.CGPath;

    return maskLayer;
} /* mask */


- (BOOL) dropsShadow {
    return dropsShadow && [self tableViewIsGrouped];
} /* dropsShadow */


- (float) cornerRadius {
    return [self tableViewIsGrouped] ? cornerRadius : 0;
} /* cornerRadius */


- (UIColor *) backgroundColor {
    return customBackgroundColor ? customBackgroundColor : [super backgroundColor];
} /* backgroundColor */


- (CGGradientRef) createSelectionGradient {
    return [self newSelectionGradient];
} /* createSelectionGradient */


- (CGGradientRef) newSelectionGradient {
    CGFloat locations[] = { 0, 1 };

    NSArray *colors = [NSArray arrayWithObjects:(id)self.selectionGradientStartColor.CGColor, (id)self.selectionGradientEndColor.CGColor, nil];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,
                                                        (CFArrayRef)CFBridgingRetain(colors), locations);
    CGColorSpaceRelease(colorSpace);

    return gradient;
} /* newSelectionGradient */


- (CGGradientRef) createNormalGradient {
    return [self newNormalGradient];
} /* createNormalGradient */


- (CGGradientRef) newNormalGradient {
    CGFloat locations[] = { 0, 1 };

    NSArray *colors = [NSArray arrayWithObjects:(id)self.gradientStartColor.CGColor, (id)self.gradientEndColor.CGColor, nil];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,
                                                        (CFArrayRef)CFBridgingRetain(colors), locations);
    CGColorSpaceRelease(colorSpace);

    return gradient;
} /* newNormalGradient */


#pragma mark - Deprecated stuff

- (BOOL) showsCustomSeparator {
    return self.customSeparatorStyle != UITableViewCellSeparatorStyleNone;
} /* showsCustomSeparator */


- (void) setShowsCustomSeparator :(BOOL)showsCustomSeparator {
    switch (showsCustomSeparator) {
        case YES :
            self.customSeparatorStyle = UITableViewCellSeparatorStyleSingleLine;
            break;
        case NO :
            self.customSeparatorStyle = UITableViewCellSeparatorStyleNone;
            break;
    } /* switch */


} /* setShowsCustomSeparator */


@end
