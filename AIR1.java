public class AIR1{
	public static void main(String args[]){
		int visited[][]={{0,0,0},{0,0,0},{0,0,0}};
		int start[][]={{1,8,2},{-1,4,3},{7,6,5}};
		int end[][]={{1,2,3},{4,5,6},{7,8,-1}};

		int blank_i=1;
		int blank_j=0;

		while(heuristicCost(start,end)!=0){
			int up_cost=10000;
			int down_cost=10000;
			int left_cost=10000;
			int right_cost=10000;
			int min_cost=10000;
			String decision="none";

			if(blank_i>0){
				if(visited[blank_i-1][blank_j]!=1){
					up_cost=heuristicCost(end,swapBlank(start,blank_i,blank_j,blank_i-1,blank_j));
				}
			}
			
			if(blank_i<2){
				if(visited[blank_i+1][blank_j]!=1){
					down_cost=heuristicCost(end,swapBlank(start,blank_i,blank_j,blank_i+1,blank_j));
				}
			}
			if(blank_j>0){
				if(visited[blank_i][blank_j-1]!=1){
					left_cost=heuristicCost(end,swapBlank(start,blank_i,blank_j,blank_i,blank_j-1));
				}
			}
			if(blank_j<2){
				if(visited[blank_i][blank_j+1]!=1){
					right_cost=heuristicCost(end,swapBlank(start,blank_i,blank_j,blank_i,blank_j+1));
				}
			}
			if(up_cost<min_cost){
				min_cost=up_cost;
				decision="up";
			}
			if(down_cost<min_cost){
				min_cost=down_cost;
				decision="down";
			}
			if(left_cost<min_cost){
				min_cost=left_cost;
				decision="left";
			}
			if(right_cost<min_cost){
				min_cost=right_cost;
				decision="right";
			}
			if(decision.equals("up")){
				start=swapBlank(start,blank_i,blank_j,blank_i-1,blank_j);
				blank_i--;
			}
			if(decision.equals("down")){
				start=swapBlank(start,blank_i,blank_j,blank_i+1,blank_j);
				blank_i++;
			}
			if(decision.equals("left")){
				start=swapBlank(start,blank_i,blank_j,blank_i,blank_j-1);
				blank_j--;
			}
			if(decision.equals("right")){
				start=swapBlank(start,blank_i,blank_j,blank_i,blank_j+1);
				blank_j++;
			}
			for(int i=0; i<3; i++)
			{
				for(int j=0; j<3; j++)
				{
					visited[i][j]=0;
				}
			}
			visited[blank_i][blank_j]=1;
			System.out.println(decision);
			System.out.println(heuristicCost(start, end));
			for(int i=0; i<3; i++)
			{
				for(int j=0; j<3; j++)
				{
					System.out.print(start[i][j]+",");
				}
				System.out.print("\n");
			}
			System.out.println("");
		}
		

		

	}

	private static int heuristicCost(int[][] current,int[][] goal){
		int current_element=-1;
		int goal_i=-1;
		int goal_j=-1;
		int i=-1,j=-1;
		int cost=0;
		boolean found=false;
		
		for(i=0;i<3;i++){
			for(j=0;j<3;j++){
				current_element=current[i][j];
				found=false;

					for(goal_i=0;goal_i<3;goal_i++){
						for(goal_j=0;goal_j<3;goal_j++){
							if(goal[goal_i][goal_j]==current_element){
								found=true;
								break;
							}
						}
						if(found==true)
							break;
					}
				if(current_element!=-1)
					cost+=Math.abs(goal_i-i)+Math.abs(goal_j-j);
				
										
			}
		}	
		return cost;
	}
		
 	private static int[][] swapBlank(int[][] start,int blank_i,int blank_j,int blank_i1,int blank_j1){
		int temp[][]={{0,0,0},{0,0,0},{0,0,0}};
		for(int i=0;i<3;i++)
			for(int j=0;j<3;j++)
				temp[i][j]=start[i][j];
		
		int var=temp[blank_i][blank_j];
		temp[blank_i][blank_j]=temp[blank_i1][blank_j1];
		temp[blank_i1][blank_j1]=var;
		
		return temp;

	}


}
