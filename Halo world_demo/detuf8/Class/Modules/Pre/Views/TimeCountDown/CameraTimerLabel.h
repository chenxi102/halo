//
//  CameraTimerLabel.h

#import <UIKit/UIKit.h>


/**********************************************
 CameraTimerLabel TimerType Enum
 **********************************************/
typedef enum{
    CameraTimerLabelTypeStopWatch,
    CameraTimerLabelTypeTimer
}CameraTimerLabelType;

/**********************************************
 Delegate Methods
**********************************************/
 
@class CameraTimerLabel;
@protocol CameraTimerLabelDelegate <NSObject>
@optional
-(void)timerLabel:(CameraTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime;
-(void)timerLabel:(CameraTimerLabel*)timerLabel countingTo:(NSTimeInterval)time timertype:(CameraTimerLabelType)timerType;
-(NSString*)timerLabel:(CameraTimerLabel*)timerLabel customTextToDisplayAtTime:(NSTimeInterval)time;
@end

/**********************************************
 MZTimerLabel Class Defination
 **********************************************/

@interface CameraTimerLabel : UILabel;

/*Time count /sec */
@property (assign, nonatomic) int dateCount;
/*Delegate for finish of countdown timer */
@property (nonatomic,weak) id<CameraTimerLabelDelegate> delegate;

/*Time format wish to display in label*/
@property (nonatomic,copy) NSString *timeFormat;

/*Target label obejct, default self if you do not initWithLabel nor set*/
@property (nonatomic,strong) UILabel *timeLabel;

/*Used for replace text in range */
@property (nonatomic, assign) NSRange textRange;

@property (nonatomic, strong) NSDictionary *attributedDictionaryForTextInRange;

/*Type to choose from stopwatch or timer*/
@property (assign) CameraTimerLabelType timerType;

/*Is The Timer Running?*/
@property (assign,readonly) BOOL counting;

/*Do you want to reset the Timer after countdown?*/
@property (assign) BOOL resetTimerAfterFinish;

/*Do you want the timer to count beyond the HH limit from 0-23 e.g. 25:23:12 (HH:mm:ss) */
@property (assign,nonatomic) BOOL shouldCountBeyondHHLimit;

#if NS_BLOCKS_AVAILABLE
@property (copy) void (^endedBlock)(NSTimeInterval);
#endif


/*--------Init methods to choose*/
-(id)initWithTimerType:(CameraTimerLabelType)theType;
-(id)initWithLabel:(UILabel*)theLabel andTimerType:(CameraTimerLabelType)theType;
-(id)initWithLabel:(UILabel*)theLabel;
/*--------designated Initializer*/
-(id)initWithFrame:(CGRect)frame label:(UILabel*)theLabel andTimerType:(CameraTimerLabelType)theType;

/*--------Timer control methods to use*/
-(void)start;
#if NS_BLOCKS_AVAILABLE
-(void)startWithEndingBlock:(void(^)(NSTimeInterval countTime))end; //use it if you are not going to use delegate
#endif
-(void)pause;
-(void)reset;

/*--------Setter methods*/
-(void)setCountDownTime:(NSTimeInterval)time;
-(void)setStopWatchTime:(NSTimeInterval)time;
-(void)setCountDownToDate:(NSDate*)date;

-(void)addTimeCountedByTime:(NSTimeInterval)timeToAdd;

/*--------Getter methods*/
- (NSTimeInterval)getTimeCounted;
- (NSTimeInterval)getTimeRemaining;
- (NSTimeInterval)getCountDownTime;


- (void)free ;


@end


