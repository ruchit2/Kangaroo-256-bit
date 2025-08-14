#ifndef TIMERH
#define TIMERH

#include <time.h>
#include <string>
#ifdef WIN64
#include <windows.h>
#else
#include <sys/time.h>  // Add this include for struct timeval
#endif

class Timer {

public:
  static void Init();
  static double get_tick();
  static void printResult(char *unit, int nbTry, double t0, double t1);
  static std::string getResult(char *unit, int nbTry, double t0, double t1);
  static int getCoreNumber();
  static std::string getSeed(int size);
  static void SleepMillis(uint32_t millis);
  static uint32_t getSeed32();
  static uint32_t getPID();
  static std::string getTS();

#ifdef WIN64
  static LARGE_INTEGER perfTickStart;
  static double perfTicksPerSec;
  static LARGE_INTEGER qwTicksPerSec;
#else
  static struct timeval tickStart;  // Changed from time_t to struct timeval
#endif

};

#endif // TIMERH
