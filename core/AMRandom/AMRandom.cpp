// AMRandom

#include "WProgram.h"
#include "AMRandom.h"


#define TWO_PI 6.2831853071795862



// constructor
// possible assign one or more random pin to read values from 
// pass a pin arugment or None?
// could offer alternative random
// -----------------------------------------------------------------------------
AMRandom::AMRandom(unsigned char pin) {
    // use a pin as a source of randomness
    this->pin_ = pin;
    // set seed on each initialization
    randomSeed(analogRead(pin_));
}


// -----------------------------------------------------------------------------
//! Return a random integer with inclusive min and max values
long AMRandom::uniformLong(int min, int max) {
    return random(min, max+1); // max is exclusive, add one to include it
}

//! Return a random integer with between 1 and zero
long AMRandom::uniformLong() {
    return random(0, 2);  // return 0/1
}

// -----------------------------------------------------------------------------
//! Return a random uniform floating point value between zero and 1
float AMRandom::uniformFloat() {
    // cannot use unsigned duration
    // >>> 1. / 4294967295
    // 2.3283064370807974e-10

    //  -2,147,483,648 to 2,147,483,647
    // >>> 1/ 2147483647.
    // 4.6566128752457969e-10

    // this approach does not work
    //return (random(-2147483648, 2147483647) + 2147483648) * 2.32830643E-10;  

    // this works but only uses half of range
    return random(0, 2147483647) * 4.656612875E-10;  
}

float AMRandom::uniformFloat(float min, float max) {
    return min + (uniformFloat() * (max-min));
}


// -----------------------------------------------------------------------------
//! Return a random value from an analog pin
float AMRandom::noiseFloat() {
    // these values are not very random; mostly in range of 236 to 250
    // values should be between 0 and 1, thus  scale 
    // >>> 1/1024.
    // 0.0009765625
    return analogRead(pin_) * 0.0009765625;
}




// -----------------------------------------------------------------------------
float AMRandom::gaussFloat(float mu, float sigma) {
    // mu is the mean, sigma is the variance
    // this seems to work na be correct; the problem is that the values
    // are hard to control within a fixed range

    // based on the box muller algorithm, as defined here:
    // ftp://ftp.taygeta.com/pub/c/boxmuller.c
	float x1, x2, w, y1;
	static float y2;
	static int useLast = 0;
	if (useLast) {
		y1 = y2;
		useLast = 0;
	} else {
		do {
			x1 = 2.0 * uniformFloat() - 1.0;
			x2 = 2.0 * uniformFloat() - 1.0;
			w = x1 * x1 + x2 * x2;
		} while (w >= 1.0);

		w = sqrt( (-2.0 * log( w ) ) / w );
		y1 = x1 * w;
		y2 = x2 * w;
		useLast = 1;
	}

    // not sure if sqrt here is required
	return mu + (sqrt(sigma) * y1);
}



float AMRandom::triangleFloat(float min, float max, float mode) {
    // symmetrical triangle distribution
    //return min + ((max-min)*(uniformFloat()+uniformFloat())/2.0);

    // from: http://www.daniweb.com/software-development/python/threads/164989
    float t = (mode-min) / (max-min);
    float y = sqrt(uniformFloat());

    float d = 0.0;
    if (uniformFloat() < t) {
        d = min;
    } else {
        d = max;
    }
    return d + (mode - d) * y;
}


long AMRandom::triangleLong(float min, float max, float mode) {
    // round to the nearest long
    return (long) lround(triangleFloat(min, max, mode));
}

// alternative triangle
// c is mode
// def triangular(a, c, b):
//   c = float(c)
//   t = (c-a)/(b-a)
//   y = sqrt(random())
//   d = a if random() < t else b
//   return d + (c-d) * y


// u=rnd()
// if u <= (mode-min)/(max-min) then
//   r=min+sqrt(u*(max-min)*(mode-min))
// else
//   r=max-sqrt((1-u)*(max-min)*(max-mode))
// end if


// -----------------------------------------------------------------------------







//     def gammavariate(self, alpha, beta):
//         """Gamma distribution.  Not the gamma function!
// 
//         Conditions on the parameters are alpha > 0 and beta > 0.
// 
//         """
// 
//         # alpha > 0, beta > 0, mean is alpha*beta, variance is alpha*beta**2
// 
//         # Warning: a few older sources define the gamma distribution in terms
//         # of alpha > -1.0
//         if alpha <= 0.0 or beta <= 0.0:
//             raise ValueError, 'gammavariate: alpha and beta must be > 0.0'
// 
//         random = self.random
//         if alpha > 1.0:
// 
//             # Uses R.C.H. Cheng, "The generation of Gamma
//             # variables with non-integral shape parameters",
//             # Applied Statistics, (1977), 26, No. 1, p71-74
// 
//             ainv = _sqrt(2.0 * alpha - 1.0)
//             bbb = alpha - LOG4
//             ccc = alpha + ainv
// 
//             while 1:
//                 u1 = random()
//                 if not 1e-7 < u1 < .9999999:
//                     continue
//                 u2 = 1.0 - random()
//                 v = _log(u1/(1.0-u1))/ainv
//                 x = alpha*_exp(v)
//                 z = u1*u1*u2
//                 r = bbb+ccc*v-x
//                 if r + SG_MAGICCONST - 4.5*z >= 0.0 or r >= _log(z):
//                     return x * beta
// 
//         elif alpha == 1.0:
//             # expovariate(1)
//             u = random()
//             while u <= 1e-7:
//                 u = random()
//             return -_log(u) * beta
// 
//         else:   # alpha is between 0 and 1 (exclusive)
// 
//             # Uses ALGORITHM GS of Statistical Computing - Kennedy & Gentle
// 
//             while 1:
//                 u = random()
//                 b = (_e + alpha)/_e
//                 p = b*u
//                 if p <= 1.0:
//                     x = p ** (1.0/alpha)
//                 else:
//                     x = -_log((b-p)/alpha)
//                 u1 = random()
//                 if p > 1.0:
//                     if u1 <= x ** (alpha - 1.0):
//                         break
//                 elif u1 <= _exp(-x):
//                     break
//             return x * beta


// float AMRandom::gammaFloat(float a, float b)
// {
//     return 0.0;
// }
// 


//     def betavariate(self, alpha, beta):
//         """Beta distribution.
// 
//         Conditions on the parameters are alpha > 0 and beta > 0.
//         Returned values range between 0 and 1.
// 
//         """
// 
//         # This version due to Janne Sinkkonen, and matches all the std
//         # texts (e.g., Knuth Vol 2 Ed 3 pg 134 "the beta distribution").
//         y = self.gammavariate(alpha, 1.)
//         if y == 0:
//             return 0.0
//         else:
//             return y / (y + self.gammavariate(beta, 1.))


// float AMRandom::betaFloat(float a, float b)
// {
//     return 0.0;
// }
// 



//! Return a random integer within a beta distribution inclusive min and max values
// long AMRandom::betaLong(int min, int max)
// {
//     // for testing; need to do math on 0-1 uniform interval
//     return AMRandom::uniformFloat();
// }
// 








