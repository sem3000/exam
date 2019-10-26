#include<omp.h>
#include<iostream>
#include<time.h>
#include<stdlib.h>
using namespace std;
 
#define SIZE 20
void mergesort(int *a,int start, int end);
void merge(int *a, int start, int mid,int emid,int end);

int main(){
	int *a, *b;
	a = (int *)malloc(SIZE*sizeof(int));
	b = (int *)malloc(SIZE*sizeof(int));
	for(int i = 0;i < SIZE;i ++){
		a[i] = rand() % 182384;
		b[i] = a[i];
	}
	
	clock_t timer = clock();
	mergesort(a, 0, SIZE-1);
	timer = clock();
	//parallel_mergesort(b, 0, SIZE-1);
	cout << "\n Parallel sorting time : " << (float)(clock()-timer) / CLOCKS_PER_SEC;
	
	//Test case
	cout << "\nSorted array: \n";
	
	for(int i = 0;i < SIZE;i ++){
		cout << a[i] << endl;
	}


}

void mergesort(int *a,int start, int end){
	while(start<end){
		int mid = (start+end)/2;
		#pragma omp parallel sections
			{
			#pragma omp section
			{	
				mergesort(a,start,mid);
			}
			#pragma omp section
			{
				mergesort(a,mid+1,end);
			}
		}
		merge(a,start,mid,mid+1,end);
	}
}

void merge(int *a, int start, int mid,int emid,int end){
int i1=start;
int i2=emid;

int temp[end+1];
int k=0;

while(i1<=mid&&j1<=end){
	if(a[i1]<a[i2])
		temp[k++]=a[i1++];
	else
		temp[k++]=a[i2++];		
}

while(i1<=mid)
	temp[k++]=a[i1++];
while(i2<=end)
	temp[k++]=a[i2++];

for(int i=0;j=start;j<=end;i++){
	a[j]=temp[i];
}



}
