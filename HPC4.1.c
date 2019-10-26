#include<mpi.h>
#include<stdlib.h>
#include<stdio.h>

#define n 12 

// value to be found
#define key 55

//input array
int a[] = { 1, 2, 3, 4, 5, 6, 7, 9, 13, 55, 56 ,90}; 
int a2[1000];

int binarySearch(int *a,int start,int end){
	while(start<=end){
		int mid = (start+end)/2;
		if(a[mid]==key)
			return mid;
		else if(a[mid]>key)
			end=mid-1;
		else
			start=mid+1;
			
	}
	return -1;
}

int main(int argc,char* argv[]){
	int pid,np,elements_per_process,n_elements_received;
	MPI_Status status;

	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD,&np);
	MPI_Comm_rank(MPI_COMM_WORLD,&pid);
	int i;

	if(pid==0){
		elements_per_process=n/np;

		if(np>1){
			for(i=1;i<np-1;i++){
				int index=i*elements_per_process;
				MPI_Send(&elements_per_process,1,MPI_INT,i,0,MPI_COMM_WORLD);
				MPI_Send(&a[index],elements_per_process,MPI_INT,i,0,MPI_COMM_WORLD);
			}
		
		int index=i*elements_per_process;
		int elements_left=n-index;


		MPI_Send(&elements_left,1,MPI_INT,i,0,MPI_COMM_WORLD);
		MPI_Send(&a[index],elements_left,MPI_INT,i,0,MPI_COMM_WORLD);
		}

		int position=binarySearch(a,0,elements_per_process-1);

		if(position!=-1)
			printf("Found at:%d", position);

		int temp;
		for( i=1;i<np;i++){
			MPI_Recv(&temp,1,MPI_INT,MPI_ANY_SOURCE,0,MPI_COMM_WORLD,&status);
			int sender=status.MPI_SOURCE;
			if(temp!=-1)
				printf("Found at:%d by %d", (sender*elements_per_process)+temp, sender);
        }

}


else{
		
	MPI_Recv(&n_elements_received,1,MPI_INT,0,0,MPI_COMM_WORLD,&status);
	MPI_Recv(&a2,n_elements_received,MPI_INT,0,0,MPI_COMM_WORLD,&status);
	
	int position = binarySearch(a2, 0, n_elements_received-1);
	MPI_Send(&position, 1, MPI_INT, 0, 0, MPI_COMM_WORLD);
	
	


}
MPI_Finalize();
return 0;
}
