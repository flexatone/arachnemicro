
#include <AMRandom.h>
#include <AMBPInterpolate.h>
#include <AMBPRandomChoice.h>


int sampleDurMicroseconds = 1000; 
int samplesPerSecond = 1000000 / sampleDurMicroseconds; 
unsigned int sampleCount = 0;

// one instance
AMRandom microRandom;

// create instances
AMBPRandomChoice bp1(samplesPerSecond);
AMBPRandomChoice bp2(samplesPerSecond);
AMBPRandomChoice bp3(samplesPerSecond);
AMBPRandomChoice bp4(samplesPerSecond);

AMBPRandomChoice bp5(samplesPerSecond);
AMBPRandomChoice bp6(samplesPerSecond);
AMBPRandomChoice bp7(samplesPerSecond);
AMBPRandomChoice bp8(samplesPerSecond);


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
    bp1.setNextOffsetValueBundle(1, 1, 2, 1, 
                                 0, 0, 0, 0);
    bp1.setNextOffsetValueBundle(1, 1, 2, 3, 
                                 1, 1, 1, 1);
    bp1.setNextOffsetValueBundle(1, 2, 3, 4, 
                                 0, 0, 0, 0);
    bp1.setNextOffsetValueBundle(1, 2, 4, 6, 
                                 1, 1, 1, 1);
    bp1.scaleTimeValues(.125);


    bp2.setNextOffsetValueBundle(1, 1, 2, 8, 
                                 0, 0, 0, 0);
    bp2.setNextOffsetValueBundle(1, 1, 2, 3, 
                                 1, 1, 1, 1);
    bp2.setNextOffsetValueBundle(1, 2, 3, 4, 
                                 0, 0, 0, 0);
    bp2.setNextOffsetValueBundle(1, 2, 4, 6, 
                                 1, 1, 1, 1);
    bp2.scaleTimeValues(.125);


    bp3.setNextOffsetValueBundle(1, 1, 2, 8, 
                                 0, 0, 0, 0);
    bp3.setNextOffsetValueBundle(1, 1, 2, 3, 
                                 1, 1, 1, 1);
    bp3.setNextOffsetValueBundle(1, 1, 12, 4, 
                                 0, 0, 0, 0);
    bp3.setNextOffsetValueBundle(1, 16, 4, 24, 
                                 1, 1, 1, 1);
    bp3.scaleTimeValues(0.03125);


    bp4.setNextOffsetValueBundle(1, 1, 2, 8, 
                                 0, 0, 0, 0);
    bp4.setNextOffsetValueBundle(1, 1, 2, 3, 
                                 1, 1, 1, 1);
    bp4.setNextOffsetValueBundle(1, 2, 3, 4, 
                                 0, 0, 0, 0);
    bp4.setNextOffsetValueBundle(1, 2, 4, 6, 
                                 1, 1, 1, 1);
    bp4.scaleTimeValues(0.03125);



    // continuous pwm values
    bp5.setNextOffsetValueBundle(2, 2.5, 2, 2, 
                                 .5, .4, .6, .5);

    bp5.setNextOffsetValueBundle(8, 8, 8.5, 7.8, 
                                 1, .9, .9, .95);

    bp5.setNextOffsetValueBundle(1, 1, 1, 8, 
                                 0, 0, .1, 0);



    bp6.setNextOffsetValueBundle(1,2, 1.1, 1.05, 
                                 1, .9, .95, .85);

    bp6.setNextOffsetValueBundle(1,.9, 2, 1.05, 
                                 0.15, .1, .05, .1);

    // dynamic time, constant values
    bp7.setNextOffsetValueBundle(1, 2, 1.1, .9, 
                                 0, 0, 0, 0);
    bp7.setNextOffsetValueBundle(1, 2, 1.1, .9, 
                                 .2, .2, .2, .2);
    bp7.setNextOffsetValueBundle(1, 2, 1.1, .9, 
                                 .4, .4, .4, .4);
    bp7.setNextOffsetValueBundle(1, 3, 1.1, .9, 
                                 .6, .6, .6, .6);
    bp7.setNextOffsetValueBundle(1, 4, 1.1, .9, 
                                 .8, .8, .8, .8);
    bp7.setNextOffsetValueBundle(1, 5, 1.1, .9, 
                                 1, 1, 1, 1);


    // constant time, dynamic values
    bp8.setNextOffsetValueBundle(1, 1, 1, 1, 
                                 0, 0, 0, 0);
    bp8.setNextOffsetValueBundle(1, 1, 1, 1, 
                                 .2, .2, .2, 1);
    bp8.setNextOffsetValueBundle(1, 1, 1, 1, 
                                 .4, .4, .4, 1);
    bp8.setNextOffsetValueBundle(1, 1, 1, 1, 
                                 .6, .6, .6, 1);
    bp8.setNextOffsetValueBundle(1, 1, 1, 1, 
                                 .8, .8, .8, 0);
    bp8.setNextOffsetValueBundle(1, 1, 1, 1, 
                                 1, 1, 1, 0);





}

//------------------------------------------------------------------------------
void loop () {

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