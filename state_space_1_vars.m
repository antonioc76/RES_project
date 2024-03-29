% 1 RC parameters
R0 = .05;
R1 = .005;
C = 500;
Q = 3600;

A_mat = [0, 0; 0, - 1 / (C*R1)];

B_mat = [1/Q; 1/C];

C_dummy = eye(2);

D_dummy = [0;0];

% initial conditions
z0 = 0.5;
V_c0 = 0;
x0 = [z0, V_c0]; 

% polynomail OCV linearization from homework
%p_0 = 3.4707;
%p_1 = 1.6112;
%p_2 = -2.6287; 
%p_3 = 1.7175;

% from project OCV(SOC) fit
%p_0 = 3.34848817924483;
%p_1 = 1.39726966353313;
%p_2 = -2.39845826415182;
%p_3 = 1.67743028643280;

% 5th order poly
p_5 = 20.9865358625928;
p_4 = -52.9516197704481;
p_3 = 48.7434451832868;
p_2 = -19.7495647885364;
p_1 = 3.74878321288425;
p_0 = 3.28229043218463;
