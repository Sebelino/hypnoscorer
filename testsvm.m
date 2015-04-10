X = [1 1;2 1;1 2;4 4;4 5;4 6];
y = {'A','A','A','B','B','B'}';

m = fitcsvm(X,y);
sv = m.SupportVectors;

figure
gscatter(X(:,1),X(:,2),y)
hold on
plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
