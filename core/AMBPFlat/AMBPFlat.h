

#ifndef AM_BP_FLAT
#define AM_BP_FLAT

#include "WProgram.h"

#define AMModeMomentary 0 // no colon or equal sign
#define AMModeLatch 1 // no colon or equal
// setting this value above 24 results in a massive increase in memory size
// try to keep this as small as possible
#define AMBPCoordinateSize 8 // max coordinates

// -----------------------------------------------------------------------------
class AMBPFlat {
public:
    AMBPFlat(float samplesPerSecond=20); // constructor
    // methods
    void setNextTimeValuePair(float t, float v);
    void setStartAndEndTime(float start, float end);
    void setModeAndDefault(unsigned char mode=AMModeLatch, float def=0);
    void scaleTimeValues(float scalar);

    unsigned char _getIndexAtSample(unsigned int t);
    float floatAtSample(unsigned int t);

    unsigned int getSampleAtIndex(int i);
    float getValueAtIndex(int i);

    unsigned char getCoordinateLength();
    unsigned int getSampleStart();
    unsigned int getSampleEnd();

private:
    // cannot set values here, can only define;
    float _samplesPerSecond;

    // store a fixed number time and value points
    // times values are converted into integer samples
    unsigned int _times[AMBPCoordinateSize];
    float _values[AMBPCoordinateSize];

    // must define the size of the active data points
    // in the source data arrays / cannot be 16 or greater
    unsigned char _coordinateLength; 

    // store last value read    
    float _defaultValue;

    // mode can either by momentary (0) or latch (1)
    // if momentary, a time point only defines a value for that time point
    // all other values return the default value (zero maybe)
    // if latched, the value continues until a new value is encountered
    // this results in stepped pattern
    unsigned char _mode;

    // set the time at which we reset to zero and where we start
    // this can be set externally to create dynamically sized patterns
    unsigned int _sampleStart;
    unsigned int _sampleEnd;
    unsigned int _sampleRange; // store range between start and end
// 
//     // store an internal sample count that is incremented on each call
//     // permit a modulus of all sample counts, such that bp can be slowed down
//     int _sampleCountLocal = 0; // internal register for comparing to modulus
//     int _sampleModulus = 1; 
// 

};

#endif

