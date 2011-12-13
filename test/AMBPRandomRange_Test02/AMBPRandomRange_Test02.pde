
#include <AMRandom.h>
#include <AMBPInterpolate.h>
#include <AMBPRandomRange.h>


int sampleDurMicroseconds = 1000; 
int samplesPerSecond = 1000000 / sampleDurMicroseconds; 
unsigned int sampleCount = 0;

// one instance
AMRandom microRandom;

// create instances
AMBPRandomRange bp1(samplesPerSecond);
AMBPRandomRange bp2(samplesPerSecond);
AMBPRandomRange bp3(samplesPerSecond);
AMBPRandomRange bp4(samplesPerSecond);

AMBPRandomRange bp5(samplesPerSecond);
AMBPRandomRange bp6(samplesPerSecond);
AMBPRandomRange bp7(samplesPerSecond);
AMBPRandomRange bp8(samplesPerSecond);


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
    //Serial.begin(9600);

    pinMode(pin1, OUTPUT);
    pinMode(pin2, OUTPUT);
    pinMode(pin3, OUTPUT);
    pinMode(pin4, OUTPUT);
    pinMode(pin5, OUTPUT);
    pinMode(pin6, OUTPUT);
    pinMode(pin7, OUTPUT);
    pinMode(pin8, OUTPUT);

    // set some points

    // constant time, dynamic values
    bp1.setNextOffsetValueBundle(1, 2,     1, 1);
    bp1.setNextOffsetValueBundle(2, 6,     0, 0);
    bp1.scaleTimeValues(.125);

    bp2.setNextOffsetValueBundle(1, 2,     1, 1);
    bp2.setNextOffsetValueBundle(2, 6,     0, 0);
    bp2.scaleTimeValues(.125);

    bp3.setNextOffsetValueBundle(1, 2,     1, 1);
    bp3.setNextOffsetValueBundle(2, 6,     0, 0);
    bp3.scaleTimeValues(.125);

    bp4.setNextOffsetValueBundle(1, 2,     1, 1);
    bp4.setNextOffsetValueBundle(2, 6,     0, 0);
    bp4.scaleTimeValues(.125);





    // continuous pwm values
    bp5.setNextOffsetValueBundle(1, 2,  0, .2);
    bp5.setNextOffsetValueBundle(2, 3, .2, .4);
    bp5.setNextOffsetValueBundle(3, 4, .4, .6);
    bp5.setNextOffsetValueBundle(4, 5, .6, .8);
    bp5.setNextOffsetValueBundle(5, 6, .8, 1);
    bp5.scaleTimeValues(.25);

    bp6.setNextOffsetValueBundle(1, 2,  0, .2);
    bp6.setNextOffsetValueBundle(2, 3, .2, .4);
    bp6.setNextOffsetValueBundle(3, 4, .4, .6);
    bp6.setNextOffsetValueBundle(4, 5, .6, .8);
    bp6.setNextOffsetValueBundle(5, 6, .8, 1);
    bp6.scaleTimeValues(.25);


    bp7.setNextOffsetValueBundle(1, 2,  0, .1);
    bp7.setNextOffsetValueBundle(4, 8, .7, 1);
    // set triangle and mode w/n unit interval
    bp7.setRandomMethodAndParameters(AMRandomTriangle, 0.9);

    // this should favor shorter values
    bp8.setNextOffsetValueBundle(1, 2,  0, .1);
    bp8.setNextOffsetValueBundle(4, 8, .7, 1);
    // set triangle and mode w/n unit interval
    bp8.setRandomMethodAndParameters(AMRandomTriangle, 0.1);

    // dynamic time, constant values



}

//------------------------------------------------------------------------------
void loop () {

    digitalWrite(pin1, bp1.floatAtSample(sampleCount)*HIGH);
    digitalWrite(pin2, bp2.floatAtSample(sampleCount)*HIGH);
    digitalWrite(pin3, bp3.floatAtSample(sampleCount)*HIGH);
    digitalWrite(pin4, bp4.floatAtSample(sampleCount)*HIGH);
// 
    analogWrite(pin5, bp5.floatAtSample(sampleCount)*255);
    analogWrite(pin6, bp6.floatAtSample(sampleCount)*255);
    analogWrite(pin7, bp7.floatAtSample(sampleCount)*255);
    analogWrite(pin8, bp8.floatAtSample(sampleCount)*255);

    // loop increment
    sampleCount += 1;
    delayMicroseconds(sampleDurMicroseconds);

}