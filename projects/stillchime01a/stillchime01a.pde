#include <AMRandom.h>
#include <AMBPFlat.h>
#include <AMBPInterpolate.h>
#include <AMBPRandomChoice.h>
#include <AMBPRandomRange.h>
#include <AMAcquisition.h>

//------------------------------------------------------------------------------
// temporal constants
int sampleDurMicroseconds = 5000; 
int samplesPerSecond = 1000000 / sampleDurMicroseconds; 
unsigned int sampleCount = 0;

//------------------------------------------------------------------------------
// macro 1
// buzz
AMBPFlat bpfBuzzRhythmA(samplesPerSecond);
AMBPFlat bpfBuzzRhythmB(samplesPerSecond);
AMBPRandomChoice bprcBuzzRhythmC(samplesPerSecond);
AMBPRandomChoice bprcBuzzRhythmD(samplesPerSecond);
// servo
AMBPRandomChoice bprcServoRhythmA(samplesPerSecond);
AMBPRandomChoice bprcServoRhythmB(samplesPerSecond);

// macro 2
AMBPRandomRange bprrBuzzAccelA(samplesPerSecond);
AMBPRandomRange bprrBuzzAccelB(samplesPerSecond);
AMBPRandomRange bprcServoAccelA(samplesPerSecond);
AMBPRandomRange bprcServoAccelB(samplesPerSecond);

// photo
AMAcquisition aqPhoto(samplesPerSecond);

// led
AMBPInterpolate bpiLEDRedA(samplesPerSecond);
AMBPInterpolate bpiLEDGreenA(samplesPerSecond);
AMBPInterpolate bpiLEDBlueA(samplesPerSecond);

// define large scale form
AMBPRandomRange bprrFormSection(samplesPerSecond);
unsigned char bprrFormSection_n = 1;
AMBPRandomRange bprrFormMacro(samplesPerSecond);
unsigned char bprrFormMacro_n = 1;
AMBPRandomRange bprrFormTempoScale(samplesPerSecond);
unsigned char bprrFormTempoScale_n = 0;

//------------------------------------------------------------------------------
// storage variables
// buzz
int pin1 = 8;
int pin2 = 12;
int pin3 = 13;
int pin4 = 2;
// servos
int pin5 = 9;
int pin6 = 10;
// led
int pin7 = 11;
int pin8 = 3;
int pin9 = 5;

bool aqPhotoToggled = false; // establish two modes

