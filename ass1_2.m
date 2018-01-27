close all
clear all

L=200e-9;
W=100e-9;
n=100; %change
nsteps =1000; %change

tau_mn=0.2e-9 %seconds

m0=9.109e-31;
mn=0.26*m0;
T=300;
k=physconst('Boltzman');

vth = sqrt(2*k*T/mn);

%inititalize particle locations
x=rand(1,n)*L;
y=rand(1,n)*W;

%initialize previous location as first location just to get the plot
%started
xp = x;
yp = y;

%initialize random velocities
vx=vth*rand(1,n);
vy=vth*rand(1,n);

%double check this!!!!!!!!
dt=(L/vth)/100;

col=hsv(10); %vector of colours for particle trajectories
  for p = 1:10
        plot([x(p); xp(p)],[y(p); yp(p)],'color',col(p,:));  hold on
    end
    xlim([0 L])
    ylim([0 W])

    time=0;
%main timeloop
for aa=1:nsteps
    prevtime=time
    time = tic
    tic
    xp=x;
    yp=y;

    %scattering
    pscat=1-exp(-aa/tau_mn);
    scatCount= 0;
    
    for bb=1:n
        if (pscat > rand())
            vx(bb)=vth*rand();
            vy(bb)=vth*rand();
            scatCount = scatCount+1;
        end
    end

    dx=vx*dt;
    dy=vy*dt;
    
    %increment every particle over dt
    x=x+dx;
    y=y+dy;

    %xpath calc before boundary adjustment
    xpath=abs(x-xp); 
    
    %travelling restrictions (WALL)
     for a=1:n        
        %periodic boundaries at x=0 and x=L
         if (xp(a)< L && x(a)>=L)
            x(a)=x(a)-L;
            xp(a)=xp(a)-L;
         elseif (xp(a)< 0 && x(a)<0)
            x(a) = x(a)+L;
            xp(a)=xp(a)+L;
         end
         
        %specular boundaries at y=0 and y=W
        if (y(a)>=W || y(a)<=0)
            vy(a) = -vy(a);
        elseif y(a)<=0
          vy(a) = -vy(a);
        end
     end %end travelling restrictions loop
     

     %ypath calc after boundary adjustment
    ypath=abs(y-yp); 
    
    %calculate path - not sure if this is right
    path = sqrt(xpath.*xpath + ypath.*ypath);    
    
% plot(x,y,'o');hold on
  figure (1)
    %plot trajectories 
    for p = 1:10
        plot([x(p); xp(p)],[y(p); yp(p)],'color',col(p,:));  hold on
    end
    xlim([0 L])
    ylim([0 W])
    title ('Electron Collisions with Mean Free Path')
    pause(0.01);
      
end

meanfreepath = mean(path); %not sure if this is right

