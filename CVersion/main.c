#include<stdio.h>
#include<stdlib.h>
// Declare Variables and arrays
int peg1 [9] = {0,0,0,0,0,0,0,0,9};
int peg2 [9] = {0,0,0,0,0,0,0,0,9};
int peg3 [9] = {0,0,0,0,0,0,0,0,9};
int size = 0;
char t0 [] = "         |             "; 
char t1 [] = "        +|+            ";
char t2 [] = "       ++|++           ";
char t3 [] = "      +++|+++          ";
char t4 [] = "     ++++|++++         ";
char t5 [] = "    +++++|+++++        ";
char t6 [] = "   ++++++|++++++       ";
char t7 [] = "  +++++++|+++++++      ";
char t8 [] = " ++++++++|++++++++     ";
char t9 [] = "XXXXXXXXXXXXXXXXXXX    ";

void PrepPeg1();
void displayPegs();
const char* getDisk(int n);
void solve(int size, int source[9],int dest[9],int spare[9]);
void move (int num, int source [9], int dest [9]);

int main(int argc, char *argv[])
{
  // Error handling 
	if (argc > 2){
		printf("More than two argumentss provided\n");
		return(0);
	}else if(argc<2){
		printf("Less than two arguments provided\n");
		return (0);
	}
  // Turn the commandline argument into a integer
	size = atoi(argv[1]);
	// If this returns 0 it has to not be an integer (we checked for the 0 int before)
	if (size == 0){
		printf ("Please enter an integer... \n");
		return 0;
	}
	// Organize the first peg with the size inputed
	PrepPeg1();
	// print the pegs once
	displayPegs();
	// call the solve method
	solve(size, peg1, peg2, peg3);
  // exit program
	return(0);
}
// Recursive solve function
void solve(int size, int source[9],int dest[9],int spare[9]){
  // Check the base case
	if (size == 1){
		move(size, source, dest); // Move the peg
		return;     
	}
	solve(size-1, source, spare, dest); // solve the left side of the tree
	move (size, source, dest);          // move the source to the destination
	solve(size-1, spare, dest, source); // sovle the right side of the tree

}
// Move function
void move(int num, int source [9], int dest [9]){
	getchar(); // stall the program waiting for user input
	for (int i = 0; i <8; i++){ // iterate through source peg
		if (source[i] !=0){       // check to find the first non 0 block
			source[i]=0;            // set that block to 0
			break;                  // exit the loop once this is done
		}
	}
	for (int i = 0; i<9; i++){ // iterate through the destination peg
		if (dest[i] == 0){       // check for the first non zero item
		}else{
			dest[i-1]= num;       // take the item before it and set it to the block we are moving
			break;                // exit loop
		}
	}
	displayPegs();            // display the pegs

}
// Arrange teh first peg
void PrepPeg1(){  
	int tempsize = size;          // set tempsize to size
	for (int c = 7; c >0; c--){   // iterate through items of peg1
		peg1[c] = tempsize;         // set the current peg to tempsize
		tempsize--;                 // decrement peg size
		if (tempsize == 0){         // if the tempsize is 0 exit loop
			c = 0;
		}
	}

}
// display pegs
void displayPegs(){                 
	for (int d = 0; d <9; d++){       // iterate through all 3 pegs index
		printf("%s",getDisk(peg1[d]));  // print peg1
		printf("%s",getDisk(peg2[d]));  // print peg2
		printf("%s\n",getDisk(peg3[d]));// print peg3
	}
}
// get the item to print out 
const char* getDisk(int n){
	if (n == 0){       // return t0 for 0
		return t0;
	} else if (n ==1){
		return t1;
	} else if (n ==2){
		return t2;
	} else if (n ==3){
		return t3;
	} else if (n ==4){
		return t4;
	} else if (n ==5){
		return t5;
	} else if (n ==6){
		return t6;
	}else if (n ==7){
		return t7;
	} else if (n ==8){
		return t8;
	} else{
		return t9;
	}
}
