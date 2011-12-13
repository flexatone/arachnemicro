
#include <AMRandom.h>
#include <AMBPFlat.h>
#include <AMBPInterpolate.h>
#include <AMBPRandomChoice.h>
#include <AMBPRandomRange.h>
#include <AMAcquisition.h>

//------------------------------------------------------------------------------
// this is a demo for use with the demo board
// this uses the knob to change between 4 settings
// set pin 0 to be photo-resistor
// set pin 1 to be knob

//------------------------------------------------------------------------------
// temporal constants
int sampleDurMicroseconds = 1000; 
int samplesPerSecond = 1000000 / sampleDurMicroseconds; 
unsigned int sampleCount = 0;


//------------------------------------------------------------------------------
// objects

// one instance
AMRandom microRandom;

// create instances
AMAcquisition aq1(samplesPerSecond);
AMAcquisition aq2(samplesPerSecond);

// create objects
AMBPFlat bp1(samplesPerSecond);
AMBPFlat bp2(samplesPerSecond);
AMBPFlat bp3(samplesPerSecond);
AMBPFlat bp4(samplesPerSecond);

AMBPInterpolate bp5(samplesPerSecond);
AMBPRandomChoice bp6(samplesPerSecond);
AMBPRandomRange bp7(samplesPerSecond);
AMBPRandomRange bp8(samplesPerSecond);

AMBPRandomRange bp9(samplesPerSecond);




//------------------------------------------------------------------------------
// pin assignments
int pin1 = 4;
int pin2 = 5;
int pin3 = 6;
int pin4 = 7;

// all have pwm
int pin5 = 3;
int pin6 = 9;
int pin7 = 10;
int pin8 = 11;

float aq1Scalar1;
float aq1Scalar2;

//------------------------------------------------------------------------------
void setup() {
    
    //--------------------------------------------------------------------------
    // setup pins
    pinMode(pin1, OUTPUT);
    pinMode(pin2, OUTPUT);
    pinMode(pin3, OUTPUT);
    pinMode(pin4, OUTPUT);
    pinMode(pin5, OUTPUT);
    pinMode(pin6, OUTPUT);
    pinMode(pin7, OUTPUT);
    pinMode(pin8, OUTPUT);


    //--------------------------------------------------------------------------
    // acquisition objects
    aq1.setPin(0);
    aq1.setPinMinMax(200, 800);
    aq1.setTimeBetweenAquisitions(.030); // set time in seconds
    aq1.setNumberOfAquisitionsToAverage(8); 
    // set a very small min to avoid a zero normalized result
    aq1.setNextZoneBoundaries(0, .00001); // zone 0
    aq1.setNextZoneBoundaries(.00001, .2); // zone 1
    aq1.setNextZoneBoundaries(.2, .4); // zone 2
    aq1.setNextZoneBoundaries(.4, .6); // zone 3
    aq1.setNextZoneBoundaries(.6, .8); // zone 4
    aq1.setNextZoneBoundaries(.8, 1); // zone 5

    aq2.setPin(1);
    aq2.setPinMinMax(0, 1024);
    aq2.setTimeBetweenAquisitions(.100); // set time in seconds
    aq2.setNumberOfAquisitionsToAverage(1); // set to be immediate
    aq2.setNextZoneBoundaries(0, .25); // zone 0
    aq2.setNextZoneBoundaries(.25, .5); // zone 1
    aq2.setNextZoneBoundaries(.5, .75); // zone 1
    aq2.setNextZoneBoundaries(.75, 1); // zone 1

    //--------------------------------------------------------------------------
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


    bp5.setNextTimeValuePair(0, 0);
    bp5.setNextTimeValuePair(5, 1);
    bp5.setNextTimeValuePair(5.1, 0);
    bp5.setNextTimeValuePair(7, 1);
    bp5.setNextTimeValuePair(7.1, 0);
    bp5.setNextTimeValuePair(8, 1);
    bp5.setNextTimeValuePair(8.1, 0);
    bp5.setStartAndEndTime(0, 15);

    // bp6
    bp6.setNextOffsetValueBundle(1,2, 1.1, 1.05, 
                                 1, .9, .95, .85);

    bp6.setNextOffsetValueBundle(1,.9, 2, 1.05, 
                                 0.15, .1, .05, .1);


    // bp7
    bp7.setNextOffsetValueBundle(1, 2,  0, .1);
    bp7.setNextOffsetValueBundle(4, 8, .7, 1);
    // set triangle and mode w/n unit interval
    bp7.setRandomMethodAndParameters(AMRandomTriangle, 0.9);


    // this should favor shorter values
    bp8.setNextOffsetValueBundle(1, 2,  0, .1);
    bp8.setNextOffsetValueBundle(4, 8, .7, 1);
    // set triangle and mode w/n unit interval
    bp8.setRandomMethodAndParameters(AMRandomTriangle, 0.1);



    bp9.setNextOffsetValueBundle(1, 2,     1, 1);
    bp9.setNextOffsetValueBundle(2, 6,     0, 0);
    bp9.scaleTimeValues(.125);


}

