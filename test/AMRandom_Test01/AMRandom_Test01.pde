
#include <AMRandom.h>


AMRandom microRandom;


int sampleDurMicroseconds = 1000; 
int samplesPerSecond = 1000000 / sampleDurMicroseconds; 
unsigned int sampleCount = 0;

// variabels
int xInt;
float x;

//------------------------------------------------------------------------------
void setup() {
    Serial.begin(9600);
}

//------------------------------------------------------------------------------
void loop () {

    if (sampleCount % (samplesPerSecond * 1) == 0) {

        Serial.println("uniformLong(1, 3): ");
        for (int i=0; i < 10; i++) {
            // inclusive boundaries
            xInt = microRandom.uniformLong(1, 3);
            Serial.print(xInt);
            Serial.print("  ");
            if (xInt < 1 || xInt > 3) Serial.println("ERROR");    
        }
        Serial.println("");    

        Serial.println("uniformLong(): with no arguments returns 0/1");
        for (int i=0; i < 10; i++) {
            // get zero or 1
            xInt = microRandom.uniformLong();
            Serial.print(xInt);
            Serial.print("  ");
            if (xInt < 0 || xInt > 1) Serial.println("ERROR");    
        }
        Serial.println("");    
    
        // get float between 0 and 1
        Serial.println("uniformFloat()");
        for (int i=0; i < 10; i++) {
            x = microRandom.uniformFloat();
            Serial.print(x);
            Serial.print("  ");
            if (x < 0 || x > 1) Serial.println("ERROR");
        }
        Serial.println("");    

        Serial.println("uniformFloat(1.0, 99.0)");
        for (int i=0; i < 10; i++) {
            x = microRandom.uniformFloat(1.0, 99.0);
            Serial.print(x);
            Serial.print("  ");
            if (x < 1 || x > 99) Serial.println("ERROR");
        }
        Serial.println("");    



        Serial.println("gaussFloat(0.5, 1.0)");
        for (int i=0; i < 10; i++) {
            x = microRandom.gaussFloat(0.5, 1.0);
            Serial.print(x);
            Serial.print("  ");
        }
        Serial.println("");    


        Serial.println("triangleFloat(0.0, 1.0)");
        for (int i=0; i < 10; i++) {
            x = microRandom.triangleFloat(0.0, 1.0);
            Serial.print(x);
            Serial.print("  ");
        }
        Serial.println("");    


        Serial.println("triangleFloat(0.0, 1.0, 1.0)");
        for (int i=0; i < 10; i++) {
            x = microRandom.triangleFloat(0.0, 1.0, 1.0);
            Serial.print(x);
            Serial.print("  ");
        }
        Serial.println("");    


        Serial.println("triangleFloat(5.0, 6.0, 5.0)");
        for (int i=0; i < 10; i++) {
            x = microRandom.triangleFloat(5.0, 6.0, 5.0);
            Serial.print(x);
            Serial.print("  ");
        }
        Serial.println("");    


        Serial.println("triangleLong(100, 200, 180)");
        for (int i=0; i < 10; i++) {
            Serial.print(microRandom.triangleLong(100, 200, 180));
            Serial.print("  ");
        }
        Serial.println("");    

        Serial.println("triangleLong(5, 7, 5)");
        for (int i=0; i < 10; i++) {
            Serial.print(microRandom.triangleLong(5, 7, 5));
            Serial.print("  ");
        }
        Serial.println("");    

    
        Serial.println("noiseFloat():");
        // still experimental
        for (int i=0; i < 10; i++) {    
            x = microRandom.noiseFloat();
            Serial.print(x);
            Serial.print("  ");
        }
        Serial.println("");    
        Serial.println("");    

    }

    // time increment
    sampleCount += 1;
    delayMicroseconds(sampleDurMicroseconds);


}