#include <opencv2/opencv.hpp>
#include <iostream>
#include <stdio.h>
using namespace cv;
using namespace std;
int main(int, char**)
{
    Mat frame;
    //--- INITIALIZE VIDEOCAPTURE
    VideoCapture cap;
    // open the default camera using default API
    cap.open(0);
    // OR advance usage: select any API backend
    int deviceID = 0;             // 0 = open default camera
    int apiID = cv::CAP_ANY;      // 0 = autodetect default API
                                  // open selected camera using selected API
    cap.open(deviceID + apiID);
    // check if we succeeded
    if (!cap.isOpened()) {
        cerr << "ERROR! Unable to open camera\n";
        return -1;
    }
    //--- GRAB AND WRITE LOOP
    cout << "Start grabbing" << endl
        << "Press any key to terminate" << endl;
    for (;;)
    {
        // wait for a new frame from camera and store it into 'frame'
        int64 e1 = getTickCount();
        cap.read(frame);
        int64 e2 = getTickCount();
        cout << "cap.read(frame); // executed for " << (e2 - e1) / getTickFrequency() << " sec\n";

        // check if we succeeded
        if (frame.empty()) {
            cerr << "ERROR! blank frame grabbed\n";
            break;
        }
        // show live and wait for a key with timeout long enough to show images
        imshow("Live", frame);
        int t = waitKey(5);
        if (t >= 0) {
            if (t == 255) {
                cout << "waitKey returned 255\n";
            }
            else {
                break;
            }
        }
    }
    // the camera will be deinitialized automatically in VideoCapture destructor
    getchar();
    return 0;
}
