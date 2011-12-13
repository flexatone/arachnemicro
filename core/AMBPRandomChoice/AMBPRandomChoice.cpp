

#include "WProgram.h"
#include "AMBPRandomChoice.h"
#include "AMRandom.h"


static AMRandom microRandom;


// -----------------------------------------------------------------------------
// constructor
// store samples per second; use for calculating input of values
AMBPRandomChoice::AMBPRandomChoice(float samplesPerSecond) {
    this->_samplesPerSecond = samplesPerSecond;
    // set default values for timeValue pairs, do not increment coord lengt
    for (int i=0; i<AMBPRCCoordinateSize; i++) {
        for (int j=0; j<AMBPDynamicOptionDepth; j++) {
            this->_times[i][j] = 1.0;
            this->_values[i][j] = 0.0;
        }
    }
    // set default mode
    this->_mode = AMModeLatch;
    this->_defaultValue = 0;

    // can add this as an optimization later
    this->_lastIndexUsed = 0;  
    this->_lastUpdate = 0; // this is the when the sample queried
    this->_lastOffset = 0;
    this->_lastValue = 0;
}

// -----------------------------------------------------------------------------
// configuration of the object
// set the next available value spot; will automatically increment 
// _coordinateLength
void AMBPRandomChoice::setNextOffsetValueBundle(
        float o1, float o2, float o3, float o4,
        float v1, float v2, float v3, float v4) {
    // convert time to samples; we have samples per second
    // so simply multiply the time value by samples per second

    // check if we have a valid index
    if (this->_coordinateLength > AMBPRCCoordinateSize-1) {
        // reset as a safety; will produce strange results
        this->_coordinateLength = 0;
    }
    // use _coordinateLength (starting at zero) as first data point to 
    this->_times[this->_coordinateLength][0] = o1 * this->_samplesPerSecond;
    this->_values[this->_coordinateLength][0] = v1;
    this->_times[this->_coordinateLength][1] = o2 * this->_samplesPerSecond;
    this->_values[this->_coordinateLength][1] = v2;
    this->_times[this->_coordinateLength][2] = o3 * this->_samplesPerSecond;
    this->_values[this->_coordinateLength][2] = v3;
    this->_times[this->_coordinateLength][3] = o4 * this->_samplesPerSecond;
    this->_values[this->_coordinateLength][3] = v4;

    // increment index for each addition; next will be added after
    this->_coordinateLength += 1;
}

// set the mode and default
void AMBPRandomChoice::setModeAndDefault(unsigned char mode, float def) {
    this->_mode = mode;
    this->_defaultValue = def;
}

// scale all time values by a floating point scalar
void AMBPRandomChoice::scaleTimeValues(float scalar) {
    for (int i=0; i < this->_coordinateLength; i++) {
        for (int j=0; j<AMBPDynamicOptionDepth; j++) {
            this->_times[i][j] = this->_times[i][j] * scalar; 
        }
    }    
}


// -----------------------------------------------------------------------------
int AMBPRandomChoice::_getRandomDepth() {
    // random values are inclusive, so subtrack one from depth
    return microRandom.uniformLong(0, AMBPDynamicOptionDepth-1);
}


// given a time point (an integer in samples) return the appropriate value
// this may require interpolation from the last point
float AMBPRandomChoice::floatAtSample(unsigned int t) {

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

        this->_lastOffset = this->_times[this->_lastIndexUsed][_getRandomDepth()];
        this->_lastValue = this->_values[this->_lastIndexUsed][_getRandomDepth()];
    }

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


// -----------------------------------------------------------------------------
// for diagnostic testing
unsigned int AMBPRandomChoice::getSampleAtIndexAndDepth(int i, int depth) {
    // no error checking on valid index values
    // values here are samples; need to convert to time to delivery time
    return this->_times[i][depth];
}
float AMBPRandomChoice::getValueAtIndexAndDepth(int i, int depth) {
    // no error checking on valid index values
    return this->_values[i][depth];
}

unsigned char AMBPRandomChoice::getCoordinateLength() {
    return this->_coordinateLength;
}


// -----------------------------------------------------------------------------
