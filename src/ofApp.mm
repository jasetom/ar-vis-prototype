#include "ofApp.h"

static const string kLicenseKey = "AfJ6d4//////AAAAAck2JyVaKEJarsb9283lT4EiMz7jNMKKEPuFlDhX9shBx1A41N05tPNEMHb4IMvsx3DNpjbyXLrUQJdJcwS2IzV4NdmwY7R8CkxZFeVKEotcSjh296otcRMmZPAYWRQAFL7f4ljQLMSVjvDFZRLf9/X5uIR+wNNTqK47d1NpPhDBv2usiT0Z8SxSej5Dn919ue2p8o8QGk/KThAFPVCwIQxigXauDlECHFB0EHvoNNatMVsjyMC3hKU/btXbCFMa2wL5ZM/nQgVeqveMv5eOygzCCLkDIMC2R8QRQzqAvH4h2I0YBJ0CMxD98AP45wEwxLOOLMRFdIOi2THxpVhWHSHiU/b6XSX96FHY/0eM3aul";

//--------------------------------------------------------------
void ofApp::setup(){
	ofBackground(0);
    ofSetOrientation(OF_ORIENTATION_DEFAULT);
    
    ofxQCAR & QCAR = *ofxQCAR::getInstance();
    QCAR.setLicenseKey(kLicenseKey); // ADD YOUR APPLICATION LICENSE KEY HERE.
    QCAR.addMarkerDataPath("qcar_assets/Qualcomm.xml");
    QCAR.autoFocusOn();
    QCAR.setCameraPixelsFlag(true);
    QCAR.setup();
    
    
    /*sound setup*/
    sampleRate 			= 44100; /* Sampling Rate */
    initialBufferSize	= 512;	/* Buffer Size. you have to fill this buffer with sound*/
    
    //left and right audio output sizes
    lAudio = new float[initialBufferSize];
    rAudio = new float[initialBufferSize];
    
    //loading sample track
    samp1.load(ofToDataPath("beat2.wav"));
    samp2.load(ofToDataPath("beat3.wav"));
    samp3.load(ofToDataPath("beat4.wav"));

    samp = samp1;
    
    //set up maxim
    ofxMaxiSettings::setup(sampleRate, 2, initialBufferSize);
    
    //setup fft
    fftSize = 1024;
    mfft.setup(fftSize, 512, 256);
    
    //this allows to mix audio from other apps
//    ofxiOSSoundStream::setMixWithOtherApps(true);
    //this starts DAC using opeframeworks
    ofSoundStreamSetup(2, 0, this, sampleRate, initialBufferSize, 4);
}

//--------------------------------------------------------------
void ofApp::update(){
    ofxQCAR & QCAR = *ofxQCAR::getInstance();
    QCAR.update();
}

//--------------------------------------------------------------
void ofApp::draw(){

    ofxQCAR & QCAR = *ofxQCAR::getInstance();
    QCAR.drawBackground();
    

    
    bool bPressed;
    bPressed = touchPoint.x >= 0 && touchPoint.y >= 0;
    
    if(QCAR.hasFoundMarker()) {
        playSound = true;

        ofDisableDepthTest();
        ofEnableBlendMode(OF_BLENDMODE_ALPHA);
        ofSetLineWidth(3);

        
//        QCAR.drawMarkerRect();
//        QCAR.drawMarkerBounds();
        ofSetColor(ofColor::cyan);
//        QCAR.drawMarkerCenter();
        QCAR.drawMarkerCorners();
        
        ofSetColor(ofColor::white);
        ofSetLineWidth(1);
        
        ofEnableDepthTest();
        ofEnableNormalizedTexCoords();
        
        QCAR.begin();
        
        ofSetColor(255,133,133);
        ofFill();

        
        
        for(int i=0; i < fftSize / 8; i++) {
            
            ofSetColor(7*i,133,133);
            //place spheres in a circle using trig functions
            int x = cos(i)*100;
            int y = sin(i)*100;
            ofDrawSphere(x,y,150,5+mfft.magnitudes[i]*2);
        }
        
        ofSetColor(200);
        ofDrawRectangle(-100,0,0,200,30);
        ofSetColor(255,0,0);
        ofDrawBitmapString("Artist - SoundTrackName", -100, 0,10);



        QCAR.end();
        ofDisableNormalizedTexCoords();
        
    }else{
        playSound = false;
    }
    
    ofDisableDepthTest();
}

//--------------------------------------------------------------
void ofApp::exit(){
    ofxQCAR::getInstance()->exit();
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    samp = samp3;
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
//    samp = samp2;
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}

//--------------------------------------------------------------
void ofApp::audioOut(float * output, int bufferSize, int nChannels) {
    //audio output
        for (int i = 0; i < bufferSize; i++){
            //check wheter to play sound. Plays only when the AR marker is detected.
            if(playSound == true){

                //play sound
                playingSound = samp.play();
        
                //process sound and convert magnitudes to decibels in the mfft.
                if (mfft.process(playingSound)) {
                    mfft.magsToDB();
                }
                                                                //volume
                lAudio[i] = output[i * nChannels] = playingSound;// * 0.0;
                rAudio[i] = output[i * nChannels + 1] = playingSound;//* 0.0;
                
            }else{
                //if not playing set output to zero.
                lAudio[i] = output[i * nChannels] = 0;
                rAudio[i] = output[i * nChannels + 1] = 0;
            }
    }
}


