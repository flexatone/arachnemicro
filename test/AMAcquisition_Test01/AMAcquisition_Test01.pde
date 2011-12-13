
#include <AMRandom.h>
#include <AMBPFlat.h>
#include <AMAcquisition.h>


// inervals.
int sampleDurMicroseconds = 1000; 
int samplesPerSecond = 1000000 / sampleDurMicroseconds; 
unsigned int sampleCount = 0;


// one instance
AMRandom microRandom;

// create instances
AMBPFlat bp1(samplesPerSecond);
AMBPFlat bp2(samplesPerSecond);

AMAcquisition aq1(samplesPerSecond);
AMAcquisition aq2(samplesPerSecond);

//------------------------------------------------------------------------------
void setup() {
    Serial.begin(9600);


    // configurations
    aq1.setPin(0);
    aq1.setPinMinMax(20, 950);
    aq1.setTimeBetweenAquisitions(1); // set time in seconds
    aq1.setNumberOfAquisitionsToAverage(4); 
    aq1.setNextZoneBoundaries(0, .5); // zone 0
    aq1.setNextZoneBoundaries(.5, 1); // zone 1

    aq2.setPin(1);
    aq2.setPinMinMax(0, 1024);
    aq2.setTimeBetweenAquisitions(1); // set time in seconds
    aq2.setNumberOfAquisitionsToAverage(1); // set to be immediate
    aq2.setNextZoneBoundaries(0, .25); // zone 0
    aq2.setNextZoneBoundaries(.25, .5); // zone 1
    aq2.setNextZoneBoundaries(.5, .75); // zone 1
    aq2.setNextZoneBoundaries(.75, 1); // zone 1


}

//------------------------------------------------------------------------------
void loop () {

    // report sample count on each iteration; does not mean a value will
    // be acquired
    aq1.updateAtSample(sampleCount);
    aq2.updateAtSample(sampleCount);

    if (sampleCount % samplesPerSecond == 0) {
        Serial.println("/////////////");
        Serial.println("diagnostic output:");

        Serial.print("aq1: sampled values: ");            
        for (int j=0; j < AMAcquiredValuesSize; j++) {
            Serial.print(aq1._acquiredValues[j]);        
            Serial.print("   ");        
        }
        Serial.println("");

        Serial.print("aq2: sampled values: ");            
        for (int j=0; j < AMAcquiredValuesSize; j++) {
            Serial.print(aq2._acquiredValues[j]);        
            Serial.print("   ");        
        }
        Serial.println("");

        Serial.print("aq1: normalized average: ");            
        Serial.print(aq1.getNormalizedAverage());        
        Serial.println("");
        Serial.print("aq1: get zone: ");            
        Serial.print(aq1.getZone());        
        Serial.println("");


        Serial.print("aq2: normalized average: ");            
        Serial.print(aq2.getNormalizedAverage());        
        Serial.println("");
        Serial.print("aq2: get zone: ");            
        Serial.print(aq2.getZone());        
        Serial.println("");


//         Serial.println("/////////////");
//         Serial.print("current sample count: ");
//         Serial.print(sampleCount);
//         Serial.println("");

        Serial.print("current time: ");
        Serial.print((float) sampleCount / samplesPerSecond);
        Serial.println("");
        Serial.println("/////////////");    
    }



    sampleCount += 1;
    delayMicroseconds(sampleDurMicroseconds);


}