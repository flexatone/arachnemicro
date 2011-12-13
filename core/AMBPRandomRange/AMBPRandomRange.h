

#ifndef AM_BP_RANDOM_RANGE
#define AM_BP_RANDOM_RANGE

#include "WProgram.h"

#define AMModeMomentary 0 // no colon or equal sign
#define AMModeLatch 1 // no colon or equal

#define AMRandomUniform 0
#define AMRandomTriangle 1
//#define AMRandomGauss 2

#define AMBPRRCoordinateSize 8 // max coordinate
#define AMBPRROptionDepth 2 // depth is 2, as only provide min and max

// -----------------------------------------------------------------------------
class AMBPRandomRange {
public:
    AMBPRandomRange(float samplesPerSecond=20); // constructor
    // methods
    void setNextOffsetValueBundle(float o1, float o2, float v1, float v2);

    void setModeAndDefault(unsigned char mode=AMModeLatch, float def=0);
    void setRandomMethodAndParameters(unsigned char mode=AMRandomUniform, 
                                      int p1=0.5, int p2=0.0);

    float floatAtSample(unsigned int t);
    int intAtSample(unsigned int t);

    void scaleTimeValues(float scalar);

    unsigned int getSampleAtIndexAndDepth(int i, int depth);
    float getValueAtIndexAndDepth(int i, int depth);
    unsigned char getCoordinateLength();


private:
    // cannot set values here, can only define;
    float _samplesPerSecond;

    // store a fixed number time and value points
    // times values are converted into integer samples
    unsigned int _times[AMBPRRCoordinateSize][AMBPRROptionDepth];
    float _values[AMBPRRCoordinateSize][AMBPRROptionDepth];

    unsigned int _lastUpdate; // this is when it was requested
    unsigned int _lastOffset;
    int _lastIndexUsed; 
    float _lastValue;

    // must define the size of the active data points
    unsigned char _coordinateLength; 

    // store value to return when not latched
    float _defaultValue;

    // mode can either by momentary (0) or latch (1)
    // if momentary, a time point only defines a value for that time point
    // all other values return the default value (zero maybe)
    // if latched, the value continues until a new value is encountered
    // this results in stepped pattern
    unsigned char _mode;

    // provide configuration for different random selectors
    unsigned char _randomMethod;
    float _randomParameter1;
    float _randomParameter2;


};

#endif