//------------------------------------------------------------------------------
void setup() {
    //Serial.begin(9600);

    // buzz
    pinMode(pin1, OUTPUT);
    pinMode(pin2, OUTPUT);
    pinMode(pin3, OUTPUT);
    pinMode(pin4, OUTPUT);
    // servos
    pinMode(pin5, OUTPUT);
    pinMode(pin6, OUTPUT);
    pinMode(pin7, OUTPUT);
    // led
    pinMode(pin8, OUTPUT);
    pinMode(pin9, OUTPUT);

    // configurations
    bpfBuzzRhythmA.setModeAndDefault(AMModeLatch);
    // set some points
    bpfBuzzRhythmA.setNextTimeValuePair(0, 1);
    bpfBuzzRhythmA.setNextTimeValuePair(5, 0);
    bpfBuzzRhythmA.setNextTimeValuePair(6, 1);
    bpfBuzzRhythmA.setNextTimeValuePair(6.5, 0);
    bpfBuzzRhythmA.setNextTimeValuePair(8, 1);
    bpfBuzzRhythmA.setNextTimeValuePair(7.5, 0);
    bpfBuzzRhythmA.setNextTimeValuePair(9, 0);
    bpfBuzzRhythmA.setNextTimeValuePair(12, 1);
    // outer time range
    //bpfBuzzRhythmA.setStartAndEndTime(0, 20);
    // can set to sub-part of the whole, and dynamically change this
    bpfBuzzRhythmA.setStartAndEndTime(0, 13);


    bpfBuzzRhythmB.setModeAndDefault(AMModeLatch);
    bpfBuzzRhythmB.setNextTimeValuePair(0, 1);
    bpfBuzzRhythmB.setNextTimeValuePair(2/3., 0);
    bpfBuzzRhythmB.setNextTimeValuePair(1, 1);
    bpfBuzzRhythmB.setNextTimeValuePair(1+1/3., 0);
    bpfBuzzRhythmB.setNextTimeValuePair(2, 1);
    bpfBuzzRhythmB.setNextTimeValuePair(2+1/3., 0);
    bpfBuzzRhythmB.setNextTimeValuePair(3+2/3., 1);
    bpfBuzzRhythmB.setNextTimeValuePair(5+1/3., 0);
    bpfBuzzRhythmB.setStartAndEndTime(0, 7.00);
    bpfBuzzRhythmB.scaleTimeValues(2);

    bprcBuzzRhythmC.setModeAndDefault(AMModeLatch);
    // these values are times between next events: limit is 4
    bprcBuzzRhythmC.setNextOffsetValueBundle(.5, .5, 1, 1.5,    1, 1, 1, 1);
    bprcBuzzRhythmC.setNextOffsetValueBundle(1, 1, 1, 2,       0, 0, 0, 0);
    bprcBuzzRhythmC.setNextOffsetValueBundle(0.5, 1.5, 3, 1,   1, 1, 1, 1);
    bprcBuzzRhythmC.setNextOffsetValueBundle(2, 2.5, 8.5, 7,   0, 0, 0, 0);
    bprcBuzzRhythmC.scaleTimeValues(2);

    bprcBuzzRhythmD.setModeAndDefault(AMModeLatch);
    // these values are times between next events: limit is 4
    bprcBuzzRhythmD.setNextOffsetValueBundle(.25, .25, 1.25, .5,    1, 1, 1, 1);
    bprcBuzzRhythmD.setNextOffsetValueBundle(.25, .25, 1.25, .75,   0, 0, 0, 0);
    bprcBuzzRhythmD.setNextOffsetValueBundle(.25, 1, 3, 2.5,      1, 1, 1, 1);
    bprcBuzzRhythmD.setNextOffsetValueBundle(3, 2.5, 6, 5.75,     0, 0, 0, 0);



    // servos
    bprcServoRhythmB.setModeAndDefault(AMModeMomentary);
    // these values are times between next events: limit is 4
    bprcServoRhythmB.setNextOffsetValueBundle(.25, .25, 1, .5,   1, 1, 1, 1);
    bprcServoRhythmB.setNextOffsetValueBundle(.5, .5, .75, .5,   1, 1, 1, 1);
    bprcServoRhythmB.setNextOffsetValueBundle(.25, .25, .75, .5,   1, 1, 1, 1);
    bprcServoRhythmB.setNextOffsetValueBundle(1, 2.5, 3.5, 6,   1, 1, 1, 1);
    bprcServoRhythmB.scaleTimeValues(2);

    bprcServoRhythmA.setModeAndDefault(AMModeMomentary);
    bprcServoRhythmA.setNextOffsetValueBundle(.25, .25, .5, .25,  1, 1, 1, 1);
    bprcServoRhythmA.setNextOffsetValueBundle(.25, .25, .5, .75,  1, 1, 1, 1);
    bprcServoRhythmA.setNextOffsetValueBundle(.25, .25, 1, .75,   1, 1, 1, 1);
    bprcServoRhythmA.setNextOffsetValueBundle(1, 1.25, 3, 4.5,    1, 1, 1, 1);
    bprcServoRhythmA.scaleTimeValues(3); // a is slower

    // macro 2
    // buzz
    bprrBuzzAccelA.setModeAndDefault(AMModeLatch);
    bprrBuzzAccelA.setNextOffsetValueBundle(5, 12,  1, 1);
    bprrBuzzAccelA.setNextOffsetValueBundle(6, 8,  0, 0);
    bprrBuzzAccelA.setNextOffsetValueBundle(2, 5,  1, 1);
    bprrBuzzAccelA.setNextOffsetValueBundle(1, 3,  0, 0);
    bprrBuzzAccelA.setNextOffsetValueBundle(.25, 1.5,  1, 1);
    bprrBuzzAccelA.setNextOffsetValueBundle(.25, 1.25,  0, 0);
    bprrBuzzAccelA.setNextOffsetValueBundle(1, 5,  1, 1);
    bprrBuzzAccelA.setNextOffsetValueBundle(3, 8,  0, 0);

    bprrBuzzAccelB.setModeAndDefault(AMModeLatch);
    bprrBuzzAccelB.setNextOffsetValueBundle(6, 10,  1, 1);
    bprrBuzzAccelB.setNextOffsetValueBundle(3, 6,  0, 0);
    bprrBuzzAccelB.setNextOffsetValueBundle(1.5, 3,  1, 1);
    bprrBuzzAccelB.setNextOffsetValueBundle(.75, 1.5,  0, 0);
    bprrBuzzAccelB.setNextOffsetValueBundle(.5, .75,  1, 1);
    bprrBuzzAccelB.setNextOffsetValueBundle(.25, .5,  0, 0);
    bprrBuzzAccelB.setNextOffsetValueBundle(.125, .25,  1, 1);
    bprrBuzzAccelB.setNextOffsetValueBundle(.0625, .125,  0, 0);

    // servo
    bprcServoAccelA.setModeAndDefault(AMModeMomentary);
    bprcServoAccelA.setNextOffsetValueBundle(5, 10,  1, 1);
    bprcServoAccelA.setNextOffsetValueBundle(4, 6,  1, 1);
    bprcServoAccelA.setNextOffsetValueBundle(3, 4,  1, 1);
    bprcServoAccelA.setNextOffsetValueBundle(2, 3,  1, 1);
    bprcServoAccelA.setNextOffsetValueBundle(1, 2,  1, 1);
    bprcServoAccelA.setNextOffsetValueBundle(.5, 1,  1, 1);
    bprcServoAccelA.setNextOffsetValueBundle(.25, .5,  1, 1);
    bprcServoAccelA.setNextOffsetValueBundle(.5, 3,  1, 1);

    bprcServoAccelB.setModeAndDefault(AMModeMomentary);
    bprcServoAccelB.setNextOffsetValueBundle(7, 11,  1, 1);
    bprcServoAccelB.setNextOffsetValueBundle(4, 7,  1, 1);
    bprcServoAccelB.setNextOffsetValueBundle(3, 4,  1, 1);
    bprcServoAccelB.setNextOffsetValueBundle(2, 3,  1, 1);
    bprcServoAccelB.setNextOffsetValueBundle(1, 2,  1, 1);
    bprcServoAccelB.setNextOffsetValueBundle(.5, 1,  1, 1);
    bprcServoAccelB.setNextOffsetValueBundle(.25, 1,  1, 1);
    bprcServoAccelB.setNextOffsetValueBundle(.125, .25,  1, 1);



    // leds: set magnitude to max, but scale later in application
    // 7 is red
    bpiLEDRedA.setNextTimeValuePair(0, .05);
    bpiLEDRedA.setNextTimeValuePair(10, 1);
    bpiLEDRedA.setNextTimeValuePair(20, .05);
    bpiLEDRedA.setStartAndEndTime(0, 24);

    // 8 is green
    bpiLEDGreenA.setNextTimeValuePair(0, .05);
    bpiLEDGreenA.setNextTimeValuePair(6, 1);
    bpiLEDGreenA.setNextTimeValuePair(12, .05);
    bpiLEDGreenA.setStartAndEndTime(0, 15);

    // 9 is blue
    bpiLEDBlueA.setNextTimeValuePair(0, .1);
    bpiLEDBlueA.setNextTimeValuePair(20, 1);
    bpiLEDBlueA.setNextTimeValuePair(40, .1);
    bpiLEDBlueA.setStartAndEndTime(0, 40);

    //--------------------------------------------------------------------------
    aqPhoto.setPin(0);
    aqPhoto.setPinMinMax(20, 1000);
    aqPhoto.setTimeBetweenAquisitions(.25); // set time in seconds
    aqPhoto.setNumberOfAquisitionsToAverage(4); 
    aqPhoto.setNextZoneBoundaries(0, .2); // zone 0
    aqPhoto.setNextZoneBoundaries(.2, .4); // zone 1
    aqPhoto.setNextZoneBoundaries(.4, .6); // zone 2
    aqPhoto.setNextZoneBoundaries(.6, .8); // zone 3
    aqPhoto.setNextZoneBoundaries(.8, 1); // zone 4

    //--------------------------------------------------------------------------
    // configure large-scale formal sections
    // bprrFormMacro
    bprrFormMacro.setModeAndDefault(AMModeLatch);
    bprrFormMacro.setNextOffsetValueBundle(100, 120,  2, 2);
    bprrFormMacro.setNextOffsetValueBundle(100, 120,  1, 1);

    // bpFlatFormA: used for large-scale sections
    bprrFormSection.setModeAndDefault(AMModeLatch);
    bprrFormSection.setNextOffsetValueBundle(15, 25,  1, 1);
    bprrFormSection.setNextOffsetValueBundle(4, 10,   2, 2);
    bprrFormSection.setNextOffsetValueBundle(0, 4,    3, 3); // silence
    bprrFormSection.setNextOffsetValueBundle(8, 10,   4, 4);
    bprrFormSection.setNextOffsetValueBundle(4, 10,   5, 5);

    // bpFlatFormA: used for time scale; momementary
    bprrFormTempoScale.setModeAndDefault(AMModeMomentary);
    bprrFormTempoScale.setNextOffsetValueBundle(1, 6, 1, 1); // fast
    bprrFormTempoScale.setNextOffsetValueBundle(20, 30, 2, 2); // slow
    // this cause strange errors: not ready for use
    //bprrFormTempoScale.setRandomMethodAndParameters(AMRandomTriangle, 0.3);


}





