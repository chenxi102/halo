//
//  CameraTimerLabel.h
// Copyright (c) 2014 MineS Chan

#import "CameraTimerLabel.h"


#define kDefaultTimeFormat  @"HH:mm:ss"
#define kHourFormatReplace  @"!!!*"
#define kDefaultFireIntervalNormal  0.1
#define kDefaultFireIntervalHighUse  0.01
#define kDefaultTimerType CameraTimerLabelTypeStopWatch

@interface CameraTimerLabel(){
    
    NSTimeInterval timeUserValue;
    NSDate *pausedTime;
    NSDate *date1970;
    NSDate *timeToCountOff;
}

@property (strong, nonatomic) NSDate *startCountDate;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;

- (void)setup;
- (void)updateLabel;

@end

#pragma mark - Initialize method

@implementation CameraTimerLabel

@synthesize timeFormat = _timeFormat;

- (id)initWithTimerType:(CameraTimerLabelType)theType {
    return [self initWithFrame:CGRectZero label:nil andTimerType:theType];
}

- (id)initWithLabel:(UILabel *)theLabel andTimerType:(CameraTimerLabelType)theType {
    return [self initWithFrame:CGRectZero label:theLabel andTimerType:theType];
}

- (id)initWithLabel:(UILabel*)theLabel {
    return [self initWithFrame:CGRectZero label:theLabel andTimerType:kDefaultTimerType];
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame label:nil andTimerType:kDefaultTimerType];
}

-(id)initWithFrame:(CGRect)frame label:(UILabel*)theLabel andTimerType:(CameraTimerLabelType)theType {
    self = [super initWithFrame:frame];
    if (self) {
        self.timeLabel = theLabel;
        self.timerType = theType;
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
        [self setup];
	}
	return self;
}

#pragma mark - Cleanup

- (void) removeFromSuperview {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    [super removeFromSuperview];
}

#pragma mark - Getter and Setter Method

- (int)dateCount {

    return [[NSDate date] timeIntervalSinceDate:self.startCountDate];
}

- (void)setStopWatchTime:(NSTimeInterval)time{
    
    timeUserValue = (time < 0) ? 0 : time;
    if(timeUserValue > 0){
        self.startCountDate = [[NSDate date] dateByAddingTimeInterval:-timeUserValue];
        pausedTime = [NSDate date];
        [self updateLabel];
    }
}

- (void)setCountDownTime:(NSTimeInterval)time{
    
    timeUserValue = (time < 0)? 0 : time;
    timeToCountOff = [date1970 dateByAddingTimeInterval:timeUserValue];
    [self updateLabel];
}

-(void)setCountDownToDate:(NSDate*)date{
    NSTimeInterval timeLeft = (int)[date timeIntervalSinceDate:[NSDate date]];
    
    if (timeLeft > 0) {
        timeUserValue = timeLeft;
        timeToCountOff = [date1970 dateByAddingTimeInterval:timeLeft];
    }else{
        timeUserValue = 0;
        timeToCountOff = [date1970 dateByAddingTimeInterval:0];
    }
    [self updateLabel];

}

- (void)setTimeFormat:(NSString *)timeFormat{
    
    if ([timeFormat length] != 0) {
        _timeFormat = timeFormat;
        self.dateFormatter.dateFormat = timeFormat;
    }
    [self updateLabel];
}

- (NSString*)timeFormat
{
    if ([_timeFormat length] == 0 || _timeFormat == nil) {
        _timeFormat = kDefaultTimeFormat;
    }
    
    return _timeFormat;
}

- (NSDateFormatter*)dateFormatter{
    
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
        [_dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        _dateFormatter.dateFormat = self.timeFormat;
    }
    return _dateFormatter;
}

- (UILabel*)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = self;
    }
    return _timeLabel;
}


