
#include <AMRandom.h>
#include <AMBPFlat.h>


// testing controlling 8 LED on outputs 
// standard: 4,5,6,7,
// pwm: 3, 9, 10, 11
// using testing board
// timing controls
// 1000 microseconds per ms, 1 mil per second
// not that the sampling rate of 44.1k audio is about 23 microseconds
// through experimentation, 500 mu is the smallest value w/o incurring delay
// can do 1000 mus w/ any problem; might be better as less calculation
int sampleDurMicroseconds = 1000; 
int samplesPerSecond = 1000000 / sampleDurMicroseconds; 
unsigned int sampleCount = 0;

// one instance
AMRandom microRandom;

// create instances
AMBPFlat bp1(samplesPerSecond);
AMBPFlat bp2(samplesPerSecond);
AMBPFlat bp3(samplesPerSecond);
AMBPFlat bp4(samplesPerSecond);
// 
AMBPFlat bp5(samplesPerSecond);
AMBPFlat bp6(samplesPerSecond);
AMBPFlat bp7(samplesPerSecond);
AMBPFlat bp8(samplesPerSecond);

// the limit is presently 4 more of these
AMBPFlat bp11(samplesPerSecond);
AMBPFlat bp12(samplesPerSecond);
AMBPFlat bp13(samplesPerSecond);
AMBPFlat bp14(samplesPerSecond);


int pin1 = 4;
int pin2 = 5;
int pin3 = 6;
int pin4 = 7;

// all have pwm
int pin5 = 3;
int pin6 = 9;
int pin7 = 10;
int pin8 = 11;

//------------------------------------------------------------------------------
void setup() {
    
//  Serial.begin(9600);

    // setup pins
    pinMode(pin1, OUTPUT);
    pinMode(pin2, OUTPUT);
    pinMode(pin3, OUTPUT);
    pinMode(pin4, OUTPUT);
    pinMode(pin5, OUTPUT);
    pinMode(pin6, OUTPUT);
    pinMode(pin7, OUTPUT);
    pinMode(pin8, OUTPUT);

    // configurations
    bp1.setModeAndDefault(AMModeLatch);
    //bp1.setModeAndDefault(AMModeMomentary, 0.0);
    bp1.setNextTimeValuePair(0, 1);
    bp1.setNextTimeValuePair(1, 0);
    bp1.setStartAndEndTime(0, 2); // have tested range at 60, 120s

    bp2.setModeAndDefault(AMModeLatch);
    bp2.setNextTimeValuePair(0, 1);
    bp2.setNextTimeValuePair(2, 0);
    bp2.setStartAndEndTime(0, 3);

    // simple on/off over 2 seconds; but then scale time value
    bp3.setModeAndDefault(AMModeLatch);
    bp3.setNextTimeValuePair(0, 1);
    bp3.setNextTimeValuePair(1, 0);
    bp3.setStartAndEndTime(0, 2);
    bp3.scaleTimeValues(.125);

    bp4.setModeAndDefault(AMModeLatch);
    bp4.setNextTimeValuePair(0, 1);
    bp4.setNextTimeValuePair(1, 0);
    bp4.setStartAndEndTime(0, 2);
    bp4.scaleTimeValues(0.015625);




//     // pwm
    bp5.setModeAndDefault(AMModeLatch);
    bp5.setNextTimeValuePair(0, 0);
    bp5.setNextTimeValuePair(1, .1);
    bp5.setNextTimeValuePair(2, .2);
    bp5.setNextTimeValuePair(3, .3);
    bp5.setNextTimeValuePair(4, .4);
    bp5.setNextTimeValuePair(5, .5);
    bp5.setNextTimeValuePair(6, .6);
    bp5.setNextTimeValuePair(7, .7);
    bp5.setNextTimeValuePair(8, .8);
    bp5.setNextTimeValuePair(9, .9);
    bp5.setNextTimeValuePair(10, 1);
    bp5.setNextTimeValuePair(11, .9);
    bp5.setNextTimeValuePair(12, .8);
    bp5.setNextTimeValuePair(13, .7);
    bp5.setNextTimeValuePair(14, .6);
    bp5.setNextTimeValuePair(15, .5);
    bp5.setNextTimeValuePair(16, .4);
    bp5.setNextTimeValuePair(17, .3);
    bp5.setNextTimeValuePair(18, .2);
    bp5.setNextTimeValuePair(19, .1);
    bp5.setStartAndEndTime(0, 20);
    bp5.scaleTimeValues(0.125);


    bp6.setModeAndDefault(AMModeLatch);
    bp6.setNextTimeValuePair(0, 0);
    bp6.setNextTimeValuePair(1, .1);
    bp6.setNextTimeValuePair(2, .2);
    bp6.setNextTimeValuePair(3, .3);
    bp6.setNextTimeValuePair(4, .4);
    bp6.setNextTimeValuePair(5, .5);
    bp6.setNextTimeValuePair(6, .6);
    bp6.setNextTimeValuePair(7, .7);
    bp6.setNextTimeValuePair(8, .8);
    bp6.setNextTimeValuePair(9, .9);
    bp6.setNextTimeValuePair(10, 1);
    bp6.setNextTimeValuePair(11, .9);
    bp6.setNextTimeValuePair(12, .8);
    bp6.setNextTimeValuePair(13, .7);
    bp6.setNextTimeValuePair(14, .6);
    bp6.setNextTimeValuePair(15, .5);
    bp6.setNextTimeValuePair(16, .4);
    bp6.setNextTimeValuePair(17, .3);
    bp6.setNextTimeValuePair(18, .2);
    bp6.setNextTimeValuePair(19, .1);
    bp6.setStartAndEndTime(0, 20);
    bp6.scaleTimeValues(0.1);

    bp7.setModeAndDefault(AMModeLatch);
    bp7.setNextTimeValuePair(0, 0);
    bp7.setNextTimeValuePair(1, .1);
    bp7.setNextTimeValuePair(2, .2);
    bp7.setNextTimeValuePair(3, .3);
    bp7.setNextTimeValuePair(4, .4);
    bp7.setNextTimeValuePair(5, .5);
    bp7.setNextTimeValuePair(6, .6);
    bp7.setNextTimeValuePair(7, .7);
    bp7.setNextTimeValuePair(8, .8);
    bp7.setNextTimeValuePair(9, .9);
    bp7.setNextTimeValuePair(10, 1);
    bp7.setNextTimeValuePair(11, .9);
    bp7.setNextTimeValuePair(12, .8);
    bp7.setNextTimeValuePair(13, .7);
    bp7.setNextTimeValuePair(14, .6);
    bp7.setNextTimeValuePair(15, .5);
    bp7.setNextTimeValuePair(16, .4);
    bp7.setNextTimeValuePair(17, .3);
    bp7.setNextTimeValuePair(18, .2);
    bp7.setNextTimeValuePair(19, .1);
    bp7.setStartAndEndTime(0, 20);
    bp7.scaleTimeValues(0.01);

    bp8.setModeAndDefault(AMModeLatch);
    bp8.setNextTimeValuePair(0, 0);
    bp8.setNextTimeValuePair(1, .1);
    bp8.setNextTimeValuePair(2, .2);
    bp8.setNextTimeValuePair(3, .3);
    bp8.setNextTimeValuePair(4, .4);
    bp8.setNextTimeValuePair(5, .5);
    bp8.setNextTimeValuePair(6, .6);
    bp8.setNextTimeValuePair(7, .7);
    bp8.setNextTimeValuePair(8, .8);
    bp8.setNextTimeValuePair(9, .9);
    bp8.setNextTimeValuePair(10, 1);
    bp8.setNextTimeValuePair(11, .9);
    bp8.setNextTimeValuePair(12, .8);
    bp8.setNextTimeValuePair(13, .7);
    bp8.setNextTimeValuePair(14, .6);
    bp8.setNextTimeValuePair(15, .5);
    bp8.setNextTimeValuePair(16, .4);
    bp8.setNextTimeValuePair(17, .3);
    bp8.setNextTimeValuePair(18, .2);
    bp8.setNextTimeValuePair(19, .1);
    bp8.setStartAndEndTime(0, 20);
    bp8.scaleTimeValues(0.04);




}

