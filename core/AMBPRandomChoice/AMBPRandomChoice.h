

#ifndef AM_BP_RANDOM_CHOICE
#define AM_BP_RANDOM_CHOICE

#include "WProgram.h"

#define AMModeMomentary 0 // no colon or equal sign
#define AMModeLatch 1 // no colon or equal

#define AMBPRCCoordinateSize 4 // max coordinate
#define AMBPDynamicOptionDepth 4 // max depth

// -----------------------------------------------------------------------------
class AMBPRandomChoice {
public:
    AMBPRandomChoice(float samplesPerSecond=20); // constructor
    // methods
    void setNextOffsetValueBundle(float o1, float o2, float o3, float o4,
                                   float v1, float v2, float v3, float v4);

    void setModeAndDefault(unsigned char mode=AMModeLatch, float def=0);

    int _getRandomDepth();
    float floatAtSample(unsigned int t);
    void scaleTimeValues(float scalar);

    unsigned int getSampleAtIndexAndDepth(int i, int depth);
    float getValueAtIndexAndDepth(int i, int depth);

    unsigned char getCoordinateLength();


private:
    // cannot set values here, can only define;
    float _samplesPerSecond;

    // store a fixed number time and value points
    // times values are converted into integer samples
    unsigned int _times[AMBPRCCoordinateSize][AMBPDynamicOptionDepth];
    float _values[AMBPRCCoordinateSize][AMBPDynamicOptionDepth];

    unsigned int _lastUpdate; // this is when it was requested
    unsigned int _lastOffset;
    unsigned int _lastIndexUsed; 
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


};

#endif

