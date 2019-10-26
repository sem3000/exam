#include <cuda.h>
#include <stdio.h>
#include <iostream>

#define SIZE 100
#define n 2

using namespace std;

__global__ void vec_add(int *x,int *y,int *z)
{
int id = blockIdx.x*blockDim.x+threadIdx.x;
z[id]=x[id]+y[id];
}

__global__ void vec_mat_mul(int *mat,int *vec,int *o)
{
int x = threadIdx.x;
printf("\n%d",x);


o[x]=0;
for(int k=0;k<n;k++)
o[x]=o[x]+vec[k]*mat[k*n+k];

}

__global__ void mat_mul(int *a,int *b,int* c)
{
int x = threadIdx.x;
int y = threadIdx.y;

c[n*y+x]=0; //here col2
  for(int k=0;k<n;k++) //here col1
    c[n*y+x]=c[n*y+x]+a[n*y+k]*b[n*k+x];  //col2,col2,col1,col2
}


int main()
{
//vec_add
int a[SIZE],b[SIZE],c[SIZE];
int *d,*e,*f;

for(int i=0;i<SIZE;i++)
a[i]=b[i]=i;

cudaMalloc((void**)&d,SIZE*sizeof(int));
cudaMalloc((void**)&e,SIZE*sizeof(int));
cudaMalloc((void**)&f,SIZE*sizeof(int));

cudaMemcpy(d,a,SIZE*sizeof(int),cudaMemcpyHostToDevice);
cudaMemcpy(e,b,SIZE*sizeof(int),cudaMemcpyHostToDevice);

vec_add<<<5,20>>>(d,e,f);

cudaMemcpy(c,f,SIZE*sizeof(int),cudaMemcpyDeviceToHost);

printf("%d",c[50]);

//mat_mul
int mat1[n][n],mat2[n][n],mat3[n][n];
int *g,*h,*l;

for(int i=0;i<n;i++){
for(int j=0;j<n;j++){
mat1[i][j]=mat2[i][j]=1;
}}

cudaMalloc((void**)&g,n*n*sizeof(int));
cudaMalloc((void**)&h,n*n*sizeof(int));
cudaMalloc((void**)&l,n*n*sizeof(int));

cudaMemcpy(g,mat1,n*n*sizeof(int),cudaMemcpyHostToDevice);
cudaMemcpy(h,mat2,n*n*sizeof(int),cudaMemcpyHostToDevice);

dim3 threadBlock(n,n); //col2 row1
mat_mul<<<1,threadBlock>>>(g,h,l);

cudaMemcpy(mat3,l,n*n*sizeof(int),cudaMemcpyDeviceToHost);

for(int i=0;i<n;i++){
for(int j=0;j<n;j++){
printf("%d",mat3[i][j]);
}}


int mat4[n][n];
int *w;
int vec4[n],o4[n];
int *u,*out4;

for(int i=0;i<n;i++){
for(int j=0;j<n;j++){
mat4[i][j]=1;
}}

for(int i=0;i<n;i++)
vec4[i]=1;

cudaMalloc((void**)&w,n*n*sizeof(int));
cudaMalloc((void**)&u,n*sizeof(int));
cudaMalloc((void**)&out4,n*sizeof(int));

cudaMemcpy(w,mat4,n*n*sizeof(int),cudaMemcpyHostToDevice);
cudaMemcpy(u,vec4,n*sizeof(int),cudaMemcpyHostToDevice);

vec_mat_mul<<<1,n>>>(w,u,out4);

cudaMemcpy(o4,out4,n*sizeof(int),cudaMemcpyDeviceToHost);

cout<<"\n\n";
for(int i=0;i<n;i++)
cout<<o4[i];


return 0;
}
