
#include <AMRandom.h>
#include <AMBPRandomRange.h>


int sampleDurMicroseconds = 1000; 
int samplesPerSecond = 1000000 / sampleDurMicroseconds; 
unsigned int sampleCount = 0;

// one instance
AMRandom microRandom;

// create instances
AMBPRandomRange bp1(samplesPerSecond);


//------------------------------------------------------------------------------
void setup() {
    Serial.begin(9600);

    //bp1.setModeAndDefault(AMModeMomentary, 0.0);
    // values here are min/max offset, min/max values
    bp1.setNextOffsetValueBundle(1, 3, 100, 150);
    bp1.setNextOffsetValueBundle(10, 15, 200, 400);

}

//------------------------------------------------------------------------------
void loop () {

    if (sampleCount % (samplesPerSecond * 1) == 0) {
        Serial.println("/////////////");
        Serial.println("diagnostic output:");
//         Serial.println("sample, value pairs");            
//         for (int j=0; j < bp1.getCoordinateLength(); j++) {
//             for (int k=0; k < AMBPDynamicOptionDepth; k++) {
//                 Serial.print("sample: ");
//                 Serial.print(j);
//                 Serial.print(" ");
//                 Serial.print(bp1.getSampleAtIndexAndDepth(j, k));        
//                 Serial.print(" ");
//                 Serial.print("depth: ");
//                 Serial.print(k);
//                 Serial.print(" ");
//                 Serial.print(bp1.getValueAtIndexAndDepth(j, k));        
//                 Serial.println("");
//             }
//         }
        Serial.println("/////////////");
        Serial.print("current sample count: ");
        Serial.println(sampleCount);

//         Serial.print("_lastIndexUsed: ");
//         Serial.println(bp1._lastIndexUsed);

        Serial.print("current sample value: ");
        Serial.println(bp1.floatAtSample(sampleCount));
    }

    // time increment
    sampleCount += 1;
    delayMicroseconds(sampleDurMicroseconds);

}