-(void)addTimeCountedByTime:(NSTimeInterval)timeToAdd
{
    if (_timerType == CameraTimerLabelTypeTimer) {
        [self setCountDownTime:timeToAdd + timeUserValue];
    }else if (_timerType == CameraTimerLabelTypeStopWatch) {
        NSDate *newStartDate = [_startCountDate dateByAddingTimeInterval:-timeToAdd];
        if([[NSDate date] timeIntervalSinceDate:newStartDate] <= 0) {
            //prevent less than 0
            _startCountDate = [NSDate date];
        }else{
            _startCountDate = newStartDate;
        }
    }
    [self updateLabel];
}


- (NSTimeInterval)getTimeCounted
{
    if(!self.startCountDate) return 0;
    NSTimeInterval countedTime = [[NSDate date] timeIntervalSinceDate:self.startCountDate];
    
    if(pausedTime != nil){
        NSTimeInterval pauseCountedTime = [[NSDate date] timeIntervalSinceDate:pausedTime];
        countedTime -= pauseCountedTime;
    }
    return countedTime;
}

- (NSTimeInterval)getTimeRemaining {
    
    if (_timerType == CameraTimerLabelTypeTimer) {
        return timeUserValue - [self getTimeCounted];
    }
    
    return 0;
}

- (NSTimeInterval)getCountDownTime {
    
    if (_timerType == CameraTimerLabelTypeTimer) {
        return timeUserValue;
    }
    
    return 0;
}

- (void)setShouldCountBeyondHHLimit:(BOOL)shouldCountBeyondHHLimit {
    _shouldCountBeyondHHLimit = shouldCountBeyondHHLimit;
    [self updateLabel];
}

#pragma mark - Timer Control Method


-(void)start{
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    if ([self.timeFormat rangeOfString:@"SS"].location != NSNotFound) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:kDefaultFireIntervalHighUse target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
    }else{
        _timer = [NSTimer scheduledTimerWithTimeInterval:kDefaultFireIntervalNormal target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
    }
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    if(_startCountDate == nil){
        _startCountDate = [NSDate date];
        
        if (self.timerType == CameraTimerLabelTypeStopWatch && timeUserValue > 0) {
            self.startCountDate = [self.startCountDate dateByAddingTimeInterval:-timeUserValue];
        }
    }
    if(pausedTime != nil){
        NSTimeInterval countedTime = [pausedTime timeIntervalSinceDate:_startCountDate];
        _startCountDate = [[NSDate date] dateByAddingTimeInterval:-countedTime];
        pausedTime = nil;
    }
    
    _counting = YES;
    [_timer fire];
}

#if NS_BLOCKS_AVAILABLE
-(void)startWithEndingBlock:(void(^)(NSTimeInterval))end{
    self.endedBlock = end;
    [self start];
}
#endif
    
-(void)pause{
	if(_counting){
	    [_timer invalidate];
	    _timer = nil;
	    _counting = NO;
	    pausedTime = [NSDate date];		
	}
}

-(void)reset{
    pausedTime = nil;
    timeUserValue = (self.timerType == CameraTimerLabelTypeStopWatch)? 0 : timeUserValue;
    self.startCountDate = (self.counting)? [NSDate date] : nil;
    [self updateLabel];
}


#pragma mark - Private method

-(void)setup {
    date1970 = [NSDate dateWithTimeIntervalSince1970:0];
    [self updateLabel];
}


