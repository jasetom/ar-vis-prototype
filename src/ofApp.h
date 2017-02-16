#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxMaxim.h"
#include "ofxQCAR.h"


class ofApp : public ofxQCAR_App {
	
public:
    void setup();
    void update();
    void draw();
    void exit();
	
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    
    ofImage teapotImage;
    ofVec2f touchPoint;
    ofVec2f markerPoint;

    ofImage cameraImage;
    
    /* Sound stuff */
    void audioOut(float * output, int bufferSize, int nChannels); //audio output function
    int	initialBufferSize; //buffer size
    
    maxiSample samp, samp1,samp2,samp3; //maxi sample objects
    int sampleRate; //sample rate variable
    
    double playingSound; //variable where we store data when sound is playing
    bool playSound;
    
    float * lAudio; //left audio output
    float * rAudio; //right audio output
    
    /* FFT stuff */
    ofxMaxiFFT mfft;
    int fftSize;
    int bins, dataSize;
    

};


