

#ifndef AM_BREAKPOINT_INTERPOLATE
#define AM_BREAKPOINT_INTERPOLATE

#include "WProgram.h"

#define AMBreakpointInterpolateMaxCoordinateLength 8 // max coordinate

// -----------------------------------------------------------------------------
class AMBPInterpolate {
public:
    AMBPInterpolate(float samplesPerSecond=20); // constructor
    // methods
    void setNextTimeValuePair(float t, float v);
    void setStartAndEndTime(float start, float end);
    void scaleTimeValues(float scalar);
// 
    unsigned char _getIndexAtSample(unsigned int t);
    float floatAtSample(unsigned int t);

    int getSampleAtIndex(int i);
    float getValueAtIndex(int i);

    unsigned char getCoordinateLength();
    unsigned int getSampleStart();
    unsigned int getSampleEnd();

private:
    // cannot set values here, can only define;
    float _samplesPerSecond;

    // store a fixed number time and value points
    // times values are converted into integer samples
    unsigned int _times[AMBreakpointInterpolateMaxCoordinateLength];
    float _values[AMBreakpointInterpolateMaxCoordinateLength];

    // must define the size of the active data points
    // in the source data arrays / cannot be 16 or greater
    unsigned char _coordinateLength; 

    // set the time at which we reset to zero and where we start
    // this can be set externally to create dynamically sized patterns
    unsigned int _sampleStart;
    unsigned int _sampleEnd;
    unsigned int _sampleRange; // store range between start and end

};

#endif

