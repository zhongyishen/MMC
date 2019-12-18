clear;
close all;
data1 = xlsread('data1.xlsx');
points = data1(:,2:4);
source = [data1(1,2:4),];
goal = [data1(end,2:4)];
verCorrX = []; % 垂直矫正点 颜色为蓝色
verCorrY = [];
verCorrZ = [];
horCorrX = []; % 水平矫正点 颜色为黄色
horCorrY = [];
horCorrZ = [];
alpha1 = 25;
alpha2 = 15;
beta1 = 20;
beta2 = 25;
theta = 30;
delta = 0.001;
verIndex = [];
horIndex = [];
r = 200; % 转弯半径 单位：m
for i = 1:length(data1)
    if data1(i,5) == 1
        verCorrX(end+1) = data1(i,2);
        verCorrY(end+1) = data1(i,3);
        verCorrZ(end+1) = data1(i,4);
        verIndex(end+1) = i;
    elseif data1(i,5) == 0 
        horCorrX(end+1) = data1(i,2);
        horCorrY(end+1) = data1(i,3);
        horCorrZ(end+1) = data1(i,4);
        horIndex(end+1) = i;
    end
end
horCorrPoints = [];
verCorrPoints = [];
horCorrPoints(:,1) = horCorrX;
horCorrPoints(:,2) = horCorrY;
horCorrPoints(:,3) = horCorrZ;
verCorrPoints(:,1) = verCorrX;
verCorrPoints(:,2) = verCorrY;
verCorrPoints(:,3) = verCorrZ;
corrPoints = (data1(2:end-1,2:4));
scatter3(source(1,1),source(1,2),source(1,3),100,'r','filled');hold on;
scatter3(goal(1,1),goal(1,2),goal(1,3),100,'r','filled');hold on;
scatter3(verCorrX,verCorrY,verCorrZ,'b','filled');hold on;  
scatter3(horCorrX,horCorrY,horCorrZ,'y','filled');hold on;
%% question2
figure(2)
scatter(source(1,1),source(1,2),100,'r','filled');hold on;
scatter(goal(1,1),goal(1,2),100,'r','filled');hold on;
scatter(verCorrX,verCorrY,'b','filled');hold on;  
scatter(horCorrX,horCorrY,'y','filled');hold on;