//------------------------------------------------------------------------------
void loop() {

//     if (sampleCount % samplesPerSecond == 0) {
//         Serial.println("/////////////");
//         Serial.println("diagnostic output:");
//         Serial.println("sample, value pairs");            
//         for (int j=0; j < bp5.getCoordinateLength(); j++) {
//             Serial.println(bp5.getSampleAtIndex(j));        
//             Serial.println(bp5.getValueAtIndex(j));        
//         }
//         Serial.println("/////////////");
//         Serial.println("sampleStart");
//         Serial.println(bp5.getSampleStart()); 
//         Serial.println("sampleEnd");
//         Serial.println(bp5.getSampleEnd()); 
// 
//         Serial.println("/////////////");
//         Serial.println("current sample count");
//         Serial.println(sampleCount);
//         Serial.println("/////////////");    
//     }


    // when bp is 0, will go to LOW
    digitalWrite(pin1, bp1.floatAtSample(sampleCount) * HIGH);
    digitalWrite(pin2, bp2.floatAtSample(sampleCount) * HIGH);
    digitalWrite(pin3, bp3.floatAtSample(sampleCount) * HIGH);

    digitalWrite(pin4, bp4.floatAtSample(sampleCount) * 
                       bp1.floatAtSample(sampleCount) * 
                       HIGH);

    // pwm
    analogWrite(pin5, bp5.floatAtSample(sampleCount)*255);
    analogWrite(pin6, bp6.floatAtSample(sampleCount)*255);
    analogWrite(pin7, bp7.floatAtSample(sampleCount)*255);
    analogWrite(pin8, bp8.floatAtSample(sampleCount)*255);


    sampleCount += 1;
    delayMicroseconds(sampleDurMicroseconds);


} // end main loop