# Sudoku
# Raji Hadj Salah(raji.hadj-salah@stud.hs-ruhrwest.de)
# Tawfik Bouguerba(tawfik-bouguerba@stud.hs-ruhrwest.de)
# Wissenschaftliche Simulation

# HRW, 2017




import HRW

function sudoku(x::Int)

 if x == 1
  z=[0 6 0 0 0 9 0 0 0;
    0 0 9 0 1 6 3 0 0;
    0 8 7 0 0 0 9 6 0;
    3 0 6 0 0 0 0 4 5;
    0 7 0 4 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0;
    4 3 0 2 0 0 0 5 0;
    0 0 0 9 0 1 8 0 0;
    0 0 0 8 0 0 0 0 0]
elseif x == 2
  z=[0 4 0 0 0 0 0 7 0 ;
     9 0 6 0 7 0 1 0 4;
     0 1 0 8 0 5 0 9 0;
     0 0 9 3 0 7 6 0 0;
     0 7 0 0 0 0 0 2 0;
     0 0 4 5 0 6 7 0 0;
     0 9 0 6 0 2 0 5 0;
     5 0 1 0 9 0 2 0 8;
     0 2 0 0 0 0 0 6 0]
end

#allocate variables

V = 9^3             #  number of independent variables , a 9-by-9-by-9 array nombre variable
C = 4*9^2           #  number of constraints
A = zeros(C,V)      # allocate equality constraint matrix
b = ones(C)         # allocate constant vector
f = ones(V)
lb = zeros(V)       # an initial zero array
ub = ones(V)
ctype = repeat("S",C)
vartype = repeat("I",V)

t = 1 #counter

# one in each row
for j=1:9
    for k=1:9
         B = zeros(9,9,9)
         B[:,j,k] = 1
         A[t,:] = vec(B)
         t = t + 1
    end
end

# one in each column
for i = 1:9
    for k = 1:9
         B = zeros(9,9,9)
         B[i,:,k] = 1
         A[t,:]= vec(B)
         t = t + 1
    end
end

#one in each depth
for i = 1:9
    for j = 1:9
         B = zeros(9,9,9)
         B[i,j,:] = 1
         A[t,:] = vec(B)
         t = t + 1
    end
end

#one in each square
for m = 0:3:6
    for n = 0:3:6
        for k = 1:9
          B = zeros(9,9,9)
          B[m+(1:3),n+(1:3),k] = 1
          A[t,:] = vec(B)
          t = t + 1
        end
    end
end

# force the lower bound l[i,j,z[i,j]]
#to be equal to 1 when the box contains a value, in other words when z[i,j]is different than 0
l=zeros(Float64,9,9,9)
for i in 1:9
    for j in 1:9
        if z[i,j]!=0
          l[i,j,z[i,j]] = 1
        end
    end
end
# transform the matrix l to the vector lb
lb=vec(l)


s,w = HRW.glpk(f,A,b,lb,ub,ctype,vartype)
x=reshape(s,9,9,9)

# display of the solution
for i in 1:9
    for j in 1:9
       for k in 1:9
         if x[i,j,k]== 1
            z[i,j] = k
         end
       end
    end
end


return z
end
