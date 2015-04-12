%X = [1 1;2 1;1 2;4 4;4 5;4 6];
%X = [rand(100,1),rand(100,1);rand(100,1)+2,rand(100,1)+2];
quantity = 1000;
rands = [rand(quantity,1),2*pi*rand(quantity,1)];
polarands = [rands(:,1),rands(:,1)].*[cos(rands(:,2)),sin(rands(:,2))];
X = [ones(quantity,2)+polarands;3*ones(quantity,2)+polarands];
%y = {'A','A','A','B','B','B'}';
y = [repmat({'A'},quantity,1);repmat({'B'},quantity,1)];

m = fitcsvm(X,y);
sv = m.SupportVectors;

figure
gscatter(X(:,1),X(:,2),y)
hold on
plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
