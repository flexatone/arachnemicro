

#ifndef AM_ACQUISITION
#define AM_ACQUISITION

#include "WProgram.h"


// an object to aquire a sensor parameter
// can set how often sensor is updated, and store history buffer
// can internalize scaling of sensor
// can determine over how long or how many samples value is averaged
// can return a flat if value has changed within a certain amount


// #define AMModeMomentary 0 // no colon or equal sign
// #define AMModeLatch 1 // no colon or equal


#define AMAcquiredValuesSize 24 // max coordinate
#define AMZoneSize 6 // max number

// -----------------------------------------------------------------------------
class AMAcquisition {
public:
    AMAcquisition(float samplesPerSecond=20); // constructor
    // methods


    // add a range (in unit interval) and id; assume unit interval
    // id of zone is position added in this list
    void setNextZoneBoundaries(float min, float max);

    // time in seconds between each acqusition    
    void setTimeBetweenAquisitions(float t);

    // how many aquisitions are rounded together
    void setNumberOfAquisitionsToAverage(unsigned char v);

    void setPin(unsigned char p);

    // sensor values will be normalized; this must be found through experiment
    // for a given sensor
    void setPinMinMax(unsigned int min, unsigned int max);

    float getNormalizedAverage();

    // this is the main method called to update values 
    void updateAtSample(unsigned int t);

    // return the index of the current zone, or -1 on no match
    int getZone();

    // return a zone value normalized between 0 and 1
    float getZoneNormalized(bool invert=false);

    // to consider:
    //  how long in a zone before we we count it
    //     void setTimeRequiredInZone(float t);
    //     // determine what zone we were last in
    //     float getTimeInZone();

    // temporarily made non-private for debugging
    unsigned int _acquiredValues[AMAcquiredValuesSize];

private:
    // methods
    // method to get a raw value
    unsigned int _acquire();
    float _normalize(unsigned int v);

    // data storage
    float _samplesPerSecond;
    unsigned char _pin;
    unsigned int _pinMin;
    unsigned int _pinMax;
    // this may need to be an unsigned int b/c doing mod comparison to sample 
    // time
    unsigned int _samplesBetweenAquisitions;
    unsigned char _numberOfAquisitionsToAverage;

    // store sample at which value was gathered; wrap around index
    unsigned char _acquiredValuesIndex;


    // store two paralel lists, as different types
    float _zoneBoundaries[AMZoneSize][2];
    unsigned char _zoneLength; 



};

#endif

