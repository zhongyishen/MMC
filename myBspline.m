function p = myBspline(x,y,z)
p = false;
n = max(size(x));
d = sqrt((x(1)-x(n)).^2 + (y(1)-y(n)).^2 + (z(1)-z(n)).^2);
xu = [];yu = [];zu = [];
if d > 0.01
    % 开曲线端点增加处理
    x(n+2) = x(n);
    y(n+2) = y(n);
    z(n+2) = z(n);
    for i = n+1:-1:2
        x(i) = x(i-1);
        y(i) = y(i-1);
        z(i) = z(i-1);
    end
else
    x(n+2) = x(2);
    y(n+2) = y(2);
    z(n+2) = z(2);
    for i = n+1:-1:2
        x(i) = x(i-1);
        y(i) = y(i-1);
        z(i) = z(i-1);
    end
    x(1) = x(n);
    y(1) = y(n);
    z(1) = z(n);
end
n = n - 3; % 计算分段数
B = [-1 3 -3 1
    3 -6 3 0
    -3 0 3 0
    1 4 1 0] .* 1/6;
for i = 1:n
    x_i = [x(i:i+3)];
    y_i = [y(i:i+3)];
    z_i = [z(i:i+3)];
    j = 0;
    for u = 0:0.01:1
        U = [u^3 u^2 u 1];
        j = j + 1;
        x_u(j) = U * B * x_i;
        y_u(j) = U * B * y_i;
        z_u(j) = U * B * z_i;
    end
    xu(i,:) = x_u; 
    yu(i,:) = y_u;
    zu(i,:) = z_u;
    x_u = [];
    y_u = [];
    z_u = [];
end
plot3(x,y,z,'b');hold on;
% xlabel('X-Axis');
% ylabel('Y-Axis');
% zlabel('Z-Axis');
for i = 1:size(xu,1)
    plot3(xu(i,:),yu(i,:),zu(i,:));hold on;
end
p = true;


