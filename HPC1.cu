#include <iostream>
#include <cuda.h>
using namespace std;


__global__ void add(int *a)
{
int tid = threadIdx.x;
int no_of_threads = blockDim.x;
int step=1;

while(no_of_threads>0)
{
if(tid<no_of_threads)
{
	int first = tid*step*2;
	int second = first+step;
	
	a[first]+=a[second];
}
step<<=1;
no_of_threads>>=1;
}

}

__global__ void max(int *a)
{
int tid=threadIdx.x;
int step =1;
int no_of_threads = blockDim.x;

while(no_of_threads>0)
{
if(tid<no_of_threads)
	{
	int first = tid*step*2;
	int second = first+step;
	
	a[first] = a[first]>a[second]?a[first]:a[second];
	}
	step<<=1;
	no_of_threads>>=1;
}
}


__global__ void min(int *a)
{
int tid=threadIdx.x;
int step =1;
int no_of_threads = blockDim.x;

while(no_of_threads>0)
{
if(tid<no_of_threads)
	{
	int first = tid*step*2;
	int second = first+step;
	
	a[first] = a[first]<a[second]?a[first]:a[second];
	}
	step<<=1;
	no_of_threads>>=1;
}
}

__global__ void stdDev(int *a,int mean){
a[threadIdx.x]-=mean;
a[threadIdx.x]*=a[threadIdx.x];
}
        
int main()
{
int host_arr[]={1,2,3,4,5,6,7,8};
int *dev_arr;
int SIZE=8;

cudaMalloc((void**)&dev_arr,SIZE*sizeof(int));

//SUM AND AVERAGE
cudaMemcpy(dev_arr,host_arr,SIZE*sizeof(int),cudaMemcpyHostToDevice);
add<<<1,SIZE/2>>>(dev_arr);

int sum;
cudaMemcpy(&sum,dev_arr,sizeof(int),cudaMemcpyDeviceToHost);

int mean=sum/SIZE;

cout<<"Sum is : "<<sum;
cout<<"Average is : "<<mean;

//MAX
cudaMemcpy(dev_arr,host_arr,SIZE*sizeof(int),cudaMemcpyHostToDevice);
max<<<1,SIZE/2>>>(dev_arr);

int max;
cudaMemcpy(&max,dev_arr,sizeof(int),cudaMemcpyDeviceToHost);

cout<<"Max is : "<<max;

//MIN

cudaMemcpy(dev_arr,host_arr,SIZE*sizeof(int),cudaMemcpyHostToDevice);
min<<<1,SIZE/2>>>(dev_arr);

int min;
cudaMemcpy(&min,dev_arr,sizeof(int),cudaMemcpyDeviceToHost);

cout<<"Min is : "<<min;

cout<<"\n\n";
//STDDV
cudaMemcpy(dev_arr,host_arr,SIZE*sizeof(int),cudaMemcpyHostToDevice);
stdDev<<<1,SIZE>>>(dev_arr,mean);
cudaMemcpy(host_arr,dev_arr,SIZE*sizeof(int),cudaMemcpyDeviceToHost);
cout<<host_arr[0];
cout<<host_arr[1];
cout<<host_arr[2];
cout<<host_arr[3];
cout<<host_arr[4];
cout<<host_arr[5];
cout<<host_arr[6];
cout<<host_arr[7];

cout<<"\n\n";

cudaMemcpy(dev_arr,host_arr,SIZE*sizeof(int),cudaMemcpyHostToDevice);
add<<<1,SIZE/2>>>(dev_arr);
int stdDeviation;
cudaMemcpy(&stdDeviation,dev_arr,sizeof(int),cudaMemcpyDeviceToHost);
cout<<"STDDEV:"<<sqrt(stdDeviation/SIZE); 

}
