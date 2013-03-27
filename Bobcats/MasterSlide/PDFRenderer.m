//
//  PDFRenderer.m
//  Bobcats
//
//

#import "PDFRenderer.h"
#import "TeacherSettings.h"

#define kColumnsKey        3211
#define kColumnsContentKey 3212

@implementation PDFRenderer

+ (void) drawLineFromPoint :(CGPoint)from toPoint :(CGPoint)to {
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetLineWidth(context, 2.0);

    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();

    CGFloat components[] = { 0.2, 0.2, 0.2, 0.3 };

    CGColorRef color = CGColorCreate(colorspace, components);

    CGContextSetStrokeColorWithColor(context, color);

    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);

    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);

} /* drawLineFromPoint */


+ (void) drawTitleText :(CGRect)frame title :(NSString *)title {
    CFStringRef titleStringRef = (__bridge CFStringRef)title;

    // Prepare font
    CTFontRef font = CTFontCreateWithName(CFSTR("TimesNewRomanPSMT"), 28, NULL);

    CTTextAlignment alignment = kCTCenterTextAlignment;

    CTParagraphStyleSetting settings[] = {
        { kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment }
    };

    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));


    // Create an attributed string
    CFStringRef keys[] = { kCTFontAttributeName, kCTParagraphStyleAttributeName };
    CFTypeRef values[] = { font, paragraphStyle };
    CFDictionaryRef attr = CFDictionaryCreate(NULL, (const void **)&keys, (const void **)&values,
                                              sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);

    // Prepare the text using a Core Text Framesetter
    CFAttributedStringRef titleCurrentText = CFAttributedStringCreate(NULL, titleStringRef, attr);
    CTFramesetterRef titleFramesetter = CTFramesetterCreateWithAttributedString(titleCurrentText);
    ////
    CGRect frameRect = CGRectMake(0, 40, frame.size.width, 40);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);

    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);

    CTFrameRef titleFrameRef = CTFramesetterCreateFrame(titleFramesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);

    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();

    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);

    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, 100);
    CGContextScaleCTM(currentContext, 1.0, -1.0);

    // Draw the frame.
    CTFrameDraw(titleFrameRef, currentContext);

    [self drawLineFromPoint:CGPointMake(30, 42) toPoint:CGPointMake(frame.size.width - 38, 42)];
} /* drawTitleText */


