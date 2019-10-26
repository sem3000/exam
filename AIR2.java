class Node{
	Node left;
	Node right;
	String id;
	int value;

	Node(){
		left=null;
		right=null;
		id="";
		value=-1;
	}
}

public class AIR2{
	static Node getNode(String id, int value){
		Node temp = new Node();
		temp.id=id;
		temp.value=value;
		return temp;
	}

	public static void main(String args[]){
		Node root = getNode("A", 0);
		root.left = getNode("B", 0);
		root.right = getNode("C", 0);
		root.left.left = getNode("D", 0);
		root.left.right = getNode("E", 0);
		root.left.left.left = getNode("L1", 3);
		root.left.left.right = getNode("L2", 5);
		root.left.right.left = getNode("L3", 6);
		root.left.right.right = getNode("L4", 9);
		
		root.right.left = getNode("F", 0);
		root.right.right = getNode("G", 0);
		root.right.left.left = getNode("L5", 1);
		root.right.left.right = getNode("L6", 2);
		root.right.right.left = getNode("L7", 0);
		root.right.right.right = getNode("L8", -1);

		int result = show(root,-10000,10000,true);
		System.out.println(result);

	}

	private static int show(Node node,int alpha,int beta,boolean isMaximizing){
		System.out.println("Visited:"+node.id+", alpha:"+alpha+" beta:"+beta+"\n");
		if(node.left==null&&node.right==null)
			return node.value;

		
		if(isMaximizing){
			int bestVal=-10000;
			int val=show(node.left,alpha,beta,false);
			bestVal=max(val,bestVal);
			alpha=max(alpha,bestVal);

			if(beta>alpha){
			val=show(node.right,alpha,beta,false);
			bestVal=max(val,bestVal);
			alpha=max(alpha,bestVal);
			
		}
		return bestVal;
		}

		else{
			int bestVal=10000;
			int val=show(node.left,alpha,beta,true);
			bestVal=min(bestVal,val);
			beta=min(beta,bestVal);

			if(beta>alpha){
				val=show(node.right,alpha,beta,true);
			bestVal=min(bestVal,val);
			beta=min(beta,bestVal);
			}
			return bestVal;
			
		}
	}

	static int max(int a, int b) 
	{
		if(a>b)
			return a;
		else
			return b;	
	}

	static int min(int a, int b) 
	{
		if(a<b)
			return a;
		else
			return b;
		
}


}
	