-(void)updateLabel{

    NSTimeInterval timeDiff = [[NSDate date] timeIntervalSinceDate:self.startCountDate];
    NSDate *timeToShow = [NSDate date];
    BOOL timerEnded = false;
    
    /***MZTimerLabelTypeStopWatch Logic***/
    
    if(_timerType == CameraTimerLabelTypeStopWatch){
        
        if (_counting) {
            timeToShow = [date1970 dateByAddingTimeInterval:timeDiff];
        }else{
            timeToShow = [date1970 dateByAddingTimeInterval:(!self.startCountDate)?0:timeDiff];
        }
        
        if([_delegate respondsToSelector:@selector(timerLabel:countingTo:timertype:)]){
            [_delegate timerLabel:self countingTo:timeDiff timertype:_timerType];
        }
    
    }else{
        
    /***CameraTimerLabelTypeTimer Logic***/
        
        if (_counting) {
            
            if([_delegate respondsToSelector:@selector(timerLabel:countingTo:timertype:)]){
                NSTimeInterval timeLeft = timeUserValue - timeDiff;
                [_delegate timerLabel:self countingTo:timeLeft timertype:_timerType];
            }
                        
            if(timeDiff >= timeUserValue){
                [self pause];
                timeToShow = [date1970 dateByAddingTimeInterval:0];
                self.startCountDate = nil;
                timerEnded = true;
            }else{
                timeToShow = [timeToCountOff dateByAddingTimeInterval:(timeDiff*-1)]; //added 0.999 to make it actually counting the whole first second
            }
            
        }else{
            timeToShow = timeToCountOff;
        }
    }

    //setting text value
    if ([_delegate respondsToSelector:@selector(timerLabel:customTextToDisplayAtTime:)]) {
        NSTimeInterval atTime = (_timerType == CameraTimerLabelTypeStopWatch) ? timeDiff : ((timeUserValue - timeDiff) < 0 ? 0 : (timeUserValue - timeDiff));
        NSString *customtext = [_delegate timerLabel:self customTextToDisplayAtTime:atTime];
        if ([customtext length]) {
            self.timeLabel.text = customtext;
        }else{
            self.timeLabel.text = [self.dateFormatter stringFromDate:timeToShow];
        }
    }else{
        
        if(_shouldCountBeyondHHLimit) {
            //0.4.7 added---start//
            NSString *originalTimeFormat = _timeFormat;
            NSString *beyondFormat = [_timeFormat stringByReplacingOccurrencesOfString:@"HH" withString:kHourFormatReplace];
            beyondFormat = [beyondFormat stringByReplacingOccurrencesOfString:@"H" withString:kHourFormatReplace];
            self.dateFormatter.dateFormat = beyondFormat;
            
            int hours = (_timerType == CameraTimerLabelTypeStopWatch)? ([self getTimeCounted] / 3600) : ([self getTimeRemaining] / 3600);
            NSString *formmattedDate = [self.dateFormatter stringFromDate:timeToShow];
            NSString *beyondedDate = [formmattedDate stringByReplacingOccurrencesOfString:kHourFormatReplace withString:[NSString stringWithFormat:@"%02d",hours]];
            
            self.timeLabel.text = beyondedDate;
            self.dateFormatter.dateFormat = originalTimeFormat;
            //0.4.7 added---endb//
        }else{
            if(self.textRange.length > 0){
                if(self.attributedDictionaryForTextInRange){
                    
                    NSAttributedString *attrTextInRange = [[NSAttributedString alloc] initWithString:[self.dateFormatter stringFromDate:timeToShow] attributes:self.attributedDictionaryForTextInRange];
                    
                    NSMutableAttributedString *attributedString;
                    attributedString = [[NSMutableAttributedString alloc]initWithString:self.text];
                    [attributedString replaceCharactersInRange:self.textRange withAttributedString:attrTextInRange];
                    self.timeLabel.attributedText = attributedString;
        
                } else {
                    NSString *labelText = [self.text stringByReplacingCharactersInRange:self.textRange withString:[self.dateFormatter stringFromDate:timeToShow]];
                    self.timeLabel.text = labelText;
                }
            } else {
                self.timeLabel.text = [self.dateFormatter stringFromDate:timeToShow];
            }
        }
    }
    
    //0.5.1 moved below to the bottom
    if(timerEnded) {
        if([_delegate respondsToSelector:@selector(timerLabel:finshedCountDownTimerWithTime:)]){
            [_delegate timerLabel:self finshedCountDownTimerWithTime:timeUserValue];
        }
        
#if NS_BLOCKS_AVAILABLE
        if(_endedBlock != nil){
            _endedBlock(timeUserValue);
        }
#endif
        if(_resetTimerAfterFinish){
            [self reset];
        }
    }
}

- (void)free
{
    if (self.timer) {
        [self.timer invalidate];
    }
}

- (void)dealloc {
    NSLog(@"CameraTimerLabel dealloc");
}

@end