+ (void) drawStudentInformation :(CGRect)frame student :(Student *)student {
    NSString *studentName = [NSString stringWithFormat:@"Student Name: %@", [student fullName]];

    NSDateFormatter *inFormat = [[NSDateFormatter alloc] init];
    [inFormat setDateFormat:@"MM/dd/yyyy"];

    NSString *currentDate = [NSString stringWithFormat:@"Date: %@", [inFormat stringFromDate:[NSDate date]]];

    CFStringRef nameStringRef = (__bridge CFStringRef)studentName;
    CFStringRef currentDateStringRef = (__bridge CFStringRef)currentDate;

    // Prepare font
    CTFontRef font = CTFontCreateWithName(CFSTR("TimesNewRomanPS-BoldMT"), 17, NULL);

    CTTextAlignment leftAlignment = kCTLeftTextAlignment;
    CTTextAlignment rightAlignment = kCTRightTextAlignment;

    CTParagraphStyleSetting settingsLeftAlignment[] = { { kCTParagraphStyleSpecifierAlignment, sizeof(leftAlignment), &leftAlignment } };
    CTParagraphStyleSetting settingsRightAlignment[] = { { kCTParagraphStyleSpecifierAlignment, sizeof(rightAlignment), &rightAlignment } };

    CTParagraphStyleRef paragraphStyleForLeftAlignment = CTParagraphStyleCreate(settingsLeftAlignment, sizeof(settingsLeftAlignment) / sizeof(settingsLeftAlignment[0]));
    CTParagraphStyleRef paragraphStyleForRightAlignment = CTParagraphStyleCreate(settingsRightAlignment, sizeof(settingsRightAlignment) / sizeof(settingsRightAlignment[0]));

    // Create an attributed string for Left
    CFStringRef keysLeft[] = { kCTFontAttributeName, kCTParagraphStyleAttributeName };
    CFTypeRef valuesLeft[] = { font, paragraphStyleForLeftAlignment };
    CFDictionaryRef attrForLeftAlignment = CFDictionaryCreate(NULL, (const void **)&keysLeft, (const void **)&valuesLeft,
                                                              sizeof(keysLeft) / sizeof(keysLeft[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);

    // Create an attributed string for Right
    CFStringRef keysRight[] = { kCTFontAttributeName, kCTParagraphStyleAttributeName };
    CFTypeRef valuesRight[] = { font, paragraphStyleForRightAlignment };
    CFDictionaryRef attrForRightAlignment = CFDictionaryCreate(NULL, (const void **)&keysRight, (const void **)&valuesRight,
                                                               sizeof(keysRight) / sizeof(keysRight[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);


    // Prepare the text using a Core Text Framesetter
    CFAttributedStringRef currentDateCurrentText = CFAttributedStringCreate(NULL, currentDateStringRef, attrForRightAlignment);
    CTFramesetterRef currentDateFramesetter = CTFramesetterCreateWithAttributedString(currentDateCurrentText);

    // Prepare the text using a Core Text Framesetter
    CFAttributedStringRef nameCurrentText = CFAttributedStringCreate(NULL, nameStringRef, attrForLeftAlignment);
    CTFramesetterRef nameFramesetter = CTFramesetterCreateWithAttributedString(nameCurrentText);

    CGRect frameRect = CGRectMake(40, 14, frame.size.width - 80, 20);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);

    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);

    CTFrameRef nameFrameRef = CTFramesetterCreateFrame(nameFramesetter, currentRange, framePath, NULL);
    CTFrameRef currentDateFrameRef = CTFramesetterCreateFrame(currentDateFramesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);

    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();

    // Draw the frame.
    CTFrameDraw(nameFrameRef, currentContext);
    CTFrameDraw(currentDateFrameRef, currentContext);

    CFRelease(nameFrameRef);
    CFRelease(nameStringRef);
    CFRelease(nameFramesetter);
} /* drawStudentInformation */


+ (void) drawTableHeaders :(CGRect)frame {
    NSString *studentName = @"Fields";
    NSString *studentDOB = @"Comments";

    CFStringRef nameStringRef = (__bridge CFStringRef)studentName;
    CFStringRef dobStringRef = (__bridge CFStringRef)studentDOB;

    // Prepare font
    CTFontRef font = CTFontCreateWithName(CFSTR("TimesNewRomanPS-BoldItalicMT"), 14, NULL);

    CTTextAlignment leftAlignment = kCTLeftTextAlignment;
    CTTextAlignment rightAlignment = kCTRightTextAlignment;

    CTParagraphStyleSetting settingsLeftAlignment[] = { { kCTParagraphStyleSpecifierAlignment, sizeof(leftAlignment), &leftAlignment } };
    CTParagraphStyleSetting settingsRightAlignment[] = { { kCTParagraphStyleSpecifierAlignment, sizeof(rightAlignment), &rightAlignment } };

    CTParagraphStyleRef paragraphStyleForLeftAlignment = CTParagraphStyleCreate(settingsLeftAlignment, sizeof(settingsLeftAlignment) / sizeof(settingsLeftAlignment[0]));
    CTParagraphStyleRef paragraphStyleForRightAlignment = CTParagraphStyleCreate(settingsRightAlignment, sizeof(settingsRightAlignment) / sizeof(settingsRightAlignment[0]));

    // Create an attributed string
    CFStringRef keysLeft[] = { kCTFontAttributeName, kCTParagraphStyleAttributeName };
    CFTypeRef valuesLeft[] = { font, paragraphStyleForLeftAlignment };
    CFDictionaryRef attrForLeftAlignment = CFDictionaryCreate(NULL, (const void **)&keysLeft, (const void **)&valuesLeft,
                                                              sizeof(keysLeft) / sizeof(keysLeft[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);

    // Create an attributed string
    CFStringRef keysRight[] = { kCTFontAttributeName, kCTParagraphStyleAttributeName };
    CFTypeRef valuesRight[] = { font, paragraphStyleForRightAlignment };
    CFDictionaryRef attrForRightAlignment = CFDictionaryCreate(NULL, (const void **)&keysRight, (const void **)&valuesRight,
                                                               sizeof(keysRight) / sizeof(keysRight[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);


    // Prepare the text using a Core Text Framesetter
    CFAttributedStringRef nameCurrentText = CFAttributedStringCreate(NULL, nameStringRef, attrForLeftAlignment);
    CTFramesetterRef nameFramesetter = CTFramesetterCreateWithAttributedString(nameCurrentText);

    // Prepare the text using a Core Text Framesetter
    CFAttributedStringRef dobCurrentText = CFAttributedStringCreate(NULL, dobStringRef, attrForRightAlignment);
    CTFramesetterRef dobFramesetter = CTFramesetterCreateWithAttributedString(dobCurrentText);

    CGRect frameRect = CGRectMake(140, -65, frame.size.width * .6, 50);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);

    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);

    CTFrameRef nameFrameRef = CTFramesetterCreateFrame(nameFramesetter, currentRange, framePath, NULL);
    CTFrameRef dobFrameRef = CTFramesetterCreateFrame(dobFramesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);

    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();

    // Draw the frame.
    CTFrameDraw(nameFrameRef, currentContext);
    CTFrameDraw(dobFrameRef, currentContext);

    CFRelease(nameFrameRef);
    CFRelease(nameStringRef);
    CFRelease(nameFramesetter);
} /* drawTableHeaders */

+ (void) drawTableHeadersForAssessments :(CGRect)frame {
    
    NSString *studentName = @"Type     Name                                                   Score                                                            Date";
    
    CFStringRef nameStringRef = (__bridge CFStringRef)studentName;
    
    // Prepare font
    CTFontRef font = CTFontCreateWithName(CFSTR("TimesNewRomanPS-BoldItalicMT"), 18, NULL);
    
    CTTextAlignment leftAlignment = kCTLeftTextAlignment;
    
    CTParagraphStyleSetting settingsLeftAlignment[] = { { kCTParagraphStyleSpecifierAlignment, sizeof(leftAlignment), &leftAlignment } };
    
    CTParagraphStyleRef paragraphStyleForLeftAlignment = CTParagraphStyleCreate(settingsLeftAlignment, sizeof(settingsLeftAlignment) / sizeof(settingsLeftAlignment[0]));
    
    // Create an attributed string
    CFStringRef keysLeft[] = { kCTFontAttributeName, kCTParagraphStyleAttributeName };
    CFTypeRef valuesLeft[] = { font, paragraphStyleForLeftAlignment };
    CFDictionaryRef attrForLeftAlignment = CFDictionaryCreate(NULL, (const void **)&keysLeft, (const void **)&valuesLeft,
                                                              sizeof(keysLeft) / sizeof(keysLeft[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        
    // Prepare the text using a Core Text Framesetter
    CFAttributedStringRef nameCurrentText = CFAttributedStringCreate(NULL, nameStringRef, attrForLeftAlignment);
    CTFramesetterRef nameFramesetter = CTFramesetterCreateWithAttributedString(nameCurrentText);
    
    CGRect frameRect = CGRectMake(47, -40, 700, 30);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    
    CTFrameRef nameFrameRef = CTFramesetterCreateFrame(nameFramesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Draw the frame.
    CTFrameDraw(nameFrameRef, currentContext);
    
    CFRelease(nameFrameRef);
    CFRelease(nameStringRef);
    CFRelease(nameFramesetter);
} /* drawTableHeaders */

+ (void) drawColumns :(CGRect)frame array :(NSMutableArray *)array floatValues :(NSMutableArray *)floats {
    CTFontRef font = CTFontCreateWithName(CFSTR("TimesNewRomanPSMT"), 12, NULL);

    int counter = 0;
    NSMutableString *parsedString = [NSMutableString stringWithCapacity:30];
    for (NSArray *s in array) {
        for (NSString *d in s) {
            NSString *tempString = [self newstring:frame string:d floatValues:floats position:counter arrayNumber:kColumnsKey];
            [parsedString appendFormat:@"%@\n", tempString];
            counter++;
        }
    }

    CTParagraphStyleSetting settings[] = {};

    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));


    // Create an attributed string
    CFStringRef keys[] = { kCTFontAttributeName, kCTParagraphStyleAttributeName };
    CFTypeRef values[] = { font, paragraphStyle };
    CFDictionaryRef attr = CFDictionaryCreate(NULL, (const void **)&keys, (const void **)&values,
                                              sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);

    NSString *textToDraw = [NSString stringWithFormat:@"%@", parsedString];
    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;

    // Prepare the text using a Core Text Framesetter
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, attr);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);

    CGRect frameRect = CGRectMake(30, -690, 375, 650);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);

    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);

    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();

    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);

    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(framesetter);
} /* drawColumns */


+ (void) drawColumnContent :(CGRect)frame array :(NSMutableArray *)array floatValues :(NSMutableArray *)floats {
    CTFontRef font = CTFontCreateWithName(CFSTR("TimesNewRomanPSMT"), 12, NULL);

    int counter = 0;
    NSMutableString *parsedString = [NSMutableString stringWithCapacity:30];
    for (NSArray *s in array) {
        for (NSString *d in s) {
            NSString *comment = [d substringFromIndex:3];

            if ((comment == nil) || [comment isEqualToString:@"nil"])
                comment = @"no comment";

            comment = [self newstring:frame string:comment floatValues:floats position:counter arrayNumber:kColumnsContentKey];

            [parsedString appendFormat:@"%@\n", comment];

            counter++;
        }
    }

    CTTextAlignment alignment = kCTCenterTextAlignment;

    CTParagraphStyleSetting settings[] = {
        { kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment }
    };

    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));

    // Create an attributed string
    CFStringRef keys[] = { kCTFontAttributeName, kCTParagraphStyleAttributeName };
    CFTypeRef values[] = { font, paragraphStyle };
    CFDictionaryRef attr = CFDictionaryCreate(NULL, (const void **)&keys, (const void **)&values,
                                              sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);


    NSString *textToDraw = [NSString stringWithFormat:@"%@", parsedString];
    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;

    // Prepare the text using a Core Text Framesetter
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, attr);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);

    CGRect frameRect = CGRectMake(frame.size.width / 2, -690, 375, 650);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);

    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);

    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();

    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);

    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(framesetter);
} /* drawColumnContent */


