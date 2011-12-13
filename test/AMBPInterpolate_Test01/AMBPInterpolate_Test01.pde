
#include <AMRandom.h>
#include <AMBPInterpolate.h>


int sampleDurMicroseconds = 1000; 
int samplesPerSecond = 1000000 / sampleDurMicroseconds; 
unsigned int sampleCount = 0;

// one instance
AMRandom microRandom;

// create instances
AMBPInterpolate bp1(samplesPerSecond);


//------------------------------------------------------------------------------
void setup() {
    Serial.begin(9600);


    //bp1.setModeAndDefault(AMModeMomentary, 0.0);
    // set some points
    bp1.setNextTimeValuePair(0, 0);
    bp1.setNextTimeValuePair(5, 1);
    bp1.setNextTimeValuePair(7, 1);
    bp1.setNextTimeValuePair(10, 0);
    bp1.setStartAndEndTime(0, 10);

}

//------------------------------------------------------------------------------
void loop () {

    if (sampleCount % (samplesPerSecond / 2) == 0) {
        Serial.println("/////////////");
        Serial.println("diagnostic output:");
//         Serial.println("sample, value pairs");            
//         for (int j=0; j < bp1.getCoordinateLength(); j++) {
//             Serial.println(bp1.getSampleAtIndex(j));        
//             Serial.println(bp1.getValueAtIndex(j));        
//         }
//         Serial.println("/////////////");
        Serial.println("current sample count:");
        Serial.println(sampleCount);
        Serial.println("current sample value:");
        Serial.println(bp1.floatAtSample(sampleCount));
    }

    //Serial.println("uniformLong(1, 3)");
    // inclusive boundaries


    //if (xInt < 1 || xInt > 3) Serial.println("ERROR");    

    sampleCount += 1;
    delayMicroseconds(sampleDurMicroseconds);

}