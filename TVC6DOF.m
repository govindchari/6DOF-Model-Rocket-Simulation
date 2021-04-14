%% Nominal Vehicle Parameters
%Moments of Inertia (in kg m^2)
Ix_n=0.1;
Iy_n=0.1;
Iz_n=0.1;

%Mass (in kg)
m_dry_n=0.94;  %Mass of everything but fuel
g=9.81;

%Distance between CG and TVC Mount (in m)
l_n=0.3;

%% Control Parameters
%Control Cycle Time (in s)
dt=0.01;

%Servo Actuator Delay (in s)
servo_delay_n=0.08;

%Control Gains
kp=1;
kd=0.1;
ki=1;

%% Vehicle Parameter Error (variance from nominal values)
%Misalignment of TVC Mount on Y and Z axes (in m)
Ix_v=0.0001;
Iy_v=0.0001;
Iz_v=0.0001;
m_dry_v=0.0001;
servo_delay_v=0.01;
mis_y_v=0.001;
mis_z_v=0.001;
static_error_y_v=1;
static_error_z_v=1;
l_v=0.01;

%% Monte-Carlo
runs=100;
results=struct;
tic
for k=1:runs
    Ix_mc=Ix_n+randn*Ix_v;
    Iy_mc=Iy_n+randn*Iy_v;
    Iz_mc=Iz_n+randn*Iz_v;

    m_dry_mc=m_dry_n+randn*m_dry_v;
    l_mc=l_n+randn*l_v;
    servo_delay_mc=servo_delay_n+randn*servo_delay_v;
    mis_y_mc=randn*mis_y_v;
    mis_z_mc=randn*mis_z_v;
    static_error_y_mc=randn*static_error_y_v;
    static_error_z_mc=randn*static_error_z_v;
    
    sim('TVC6DOF_sim.slx',7);
    results.run(k)=ans;
end
toc

%% Plotting Simulated Trajectories
figure(1)
for i=1:runs
    plot3(results.run(1,i).position.signals.values(:,2),results.run(1,i).position.signals.values(:,3),results.run(1,i).position.signals.values(:,1))
    hold on
end
title(sprintf('%d Simulated Monte-Carlo Flight Trajectories',runs))
xlabel('Downrange (m)')
ylabel('Crossrange (m)')
zlabel('Altitude (m)')
axis equal