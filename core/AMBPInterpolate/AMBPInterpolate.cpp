

#include "WProgram.h"
#include "AMBPInterpolate.h"

// constructor
// store samples per second; use for calculating input of values
AMBPInterpolate::AMBPInterpolate(float samplesPerSecond) {
    this->_samplesPerSecond = samplesPerSecond;

    // set default values for timeValue pairs, do not increment coord lengt
    for (int i=0; i<AMBreakpointInterpolateMaxCoordinateLength; i++) {
        this->_times[i] = i;
        this->_values[i] = 0.0;
    }
}

// -----------------------------------------------------------------------------
// configuration of the object
// set the next available value spot; will automatically increment 
// _coordinateLength
void AMBPInterpolate::setNextTimeValuePair(float t, float v) {
    // convert time to samples; we have samples per second
    // so simply multiply the time value by samples per second
    // check if we have a valid index
    if (this->_coordinateLength > 
        AMBreakpointInterpolateMaxCoordinateLength-1) {
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


// set the active time range in seconds
void AMBPInterpolate::setStartAndEndTime(float start, float end) {
    // sample start and end are ints; need to round or cast down
    this->_sampleStart = start * this->_samplesPerSecond;
    this->_sampleEnd = end * this->_samplesPerSecond;
    // no error check
    this->_sampleRange = this->_sampleEnd - this->_sampleStart;
}

// scale all time values by a floating point scalar
void AMBPInterpolate::scaleTimeValues(float scalar) {
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
unsigned char AMBPInterpolate::_getIndexAtSample(unsigned int t) {
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
    // if value not found, return 1 less than the max, the last valid index
    return this->_coordinateLength - 1; 
}


// given a time point (an integer) return the appropriate value
// this may require interpolation from the last point
float AMBPInterpolate::floatAtSample(unsigned int t) {
    // take the modulus of the sample time by the range
    t = t % this->_sampleRange;
    t = t + this->_sampleStart; // shift post mod value by min
    // this finds the left defined value
    char i = _getIndexAtSample(t);
    // set iNext to last valid index
    char iNext = this->_coordinateLength - 1;
    // if valid indicies are 0,1,2; coord length is 3
    // if i is 2, iNext should be 2
    // if i is 1, iNext should also be 2
    // if i is 0, iNext should be 1
    if (i < this->_coordinateLength - 2) {
        iNext = i + 1;
    }
    // if we are after the last-defined index, return the value at that
    // index
    if (i == iNext) {
        return this->_values[i];
    }

    float value = this->_values[i];
    float valueNext = this->_values[iNext];
    // cast these unsigned ints to floats
    float sample = this->_times[i];
    float sampleNext = this->_times[iNext];

    // get percent of progress in samples, then mult by value range
    // then add to lower value
    return value + ((t - sample)/(sampleNext - sample)) * (valueNext - value);

}


// -----------------------------------------------------------------------------
// for diagnostic testing
int AMBPInterpolate::getSampleAtIndex(int i) {
    // no error checking on valid index values
    // values here are samples; need to convert to time to delivery time
    return this->_times[i];
}
float AMBPInterpolate::getValueAtIndex(int i) {
    // no error checking on valid index valyes
    return this->_values[i];
}

unsigned char AMBPInterpolate::getCoordinateLength() {
    return this->_coordinateLength;
}

unsigned int AMBPInterpolate::getSampleStart() {
    return this->_sampleStart;
}

unsigned int AMBPInterpolate::getSampleEnd() {
    return this->_sampleEnd;
}

// -----------------------------------------------------------------------------
