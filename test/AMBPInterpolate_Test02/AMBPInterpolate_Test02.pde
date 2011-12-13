
#include <AMRandom.h>
#include <AMBPInterpolate.h>


int sampleDurMicroseconds = 1000; 
int samplesPerSecond = 1000000 / sampleDurMicroseconds; 
unsigned int sampleCount = 0;

// one instance
AMRandom microRandom;

// create instances
AMBPInterpolate bp1(samplesPerSecond);
AMBPInterpolate bp2(samplesPerSecond);
AMBPInterpolate bp3(samplesPerSecond);
AMBPInterpolate bp4(samplesPerSecond);

AMBPInterpolate bp5(samplesPerSecond);
AMBPInterpolate bp6(samplesPerSecond);
AMBPInterpolate bp7(samplesPerSecond);
AMBPInterpolate bp8(samplesPerSecond);


char pin1 = 4;
char pin2 = 5;
char pin3 = 6;
char pin4 = 7;

// all have pwm
char pin5 = 3;
char pin6 = 9;
char pin7 = 10;
char pin8 = 11;


//------------------------------------------------------------------------------
void setup() {
    Serial.begin(9600);

    pinMode(pin1, OUTPUT);
    pinMode(pin2, OUTPUT);
    pinMode(pin3, OUTPUT);
    pinMode(pin4, OUTPUT);
    pinMode(pin5, OUTPUT);
    pinMode(pin6, OUTPUT);
    pinMode(pin7, OUTPUT);
    pinMode(pin8, OUTPUT);

    // set some points

    bp1.setNextTimeValuePair(0, 0);
    bp1.setNextTimeValuePair(2, 0);
    bp1.setNextTimeValuePair(2.01, 1);
    bp1.setNextTimeValuePair(8.01, 1);
    bp1.setStartAndEndTime(0, 9);

    bp2.setNextTimeValuePair(0, 0);
    bp2.setNextTimeValuePair(10, 0);
    bp2.setNextTimeValuePair(10.21, 1);
    bp2.setNextTimeValuePair(10.31, 1);
    bp2.setStartAndEndTime(0, 11);

    bp3.setNextTimeValuePair(0, 0);
    bp3.setNextTimeValuePair(.2, 0);
    bp3.setNextTimeValuePair(.21, 1);
    bp3.setNextTimeValuePair(.31, 1);
    bp3.setNextTimeValuePair(.32, 0);
    bp3.setStartAndEndTime(0, 5);

    bp4.setNextTimeValuePair(0, 0);
    bp4.setNextTimeValuePair(.2, 0);
    bp4.setNextTimeValuePair(.21, 1);
    bp4.setNextTimeValuePair(.31, 1);
    bp4.setNextTimeValuePair(.32, 0);
    bp4.setStartAndEndTime(0, 7);


    bp5.setNextTimeValuePair(0, 0);
    bp5.setNextTimeValuePair(5, 1);
    bp5.setNextTimeValuePair(5.1, 0);
    bp5.setNextTimeValuePair(7, 1);
    bp5.setNextTimeValuePair(7.1, 0);
    bp5.setNextTimeValuePair(8, 1);
    bp5.setNextTimeValuePair(8.1, 0);
    bp5.setStartAndEndTime(0, 15);

    bp6.setNextTimeValuePair(0, 0);
    bp6.setNextTimeValuePair(5, 1);
    bp6.setNextTimeValuePair(5.1, 0);
    bp6.setNextTimeValuePair(7, 1);
    bp6.setNextTimeValuePair(7.1, 0);
    bp6.setNextTimeValuePair(8, 1);
    bp6.setNextTimeValuePair(8.1, 0);
    bp6.setStartAndEndTime(0, 12);

    bp7.setNextTimeValuePair(0, 0);
    bp7.setNextTimeValuePair(5, 1);
    bp7.setNextTimeValuePair(5.1, 0);
    bp7.setNextTimeValuePair(7, 1);
    bp7.setNextTimeValuePair(7.1, 0);
    bp7.setNextTimeValuePair(8, 1);
    bp7.setNextTimeValuePair(8.1, 0);
    bp7.setStartAndEndTime(0, 16);

    bp8.setNextTimeValuePair(0, 0);
    bp8.setNextTimeValuePair(5, 1);
    bp8.setNextTimeValuePair(5.1, 0);
    bp8.setNextTimeValuePair(7, 1);
    bp8.setNextTimeValuePair(7.1, 0);
    bp8.setNextTimeValuePair(8, 1);
    bp8.setNextTimeValuePair(8.1, 0);
    bp8.setStartAndEndTime(0, 9);



}

//------------------------------------------------------------------------------
void loop () {

//     if (sampleCount % (samplesPerSecond / 2) == 0) {
//         Serial.println("/////////////");
//         Serial.println("diagnostic output:");
// //         Serial.println("sample, value pairs");            
// //         for (int j=0; j < bp5.getCoordinateLength(); j++) {
// //             Serial.println(bp5.getSampleAtIndex(j));        
// //             Serial.println(bp5.getValueAtIndex(j));        
// //         }
// //         Serial.println("/////////////");
//         Serial.println("current sample count:");
//         Serial.println(sampleCount);
//         Serial.println("current sample value:");
//         Serial.println(bp5.floatAtSample(sampleCount));
//     }

    digitalWrite(pin1, bp1.floatAtSample(sampleCount)*HIGH);
    digitalWrite(pin2, bp2.floatAtSample(sampleCount)*HIGH);
    digitalWrite(pin3, bp3.floatAtSample(sampleCount)*HIGH);
    digitalWrite(pin4, bp4.floatAtSample(sampleCount)*HIGH);

    analogWrite(pin5, bp5.floatAtSample(sampleCount)*255);
    analogWrite(pin6, bp6.floatAtSample(sampleCount)*255);
    analogWrite(pin7, bp7.floatAtSample(sampleCount)*255);
    analogWrite(pin8, bp8.floatAtSample(sampleCount)*255);

    // loop increment
    sampleCount += 1;
    delayMicroseconds(sampleDurMicroseconds);

}