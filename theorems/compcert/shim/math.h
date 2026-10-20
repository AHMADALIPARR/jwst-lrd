#ifndef LRDSWEEP_MATH_H
#define LRDSWEEP_MATH_H
/* Sweep shim: declarations only, so CompCert does not ingest glibc's
   mathcalls headers (which use long double, outside CompCert's subset). */
double sqrt(double); double exp(double); double log(double); double log10(double);
double pow(double, double); double fabs(double); double floor(double); double ceil(double);
double sin(double); double cos(double); double tan(double); double asin(double);
double acos(double); double atan(double); double atan2(double, double);
double sinh(double); double cosh(double); double tanh(double);
float sqrtf(float); float fabsf(float);
#define INFINITY (1.0/0.0)
#define NAN (0.0/0.0)
#endif
