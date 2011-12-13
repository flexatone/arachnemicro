

#include "WProgram.h"
#include "AMAcquisition.h"

// -----------------------------------------------------------------------------
AMAcquisition::AMAcquisition(float samplesPerSecond) {
    this->_samplesPerSecond = samplesPerSecond;

    // set default values for timeValue pairs, do not increment coord lengt
    for (int i=0; i<AMAcquiredValuesSize; i++) {
        this->_acquiredValues[i] = 0;
    }

    for (int i=0; i<AMZoneSize; i++) {
        this->_zoneBoundaries[i][0] = 0;
        this->_zoneBoundaries[i][1] = 0;
    }
        
    this->_acquiredValuesIndex = 0; // initialize to zero
    this->_pin = 0; // initialize to zero
    this->_pinMin = 0;
    this->_pinMax = 1024; // standard max for analogRead

    this->_samplesBetweenAquisitions = 200; // initialize to zero
    this->_numberOfAquisitionsToAverage = 2;
}

// -----------------------------------------------------------------------------
void AMAcquisition::setNextZoneBoundaries(float min, float max) {
    // check if we have a valid index
    if (this->_zoneLength > AMZoneSize-1) {
        // reset as a safety; will produce strange results
        this->_zoneLength = 0;
    }
    this->_zoneBoundaries[this->_zoneLength][0] = min;
    this->_zoneBoundaries[this->_zoneLength][1] = max;
    // increment for each addition
    this->_zoneLength += 1;
}

// -----------------------------------------------------------------------------
// set time in seconds; convert to samples
void AMAcquisition::setTimeBetweenAquisitions(float t) {
    this->_samplesBetweenAquisitions = this->_samplesPerSecond * t;
}

// -----------------------------------------------------------------------------
// set time in seconds; convert to samples
void AMAcquisition::setNumberOfAquisitionsToAverage(unsigned char v) {
    this->_numberOfAquisitionsToAverage = v;
}

// -----------------------------------------------------------------------------
void AMAcquisition::setPin(unsigned char p) {
    this->_pin = p; 
}

// -----------------------------------------------------------------------------
void AMAcquisition::setPinMinMax(unsigned int min, unsigned int max) {
    this->_pinMin = min; 
    this->_pinMax = max; 
}


// -----------------------------------------------------------------------------
unsigned int AMAcquisition::_acquire() {
    return analogRead(this->_pin);
}


// -----------------------------------------------------------------------------
void AMAcquisition::updateAtSample(unsigned int t) {
    // problem using modulus is that when sample count wraps around, 
    // we may get a discontinuity in the sampling period; not sure if this
    // if this is a problems
    // if at modulus of samples 
    if (t % this->_samplesBetweenAquisitions == 0) {
        // set data
        this->_acquiredValues[this->_acquiredValuesIndex] = this->_acquire();
        this->_acquiredValuesIndex += 1;
        // reset index to zero on overflow
        if (this->_acquiredValuesIndex >= AMAcquiredValuesSize) {
            this->_acquiredValuesIndex = 0;
        }
    }
}



// normalize values using min/max
// -----------------------------------------------------------------------------
float AMAcquisition::_normalize(unsigned int v) {
    // limit within bounds
    if (v > this->_pinMax) {
        v = this->_pinMax;
    }
    else if (v < this->_pinMin) {
        v = this->_pinMin;
    }
    // shift the value minus the min, then divide by range
    float range = (float) (this->_pinMax - this->_pinMin);
    float shifted = (float) (v - this->_pinMin);
    return shifted / range;
}


// -----------------------------------------------------------------------------
// get the last average 
float AMAcquisition::getNormalizedAverage() {
    float sum = 0.0;
    for (int i=0; i < this->_numberOfAquisitionsToAverage; i++) {
        // keep localIndex an int to permit proper negative values
        // _acquiredValuesIndex is always at value for next storage, so need
        // to subtract one from this value to get the last data point written
        int localIndex = this->_acquiredValuesIndex - 1 - i;
        if (localIndex < 0) {
            // subtract from total number to wrap around; local already neg
            localIndex = AMAcquiredValuesSize + localIndex;
        }
        sum += _normalize(this->_acquiredValues[localIndex]);
    }
    return sum / this->_numberOfAquisitionsToAverage;

}

// -----------------------------------------------------------------------------
// get the zone based on the average 
int AMAcquisition::getZone() {
    float avg = getNormalizedAverage();
    for (int i=0; i < this->_zoneLength; i++) {
        float min = _zoneBoundaries[i][0];
        float max = _zoneBoundaries[i][1];
        // for now doing equal on both sides
        if (avg >= min && avg <= max) {
            return i;
        }
    }
    return -1; // use to mark error
}


// get the zone as a floating point value between 0 and 1
float AMAcquisition::getZoneNormalized(bool invert) {
    if (invert) {
        return 1 - (float) getZone() / (float) this->_zoneLength;
    }
    else {
        return (float) getZone() / (float) this->_zoneLength;
    }
}



// // given a time point (an integer) return the appropriate value
// // this may require interpolation from the last point
// float AMAcquisition::floatAtSample(unsigned long t) {
//     return 0.5;
// }
// 
// // have int version for easy cases
// int AMAcquisition::intAtSample(unsigned long t) {
//     return 1;
// }
// 
// // set the next available value spot; will automatically increment 
// // _coordinateLength

// 
// // for diagnostic testing
// int AMAcquisition::getSampleAtIndex(int i) {
//     // no error checking on valid index values
//     // values here are samples; need to convert to time to delivery time
//     return this->_times[i];
// }
// float AMAcquisition::getValueAtIndex(int i) {
//     // no error checking on valid index valyes
//     return this->_values[i];
// }