+ (void) drawEntireLineWithContent :(CGRect)frame columns :(NSMutableArray *)columnArray content :(NSMutableArray *)contentArray {
    CTFontRef font = CTFontCreateWithName(CFSTR("TimesNewRomanPSMT"), 19, NULL);

    NSArray *contentSeparated;

    NSMutableArray *assessments = [NSMutableArray new];
    NSMutableArray *scores = [NSMutableArray new];
    NSMutableArray *dates = [NSMutableArray new];

    NSMutableString *parsedAssessmentsString = [NSMutableString stringWithCapacity:30];
    NSMutableString *parsedScoresString = [NSMutableString stringWithCapacity:30];
    NSMutableString *parsedDatesString = [NSMutableString stringWithCapacity:30];

    int counter = 0;
    for (NSArray *s in contentArray) {
        for (NSString *d in s) {
            contentSeparated = [[NSMutableArray alloc] initWithArray:[d componentsSeparatedByString:@"/"] copyItems:YES];
            
            [assessments addObject:[contentSeparated objectAtIndex:0]];
            [scores addObject:[contentSeparated objectAtIndex:1]];
            [dates addObject:[contentSeparated objectAtIndex:2]];
            
            NSString *assessmentType = [columnArray objectAtIndex:counter];
            
            if ([assessmentType isEqualToString:@"Formative"]) {
                assessmentType = @"(F)";
            }
            else if ([assessmentType isEqualToString:@"Standardized"]) {
                assessmentType = @"(S)";
            }
            
            
            [parsedAssessmentsString appendFormat:@"%@ %@\n\n", assessmentType, [assessments lastObject]];
            [parsedScoresString appendFormat:@"%@%@\n\n", [scores lastObject], @"%"];
            [parsedDatesString appendFormat:@"%@\n\n", [dates lastObject]];

        }
        counter++;
    }

    CFStringRef assessmentStringRef = (__bridge CFStringRef)parsedAssessmentsString;
    CFStringRef scoresStringRef = (__bridge CFStringRef)parsedScoresString;
    CFStringRef dateStringRef = (__bridge CFStringRef)parsedDatesString;

    CTTextAlignment leftAlignment = kCTLeftTextAlignment;
    CTTextAlignment centerAlignment = kCTCenterTextAlignment;
    CTTextAlignment rightAlignment = kCTRightTextAlignment;
    
    CTParagraphStyleSetting settingsLeftAlignment[] = { { kCTParagraphStyleSpecifierAlignment, sizeof(leftAlignment), &leftAlignment } };
    CTParagraphStyleSetting settingsCenterAlignment[] = { { kCTParagraphStyleSpecifierAlignment, sizeof(centerAlignment), &centerAlignment } };
    CTParagraphStyleSetting settingsRightAlignment[] = { { kCTParagraphStyleSpecifierAlignment, sizeof(rightAlignment), &rightAlignment } };

    CTParagraphStyleRef paragraphStyleForLeftAlignment = CTParagraphStyleCreate(settingsLeftAlignment, sizeof(settingsLeftAlignment) / sizeof(settingsLeftAlignment[0]));
    CTParagraphStyleRef paragraphStyleForCenterAlignment = CTParagraphStyleCreate(settingsCenterAlignment, sizeof(settingsCenterAlignment) / sizeof(settingsCenterAlignment[0]));
    CTParagraphStyleRef paragraphStyleForRightAlignment = CTParagraphStyleCreate(settingsRightAlignment, sizeof(settingsRightAlignment) / sizeof(settingsRightAlignment[0]));
    
    // Create an attributed string for Left
    CFStringRef keysLeft[] = { kCTFontAttributeName, kCTParagraphStyleAttributeName };
    CFTypeRef valuesLeft[] = { font, paragraphStyleForLeftAlignment };
    CFDictionaryRef attrForLeftAlignment = CFDictionaryCreate(NULL, (const void **)&keysLeft, (const void **)&valuesLeft,
                                                              sizeof(keysLeft) / sizeof(keysLeft[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    // Create an attributed string for Right
    CFStringRef keysCenter[] = { kCTFontAttributeName, kCTParagraphStyleAttributeName };
    CFTypeRef valuesCenter[] = { font, paragraphStyleForCenterAlignment };
    CFDictionaryRef attrForCenterAlignment = CFDictionaryCreate(NULL, (const void **)&keysCenter, (const void **)&valuesCenter,
                                                               sizeof(keysCenter) / sizeof(keysCenter[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    // Create an attributed string for Right
    CFStringRef keysRight[] = { kCTFontAttributeName, kCTParagraphStyleAttributeName };
    CFTypeRef valuesRight[] = { font, paragraphStyleForRightAlignment };
    CFDictionaryRef attrForRightAlignment = CFDictionaryCreate(NULL, (const void **)&keysRight, (const void **)&valuesRight,
                                                               sizeof(keysRight) / sizeof(keysRight[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);

    
    // Prepare the text using a Core Text Framesetter LEFT
    CFAttributedStringRef assessmentCurrentText = CFAttributedStringCreate(NULL, assessmentStringRef, attrForLeftAlignment);
    CTFramesetterRef assessmentFramesetter = CTFramesetterCreateWithAttributedString(assessmentCurrentText);
    
    // Prepare the text using a Core Text Framesetter LEFT
    CFAttributedStringRef scoreCurrentText = CFAttributedStringCreate(NULL, scoresStringRef, attrForCenterAlignment);
    CTFramesetterRef scoreFramesetter = CTFramesetterCreateWithAttributedString(scoreCurrentText);

    // Prepare the text using a Core Text Framesetter RIGHT
    CFAttributedStringRef dateCurrentText = CFAttributedStringCreate(NULL, dateStringRef, attrForRightAlignment);
    CTFramesetterRef dateFramesetter = CTFramesetterCreateWithAttributedString(dateCurrentText);
    
    CGRect frameRect = CGRectMake(50, -690, 700, 650);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    
    CTFrameRef assessmentFrameRef = CTFramesetterCreateFrame(assessmentFramesetter, currentRange, framePath, NULL);
    CTFrameRef scoreFrameRef = CTFramesetterCreateFrame(scoreFramesetter, currentRange, framePath, NULL);
    CTFrameRef dateFrameRef = CTFramesetterCreateFrame(dateFramesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Draw the frame.
    CTFrameDraw(assessmentFrameRef, currentContext);
    CTFrameDraw(scoreFrameRef, currentContext);
    CTFrameDraw(dateFrameRef, currentContext);

    CFRelease(assessmentFrameRef);
    CFRelease(scoreFrameRef);
    CFRelease(dateFrameRef);
} /* drawColumnContent */


+ (void) drawPDFLedgend :(CGRect)frame columnArray :(NSMutableArray *)columns contentArray :(NSMutableArray *)content withString:(NSString *)str {

//    float height = [self calculateFinalHeight:frame columnArray:columns contentArray:content];
    NSString *studentName = str;

    CFStringRef nameStringRef = (__bridge CFStringRef)studentName;

    // Prepare font
    CTFontRef font = CTFontCreateWithName(CFSTR("TimesNewRomanPS-BoldItalicMT"), 14, NULL);

    CTTextAlignment centerAlignment = kCTCenterTextAlignment;

    CTParagraphStyleSetting settingsLeftAlignment[] = { { kCTParagraphStyleSpecifierAlignment, sizeof(centerAlignment), &centerAlignment } };

    CTParagraphStyleRef paragraphStyleForLeftAlignment = CTParagraphStyleCreate(settingsLeftAlignment, sizeof(centerAlignment) / sizeof(settingsLeftAlignment[0]));

    // Create an attributed string
    CFStringRef keysLeft[] = { kCTFontAttributeName, kCTParagraphStyleAttributeName };
    CFTypeRef valuesLeft[] = { font, paragraphStyleForLeftAlignment };
    CFDictionaryRef attrForLeftAlignment = CFDictionaryCreate(NULL, (const void **)&keysLeft, (const void **)&valuesLeft,
                                                              sizeof(keysLeft) / sizeof(keysLeft[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);

    // Prepare the text using a Core Text Framesetter
    CFAttributedStringRef nameCurrentText = CFAttributedStringCreate(NULL, nameStringRef, attrForLeftAlignment);
    CTFramesetterRef nameFramesetter = CTFramesetterCreateWithAttributedString(nameCurrentText);

    CGRect frameRect = CGRectMake(50, -1000, frame.size.width, 100);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);

    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);

    CTFrameRef nameFrameRef = CTFramesetterCreateFrame(nameFramesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);

    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();

    // Draw the frame.
    CTFrameDraw(nameFrameRef, currentContext);

    CFRelease(nameFrameRef);
    CFRelease(nameStringRef);
    CFRelease(nameFramesetter);
} /* drawTableHeaders */


+ (NSArray *) calculateLineValues :(CGRect)frame columnArray :(NSMutableArray *)columns contentArray :(NSMutableArray *)content {
    // Prepare font
    CTFontRef font = CTFontCreateWithName(CFSTR("TimesNewRomanPSMT"), 12, NULL);
    
    NSMutableArray *columnWidths = [[NSMutableArray alloc] init];
    NSMutableArray *contentWidths = [[NSMutableArray alloc] init];
    
    for (NSArray *arr in columns) {
        for (NSString *d in arr) {
            [columnWidths addObject:[NSNumber numberWithFloat:[self sizeofLineWidth:frame string:d font:font]]];
        }
    }
    
    CGRect frameRect = CGRectMake(frame.size.width / 2 + 10, -650, 375, 650);
    for (NSArray *arr in content) {
        for (NSString *ds in arr) {
            [contentWidths addObject:[NSNumber numberWithFloat:[self sizeofLineWidth:frameRect string:ds font:font]]];
        }
    }
    
    return [[NSArray alloc] initWithObjects:columnWidths, contentWidths, nil];
} /* calculateLineValues */


+ (float) calculateFinalHeight :(CGRect)frame columnArray :(NSMutableArray *)columns contentArray :(NSMutableArray *)content {
    // Prepare font
    CTFontRef font = CTFontCreateWithName(CFSTR("TimesNewRomanPSMT"), 12, NULL);

    float finalColumnHeight = 0.0f;
    float finalContentHeight = 0.0f;

    for (NSArray *arr in columns) {
        for (NSString *d in arr) {
            finalColumnHeight += [self sizeofLineHeight:frame string:d font:font];
        }
    }

    CGRect frameRect = CGRectMake(frame.size.width / 2 + 10, -650, 375, 650);
    for (NSArray *arr in content) {
        for (NSString *ds in arr) {
            finalContentHeight += [self sizeofLineHeight:frameRect string:ds font:font];
        }
    }

    return (finalColumnHeight > finalContentHeight) ? finalColumnHeight : finalContentHeight;
} /* calculateLineValues */


+ (void) drawPDF :(NSString *)fileName frame :(CGRect)frame columnArray :(NSMutableArray *)columns contentArray :(NSMutableArray *)content titleString :(NSString *)title student :(Student *)student testType :(int)type {
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(frame, nil);

    [self drawTitleText:frame title:title];
    [self drawStudentInformation:frame student:student];

    if (type == 1) {
        // Format columns array
        NSMutableArray *tempColumns = [[NSMutableArray alloc] initWithArray:[self concatenateArray:columns withSecondArray:content toIndex:1]];

        [self drawTableHeaders:frame];
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[self calculateLineValues:frame columnArray:tempColumns contentArray:content]];
        [self drawColumns:frame array:tempColumns floatValues:array];
        [self drawColumnContent:frame array:content floatValues:array];
        [self drawPDFLedgend:frame columnArray:columns contentArray:content withString:@"B = Beginning, D = Developing, S = Secure"];
    } else {
        [self drawEntireLineWithContent:frame columns:columns content:content];
        [self drawTableHeadersForAssessments:frame];
        [self drawPDFLedgend:frame columnArray:columns contentArray:content withString:@"S = Standardized Assessment, F = Formative Assessment"];
    }

    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
} /* drawPDF */


+ (NSArray *) concatenateArray :(NSMutableArray *)first withSecondArray :(NSMutableArray *)second toIndex :(int)startingindex {

    NSMutableArray *concatenated = [NSMutableArray new];
    NSMutableArray *looping = [NSMutableArray new];

    for (int x = 0; x < first.count; x++) {

        looping = [[NSMutableArray alloc] init];

        for (int y = 0; y < [[first objectAtIndex:x] count]; y++) {

            NSString *firstString = (NSString *)[[first objectAtIndex:x] objectAtIndex:y];
            NSString *secondString = (NSString *)[[[second objectAtIndex:x] objectAtIndex:y] substringToIndex:startingindex];

            if ([[secondString lowercaseString] isEqualToString:@"z"])
                secondString = @"B";

            NSString *formatted = [NSString stringWithFormat:@"(%@) %@", [secondString uppercaseString], firstString];

            [looping addObject:formatted];
        }

        [concatenated addObject:looping];

    }

    return concatenated;
} /* concatenateArray */


+ (NSString *) newstring :(CGRect)frame string :(NSString *)inputString floatValues :(NSMutableArray *)floats position :(int)pos arrayNumber :(int)arrayNum {
    int num = 0;

    CGFloat columnFloat = [[[floats objectAtIndex:0] objectAtIndex:pos] floatValue];
    CGFloat contentFloat = [[[floats objectAtIndex:1] objectAtIndex:pos] floatValue];

    switch (arrayNum) {
        case kColumnsKey :
            if (columnFloat < contentFloat) {
                num = contentFloat;
            }
            break;
        case kColumnsContentKey :
            if (columnFloat > contentFloat) {
                num = columnFloat;
            }
            break;
        default :
            break;
    } /* switch */

    int begin = 0;
    int end = num / 375 + 1;
    while (begin < end) {
        inputString = [NSString stringWithFormat:@"%@\n", inputString];
        begin++;
    }

    return inputString;
} /* newstring */


+ (CGFloat) sizeofLineWidth :(CGRect)frame string :(NSString *)input font :(CTFontRef)font {
    return [input sizeWithFont:[UIFont fontWithName:@"TimesNewRomanPSMT" size:12]].width;
} /* sizeofLineWidth */


+ (CGFloat) sizeofLineHeight :(CGRect)frame string :(NSString *)input font :(CTFontRef)font {
    return [input sizeWithFont:[UIFont fontWithName:@"TimesNewRomanPSMT" size:12]].height;
} /* sizeofLineWidth */


// Incase teacher wants name on pdf
// + (NSString *) nameOfTeacher {
//    NSMutableDictionary *settingsDictionary = [[NSMutableDictionary alloc]
//                                               initWithContentsOfFile:[self pathToFollowingResource:kTeacherSettingsPlist]];
//    return [settingsDictionary objectForKey:kTeacherName];
// }
//
// + (NSString *) pathToFollowingResource:(NSString *)resource {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                         NSUserDomainMask, YES);
//    NSString *plistFile = [[paths objectAtIndex:0]
//                           stringByAppendingPathComponent:resource];
//
//    return plistFile;
// } /* plistPath */

@end