//------------------------------------------------------------------------------
void loop() {

    //--------------------------------------------------------------------------
    // update aquisitions on each round
    aq1.updateAtSample(sampleCount);
    aq2.updateAtSample(sampleCount);

    aq1Scalar1 = aq1.getZoneNormalized(true);
    aq1Scalar2 = aq1.getZoneNormalized(false);

    if (aq2.getZone() == 0) {
        digitalWrite(pin1, bp9.floatAtSample(sampleCount) * HIGH);
        digitalWrite(pin2, bp9.floatAtSample(sampleCount) * HIGH);
        digitalWrite(pin3, bp9.floatAtSample(sampleCount) * HIGH);
        digitalWrite(pin4, bp9.floatAtSample(sampleCount) * HIGH);    
        // pwm
        // we use aq1 to scale the peak value
        analogWrite(pin5, bp9.floatAtSample(sampleCount) * 255 * aq1Scalar1);
        analogWrite(pin6, bp9.floatAtSample(sampleCount) * 255 * aq1Scalar1);
        analogWrite(pin7, bp9.floatAtSample(sampleCount) * 255 * aq1Scalar2);
        analogWrite(pin8, bp9.floatAtSample(sampleCount) * 255 * aq1Scalar2);

    }

    else if (aq2.getZone() == 1) {
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
    }

    else if (aq2.getZone() == 2) {
        // when bp is 0, will go to LOW
        digitalWrite(pin1, bp4.floatAtSample(sampleCount) * HIGH);
        digitalWrite(pin2, bp4.floatAtSample(sampleCount) * HIGH);
        digitalWrite(pin3, bp4.floatAtSample(sampleCount) * HIGH);
        digitalWrite(pin4, bp4.floatAtSample(sampleCount) * HIGH);
        analogWrite(pin5, bp4.floatAtSample(sampleCount)*255*aq1Scalar1);
        analogWrite(pin6, bp4.floatAtSample(sampleCount)*255*aq1Scalar1);
        analogWrite(pin7, bp4.floatAtSample(sampleCount)*255*aq1Scalar2);
        analogWrite(pin8, bp4.floatAtSample(sampleCount)*255*aq1Scalar2);
    }

    else if (aq2.getZone() == 3) {
        // when bp is 0, will go to LOW
        digitalWrite(pin1, bp9.floatAtSample(sampleCount) * HIGH);
        digitalWrite(pin2, bp9.floatAtSample(sampleCount) * HIGH);
        digitalWrite(pin3, bp9.floatAtSample(sampleCount) * HIGH);
        digitalWrite(pin4, bp9.floatAtSample(sampleCount) * HIGH);
        analogWrite(pin5, bp9.floatAtSample(sampleCount)*255);
        analogWrite(pin6, bp9.floatAtSample(sampleCount)*255);
        analogWrite(pin7, bp9.floatAtSample(sampleCount)*255);
        analogWrite(pin8, bp9.floatAtSample(sampleCount)*255);
    }
    //--------------------------------------------------------------------------
    // increment time range
    sampleCount += 1;
    delayMicroseconds(sampleDurMicroseconds);


} // end main loop