<h1 align="center">OmniBliss</h1>
<p align="center"></p>

<a href="https://hack36.com"> <img src="http://bit.ly/BuiltAtHack36" height=20px> </a>

## Introduction:
Official Repository of team EnigmaHaxx for Hack36 4.0
<br/>
Continuing our legacy from OmniEther (Hack 36 3.0), we present to you all this year's project, OmniBliss.
![Image of Homepage](./Images/OmniBlissLogo.jpeg?raw=true)

## Table of Contents:

## Technology Stack:
* MI Band Series(Bluetooth 5.0)
* Numpy, Pandas
* Scikit-Learn
* Matplotlib
* Django Web Framework
* Django Rest Framework
* Flutter
* Dart
* Git

## Survey (By kff.org)
* During the pandemic, about 4 in 10 adults in the U.S. have reported
symptoms of anxiety or depressive disorder.
* This number increased from one in ten adults who reported these
symptoms from January to June 2019.
* Similar is the case with citizens of other countries as well.
Problem Statement
* Devising a way to tackle these increasing levels of stress and anxiety
among the general population and create an environment of Bliss.


## Problem Statement
* Devising a way to tackle these increasing levels of stress and anxiety
among the general population and create an environment of Bliss.


## Proposed Solution
* Assigning user to a cluster (in backend) based on profile
data provided.
* Connecting user’s wearable device (MI Band) to our app
using Bluetooth.
* Collecting user’s real-time Data (Heart Beat, Steps, etc)
from wearable devices (MI Band).
* Calculating Heart Rate Variability from that data
(R-R intervals).
* Detecting whether the user is stressed or not from above data using
a pre-trained ML model.
* Recommending user some activities to reduce the stress level based
on the cluster user belongs to.

## Implementation Details
* We are recording 100 consecutive R-R intervals from the wearable
device.
* We send this value to the Server for further calculation.
* 18 HRV parameters are calculated based on this value.
* Time domain features - Mean_RR, SDNN, SDSD, RMSSD, CVSD, etc.
Frequency domain features - LF, HF, TP, LF/HF Ratio, etc.
* Using this data, we predict whether user is stressed or not.
* If the user is stressed, we recommend user some activities based on
pre - determined cluster.

## Wow Factor
* Emergency Contact (SOS) Button.
* Relaxing UI.
* Soothing Background Music in the app.

## Future Work
* Generalising our app for most of the wearable devices
in market like Fitbits, MI Band(s), AmazFit, etc.
* Creating our own hardware.
* Improving Recommendation System.



## Contributors:
Team Name: EnigmaHaxx
* <a href="https://github.com/ankitsangwan1999">Ankit Sangwan</a>
* <a href="https://github.com/arc29">Aritra Chatterjee</a>
* <a href="https://github.com/thisismanishkumar">Manish Kumar</a>
* <a href="https://github.com/pirateksh">Kshitiz Srivastava</a>

### Made at:
<a href="https://hack36.com"> <img src="http://bit.ly/BuiltAtHack36" height=20px> </a>
