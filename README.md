# 6DOF-Model-Rocket-Simulation

This project contains the 6DOF dynamics and controls simulation for a thrust vector controlled model rocket that
I am planning on building. The repo houses a Simulink file which houses the dynamics and controls loop and a Matlab 
script which storesthe mass properties and interacts with the Simulink model to conduct Monte-Carlo runs. In addition, 
the repo contains some images from the Monte-Carlo runs as well as a pdf of the dynamics and controls derivation.

## The Simulation
Newton's Second Law was used for traslational dynamics, Euler's equations were used for rotational 
dynamics, and quaternions were used to describe the rocket's attitude. The controller attempts to keep
the rocket in an upright position. 

The simulation is also meant to model a number of nonideal effects. Firstly, when screwing in a TVC mount
into the airframe of the rocket, there will likely be some misalignment such that the mount isn't perfectly
concentric with the airframe. Secondly, the servos that will drive the TVC mount do not point instintaneously,
so a delay is modeled. Thirdly, the servos will only have a finite range of motion due to the way they would be
mounted, so saturation limits are put into place on their pointing. Fourthly, the "static" position of the servos
will result in a the motor not pointing perfectly concentric with the airframe, so this small offset is also modeled.
Lastly, the sensor are not perfect, so gaussian noise is added into the truth readings.

In this simulation, the thrust curve fed into the simulation is that of an Estes F15 motor, which is the one I was planning
on using.

## Controls
The controller attempts to keep the vehicle upright and makes no attempt to control the position. 
The sensor that I will use use (Adafruit BNO055) outputs orientation as a quaternion, so it is convenient to use a PID controller that
operates on the vector part of the quaternion to produce a desired vehicle torque. Then based on the current thrust that the
motor provides as well as the knowledge of the TVC mount to COM distance, the TVC servo deflections are calculated to apply the
desired torque on the vehicle. However, black powder motors have quite a bit of variability from batch to batch, so it would not
be wise to determine the thrust that the motor provides from the provided thrust curve. Instead, based on the acceleration read by
the IMU and knowledge of the vehicle mass, the thrust can be calculated. This entire process of attitude control requires knowledge of
the distance from the TVC mount to the COM and the vehicle mass. Due to measurement error, the truth value and the measured value will be 
off by a little bit. These differences are then parameterized and varied in each Monte-Carlo run along with the other nonideal effects 
considered in the previous section.