//------------------------------------------------------------------------------
void loop () {
    aqPhoto.updateAtSample(sampleCount);

    bprrFormTempoScale_n = bprrFormTempoScale.intAtSample(sampleCount);
    bprrFormSection_n = bprrFormSection.intAtSample(sampleCount);
    bprrFormMacro_n = bprrFormMacro.intAtSample(sampleCount);

//     if (sampleCount % (samplesPerSecond * 1) == 0) {
//         Serial.print("///////////// ");
//         Serial.println("diagnostic output:");
//         Serial.print("bprrFormMacro: ");
//         Serial.println((int)bprrFormMacro_n);
//         Serial.print("bprrFormTempoScale_n: ");
//         Serial.println((int)bprrFormTempoScale_n);
//         Serial.print("bprrFormSection_n: ");
//         Serial.println((int)bprrFormSection_n);
//         Serial.print("aqPhoto.getZone(): ");
//         Serial.println(aqPhoto.getZone());
//         Serial.print("aqPhotoToggled: ");
//         Serial.println((int)aqPhotoToggled);
//     }

    //--------------------------------------------------------------------------
    // this only happens once every 10 to 15 seconds
    if (bprrFormTempoScale_n == 1) {
        // macro form 1
        bpfBuzzRhythmA.scaleTimeValues(.25);
        bpfBuzzRhythmB.scaleTimeValues(.25);
        //bprcBuzzRhythmC.scaleTimeValues(.75);
        bprcBuzzRhythmD.scaleTimeValues(.5);

        // macro form 2
        bprrBuzzAccelA.scaleTimeValues(2);
        bprrBuzzAccelB.scaleTimeValues(.5);
    }
    else if (bprrFormTempoScale_n == 2) {
        bpfBuzzRhythmA.scaleTimeValues(4);
        bpfBuzzRhythmB.scaleTimeValues(4);
        //bprcBuzzRhythmC.scaleTimeValues(1 + 1./3.);
        bprcBuzzRhythmD.scaleTimeValues(2);

        // macro form 2
        bprrBuzzAccelA.scaleTimeValues(.5);
        bprrBuzzAccelB.scaleTimeValues(2);
    }

    // only update these values when the the momentary switch has been turned
    // as momentary, this only happens once per interval
//     if (bprrFormTempoScale_n == 1 || bprrFormTempoScale_n == 2) {
//         // only update values based on aqusitions here
//         // if light is bright, increase shaker
//         if (aqPhoto.getZone() >= 3) {
//             if (! aqPhotoToggled) { // only do once
//                 // TODO: could change the analog write scalar of 
//                 // the servos as well!
//                 bprcServoRhythmA.scaleTimeValues(.25);
//                 bprcServoRhythmB.scaleTimeValues(.25);
//                 aqPhotoToggled = true;
//             }
//         } else {
//             if (aqPhotoToggled) { // only do if active
//                 bprcServoRhythmA.scaleTimeValues(4);
//                 bprcServoRhythmB.scaleTimeValues(4);
//                 aqPhotoToggled = false;
//             }
//         }
//     }

    //--------------------------------------------------------------------------
    // macro form 1
    if (bprrFormMacro_n == 1) {
        // formal conversions
        if (bprrFormSection_n <= 1) {
            // buzz
            digitalWrite(pin1, 
                bpfBuzzRhythmA.floatAtSample(sampleCount) * HIGH);
            digitalWrite(pin2, 
                bpfBuzzRhythmB.floatAtSample(sampleCount) * HIGH);
            digitalWrite(pin3, 
                bprcBuzzRhythmC.floatAtSample(sampleCount) * HIGH);
            digitalWrite(pin4, 
                bprcBuzzRhythmD.floatAtSample(sampleCount) * HIGH);
            // servos: can use both analog and digital write
            // w/ analog write, can control direction and speed by scaling value
            analogWrite(pin5, bprcServoRhythmB.floatAtSample(sampleCount) * 10);
            analogWrite(pin6, bprcServoRhythmA.floatAtSample(sampleCount) * 5);
            // led
            analogWrite(pin7, bpiLEDRedA.floatAtSample(sampleCount) * 120);
            analogWrite(pin8, bpiLEDGreenA.floatAtSample(sampleCount) * 120);
            analogWrite(pin9, bpiLEDBlueA.floatAtSample(sampleCount) * 255);
        }
    
        else if (bprrFormSection_n == 2) {
            // buzzers
            digitalWrite(pin2, bpfBuzzRhythmB.floatAtSample(
                        sampleCount) * HIGH);
            digitalWrite(pin4, bprcBuzzRhythmD.floatAtSample(
                        sampleCount) * HIGH);
            // servos
            analogWrite(pin5, 0);
            analogWrite(pin6, 0);
            // led
            analogWrite(pin7, 10 + (
                bpfBuzzRhythmB.floatAtSample(sampleCount) * 40));
            analogWrite(pin8, 60 + (
                bprcBuzzRhythmD.floatAtSample(sampleCount) * 60));
            analogWrite(pin9, 120); //b

        }
        else if (bprrFormSection_n == 3) {
            // servos
            analogWrite(pin5, 0);
            analogWrite(pin6, 0);
            // led
            analogWrite(pin7, 0); //r
            analogWrite(pin8, 0); //g
            analogWrite(pin9, 0); //b
        }
        else if (bprrFormSection_n == 4) {
            // buzzers
            digitalWrite(pin1, bpfBuzzRhythmA.floatAtSample(sampleCount) * HIGH);
            digitalWrite(pin3, bprcBuzzRhythmC.floatAtSample(sampleCount) * HIGH);
            // servos: one servo active
            analogWrite(pin5, 0);
            analogWrite(pin6, bprcServoRhythmA.floatAtSample(sampleCount) * 5);
            // led
            analogWrite(pin7, 10); //r
            analogWrite(pin8, 10 + (
                bpfBuzzRhythmA.floatAtSample(sampleCount) * 90));
            analogWrite(pin9, 80 + (
                bprcBuzzRhythmC.floatAtSample(sampleCount) * 60));
        }
        else if (bprrFormSection_n == 5) {
            // only servos alone
            analogWrite(pin5, bprcServoRhythmB.floatAtSample(sampleCount) * 10);
            analogWrite(pin6, bprcServoRhythmA.floatAtSample(sampleCount) * 5);
            // led
            analogWrite(pin7, 20); //r
            analogWrite(pin8, 10 + (
                bprcServoRhythmB.floatAtSample(sampleCount) * 60));
            analogWrite(pin9, 160 + (
                bprcServoRhythmA.floatAtSample(sampleCount) * 90));
        }
    }
    //--------------------------------------------------------------------------
    // macro form 2
    else if (bprrFormMacro_n == 2) {
        if (bprrFormSection_n <= 3) {
            // use rhythms to select which pin is driven for accel rhythm
            if (bprcBuzzRhythmC.floatAtSample(sampleCount) > .5) {
                digitalWrite(pin1, bprrBuzzAccelA.floatAtSample(sampleCount) * HIGH);
            } else {
                digitalWrite(pin2, bprrBuzzAccelA.floatAtSample(sampleCount) * HIGH);
            }
            if (bprcBuzzRhythmD.floatAtSample(sampleCount) > .5) {
                digitalWrite(pin3, bprrBuzzAccelB.floatAtSample(sampleCount) * HIGH);
            } else {
                digitalWrite(pin4, bprrBuzzAccelB.floatAtSample(sampleCount) * HIGH);
            }
            // servos
            analogWrite(pin5, bprcServoAccelA.floatAtSample(sampleCount) * 10);
            analogWrite(pin6, bprcServoAccelB.floatAtSample(sampleCount) * 5);
            // led
            analogWrite(pin7, 30 + (
                bpiLEDRedA.floatAtSample(sampleCount) * 225));
            analogWrite(pin8, bpiLEDGreenA.floatAtSample(sampleCount) * 20);
            analogWrite(pin9, bpiLEDBlueA.floatAtSample(sampleCount) * 20);
        }
        else {
            // servos
            analogWrite(pin5, 0);
            analogWrite(pin6, 0);
            // led
            analogWrite(pin7, 30 + (
                bpiLEDRedA.floatAtSample(sampleCount) * 225));
            analogWrite(pin8, bpiLEDGreenA.floatAtSample(sampleCount) * 20);
            analogWrite(pin9, bpiLEDBlueA.floatAtSample(sampleCount) * 20);
        }

    }

    //--------------------------------------------------------------------------
    // increment time range
    sampleCount += 1;
    delayMicroseconds(sampleDurMicroseconds);


}



