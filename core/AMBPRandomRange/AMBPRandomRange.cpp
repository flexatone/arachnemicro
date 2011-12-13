

#include "WProgram.h"
#include "AMBPRandomRange.h"
#include "AMRandom.h"

// create one static instance (hopefully) for all classes
// probably better to implement as a singleton from a shared object
static AMRandom microRandom;


// -----------------------------------------------------------------------------
// constructor
// store samples per second; use for calculating input of values
AMBPRandomRange::AMBPRandomRange(float samplesPerSecond) {
    this->_samplesPerSecond = samplesPerSecond;
    // set default values for timeValue pairs, do not increment coord lengt
    for (int i=0; i<AMBPRRCoordinateSize; i++) {
        for (int j=0; j<AMBPRROptionDepth; j++) {
            this->_times[i][j] = 1.0;
            this->_values[i][j] = 0.0;
        }
    }
    // set default mode
    this->_mode = AMModeLatch;
    this->_defaultValue = 0;

    // set default random values
    this->_randomMethod = AMRandomUniform;
    this->_randomParameter1 = 0.5;
    this->_randomParameter2 = 0.0;

    // can add this as an optimization later
    this->_lastIndexUsed = -1;  // shows that this is in init; will be incr.
    this->_lastUpdate = 0; // this is the when the sample queried
    this->_lastOffset = 0;
    this->_lastValue = 0;
}

// -----------------------------------------------------------------------------
// configuration of the object
// set the mode and default
void AMBPRandomRange::setModeAndDefault(unsigned char mode, float def) {
    this->_mode = mode;
    this->_defaultValue = def;
}

void AMBPRandomRange::setRandomMethodAndParameters(unsigned char mode, 
    int p1, int p2) {
    this->_randomMethod = mode;
    this->_randomParameter1 = p1;
    this->_randomParameter2 = p2;
}


// set the next available value spot; will automatically increment 
// _coordinateLength
void AMBPRandomRange::setNextOffsetValueBundle(float o1, float o2, 
    float v1, float v2) {
    // convert time to samples; we have samples per second
    // so simply multiply the time value by samples per second

    // check if we have a valid index
    if (this->_coordinateLength > AMBPRRCoordinateSize-1) {
        // reset as a safety; will produce strange results
        this->_coordinateLength = 0;
    }
    // use _coordinateLength (starting at zero) as first data point to 
    this->_times[this->_coordinateLength][0] = o1 * this->_samplesPerSecond;
    this->_values[this->_coordinateLength][0] = v1;
    this->_times[this->_coordinateLength][1] = o2 * this->_samplesPerSecond;
    this->_values[this->_coordinateLength][1] = v2;

    // increment index for each addition; next will be added after
    this->_coordinateLength += 1;
}


// scale all time values by a floating point scalar
void AMBPRandomRange::scaleTimeValues(float scalar) {
    for (int i=0; i < this->_coordinateLength; i++) {
        for (int j=0; j<AMBPRROptionDepth; j++) {
            this->_times[i][j] = this->_times[i][j] * scalar; 
        }
    }    
}


// -----------------------------------------------------------------------------
// given a time point (an integer in samples) return the appropriate value
// this may require interpolation from the last point
float AMBPRandomRange::floatAtSample(unsigned int t) {

    // conditions for updating the value 
    // on init t == 0 and all other value are zero
    if (t >= this->_lastUpdate + this->_lastOffset) {
        // set query 
        this->_lastUpdate = t; 
        // always increment; on init this is -1, will result in zero
        this->_lastIndexUsed += 1; 
        // after increment, take modulus of coord size, forcing
        // indicies always in range
        this->_lastIndexUsed = this->_lastIndexUsed % this->_coordinateLength;

        unsigned int minOffset = this->_times[this->_lastIndexUsed][0];
        unsigned int maxOffset = this->_times[this->_lastIndexUsed][1];

        float minValue = this->_values[this->_lastIndexUsed][0];
        float maxValue = this->_values[this->_lastIndexUsed][1];

        if (this->_randomMethod == AMRandomUniform) {
            this->_lastOffset = microRandom.uniformLong(minOffset, maxOffset);
            this->_lastValue = microRandom.uniformFloat(minValue, maxValue);
        } else if (this->_randomMethod == AMRandomTriangle) {
            // use random parameter to get mode; assume unit interval scaling
            // so find range and then scale
            float modeOffset = this->_randomParameter1 * (maxOffset-minOffset);
            float modeValue = this->_randomParameter1 * (maxValue-minValue);
            this->_lastOffset = microRandom.triangleLong(minOffset, maxOffset, 
                                                        modeOffset);
            this->_lastValue = microRandom.triangleFloat(minValue, maxValue, 
                                                        modeValue);
        }
    }
    // TODO: have not tested momentary 
    float value = 0.0;
    if (this->_mode == AMModeMomentary) {
        // boundary is if we have just updated
        if (t == this->_lastUpdate) {
            value = this->_lastValue;
        } else {
            value = this->_defaultValue;
        }
    }
    else if (this->_mode == AMModeLatch) {
        // get value defined at this index
        value = this->_lastValue;
    }
    return value;
}


int AMBPRandomRange::intAtSample(unsigned int t) {
    // possibly round
    return (int) floatAtSample(t);
}


// -----------------------------------------------------------------------------
// for diagnostic testing
unsigned int AMBPRandomRange::getSampleAtIndexAndDepth(int i, int depth) {
    // no error checking on valid index values
    // values here are samples; need to convert to time to delivery time
    return this->_times[i][depth];
}
float AMBPRandomRange::getValueAtIndexAndDepth(int i, int depth) {
    // no error checking on valid index values
    return this->_values[i][depth];
}

unsigned char AMBPRandomRange::getCoordinateLength() {
    return this->_coordinateLength;
}


// -----------------------------------------------------------------------------
