
#include <AMRandom.h>
#include <AMBPFlat.h>


// inervals.
int sampleDurMicroseconds = 1000; 
int samplesPerSecond = 1000000 / sampleDurMicroseconds; 
unsigned int sampleCount = 0;


// one instance
AMRandom microRandom;

// create instances
AMBPFlat bp1(samplesPerSecond);
AMBPFlat bp2(samplesPerSecond);


//------------------------------------------------------------------------------
void setup() {
    Serial.begin(9600);


    // configurations
    bp1.setModeAndDefault(AMModeLatch);
    //bp1.setModeAndDefault(AMModeMomentary, 0.0);
    // set some points
    bp1.setNextTimeValuePair(0, 1);
    bp1.setNextTimeValuePair(3, .5);
    bp1.setNextTimeValuePair(6, .4);
    bp1.setNextTimeValuePair(9, .9);
    bp1.setNextTimeValuePair(12, 100);
    // outer time range
    //bp1.setStartAndEndTime(0, 20);
    // can set to sub-part of the whole, and dynamically change this
    bp1.setStartAndEndTime(3, 9);

}

//------------------------------------------------------------------------------
void loop () {


    if (sampleCount % samplesPerSecond == 0) {
        Serial.println("/////////////");
        Serial.println("diagnostic output:");
        Serial.println("sample, value pairs");            
        for (int j=0; j < bp1.getCoordinateLength(); j++) {
            Serial.println(bp1.getSampleAtIndex(j));        
            Serial.println(bp1.getValueAtIndex(j));        
        }
        Serial.println("/////////////");
        Serial.println("sampleStart");
        Serial.println(bp1.getSampleStart()); 
        Serial.println("sampleEnd");
        Serial.println(bp1.getSampleEnd()); 

        Serial.println("/////////////");
        Serial.println("current sample count");
        Serial.println(sampleCount);
        Serial.println("/////////////: current time");
        Serial.println((float) sampleCount / samplesPerSecond);
        Serial.println("/////////////: current value");
        Serial.println(bp1.floatAtSample(sampleCount));
        Serial.println("/////////////");    
    }

    sampleCount += 1;
    delayMicroseconds(sampleDurMicroseconds);


}