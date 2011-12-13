

#include "WProgram.h"
#include "AMBPFlat.h"

// -----------------------------------------------------------------------------
// constructor
// store samples per second; use for calculating input of values
AMBPFlat::AMBPFlat(float samplesPerSecond) {
    this->_samplesPerSecond = samplesPerSecond;

    // set default values for timeValue pairs, do not increment coord lengt
    for (int i=0; i<AMBPCoordinateSize; i++) {
        this->_times[i] = i;
        this->_values[i] = 0.0;
    }
    // set default mode
    this->_mode = AMModeLatch;
    this->_defaultValue = 0;

    // can add this as an optimization later
    //this->_lastCoordinateIndex = 0; // can compare to this->_coordinateLength
}

// -----------------------------------------------------------------------------
// configuration of the object
// set the next available value spot; will automatically increment 
// _coordinateLength
void AMBPFlat::setNextTimeValuePair(float t, float v) {
    // convert time to samples; we have samples per second
    // so simply multiply the time value by samples per second

    // check if we have a valid index
    if (this->_coordinateLength > AMBPCoordinateSize-1) {
        // reset as a safety; will produce strange results
        this->_coordinateLength = 0;
    }
    // use _coordinateLength (starting at zero) as first data point to 
    // assuming that times are in order; if not, a potential problem
    this->_times[this->_coordinateLength] = t * this->_samplesPerSecond;
    this->_values[this->_coordinateLength] = v;
    // increment index for each addition; next will be added after
    this->_coordinateLength += 1;
}

// set the mode and default
void AMBPFlat::setModeAndDefault(unsigned char mode, float def) {
    this->_mode = mode;
    this->_defaultValue = def;
}

// set the active time range in seconds
void AMBPFlat::setStartAndEndTime(float start, float end) {
    // sample start and ned are ints; need to round or cast down
    this->_sampleStart = start * this->_samplesPerSecond;
    this->_sampleEnd = end * this->_samplesPerSecond;
    // no error check
    this->_sampleRange = this->_sampleEnd - this->_sampleStart;
}

// scale all time values by a floating point scalar
void AMBPFlat::scaleTimeValues(float scalar) {
    for (int i=0; i < this->_coordinateLength; i++) {
        this->_times[i] = this->_times[i] * scalar; 
    }    
    this->_sampleStart = this->_sampleStart * scalar;
    this->_sampleEnd = this->_sampleEnd * scalar;
    // must update sampleRange value; this is used for modulus of time
    this->_sampleRange = this->_sampleEnd - this->_sampleStart;
}



// -----------------------------------------------------------------------------
// core routine for finding the index that is relevant for the requested sample
// value; this currently is a slow procedure in that it always iterates over
// every coordinate; could make faster if we kept track of where we were last
// it is assumed that the modulus of t is already taken
unsigned char AMBPFlat::_getIndexAtSample(unsigned int t) {
    int low = 0;
    int high = 0;
    // iterate to 1 less than the most; 
    for (int i=0; i < this->_coordinateLength-1; i++) {
        high = this->_times[i+1]; // set as the high value
        if (t >= low && t < high) {
            return i;
        }
        low = high; // redefine the low value
    }
    // if value not found,
    // return 1 less than the max, the last valid index
    return this->_coordinateLength - 1; 
}


// given a time point (an integer) return the appropriate value
// this may require interpolation from the last point
float AMBPFlat::floatAtSample(unsigned int t) {
    // take the modulus of the sample time by the range
    t = t % this->_sampleRange;
    t = t + this->_sampleStart; // shift post mod value by min
    // find the index of the value that, for a given sample, provides the 
    // relevant value; 
    unsigned char i = _getIndexAtSample(t);

    float value = 0.0;
    if (this->_mode == AMModeMomentary) {
        // find boundary value; return this if we are at it or the default
        // value
        if (t == this->_times[i]) {
            value = this->_values[i];
        } else {
            value = this->_defaultValue;
        }
    }
    else if (this->_mode == AMModeLatch) {
        // get value defined at this index
        value = this->_values[i];
    }
    return value;
}


// -----------------------------------------------------------------------------
// for diagnostic testing
unsigned int AMBPFlat::getSampleAtIndex(int i) {
    // no error checking on valid index values
    // values here are samples; need to convert to time to delivery time
    return this->_times[i];
}
float AMBPFlat::getValueAtIndex(int i) {
    // no error checking on valid index valyes
    return this->_values[i];
}

unsigned char AMBPFlat::getCoordinateLength() {
    return this->_coordinateLength;
}

unsigned int AMBPFlat::getSampleStart() {
    return this->_sampleStart;
}

unsigned int AMBPFlat::getSampleEnd() {
    return this->_sampleEnd;
}

// -----------------------------------------------------------------------------
