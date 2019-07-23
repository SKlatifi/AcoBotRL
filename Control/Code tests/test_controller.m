oldpath = addpath('..');

myplate = mockupPlate(3);
cost = pointTracker([0.25 0.25;0.75 0.25;0.75 0.75],0.02,1,0.1,1e6);
model = RLS(linspace(1000,10000,30),20,0.99,0.5,0.01,0.5,1.5);
planner = beamPlanner(1,20);
mycontroller = controller(myplate,model,cost,planner);
mycontroller.run();

path(oldpath);