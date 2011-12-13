// AMRandom


#ifndef AM_RANDOM
#define AM_RANDOM

#include "WProgram.h"

// -----------------------------------------------------------------------------
class AMRandom {
public:
    // constructor with a default argument
    AMRandom(unsigned char pin=5); 

    // methods
    long uniformLong();
    long uniformLong(int min, int max);

    float uniformFloat();
    float uniformFloat(float min, float max);

    float noiseFloat();

    float triangleFloat(float min, float max, float mode=.5);
    long triangleLong(float min, float max, float mode=.5);

    float gaussFloat(float mu, float sigma);

//     float gammaFloat(float a, float b);
//     float betaFloat(float a, float b);
//     long betaLong(int min, int max);


private:
    // in c++, this is an unsigned char, giving 0 to 255?
    // arduino uses byte
    unsigned char pin_;
};

#endif

