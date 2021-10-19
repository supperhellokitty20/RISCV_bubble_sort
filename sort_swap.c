
#include<stdio.h> 

#define MAX_SIZE 5 
#include <stdio.h>
void swap( int v[], int k)

{
    int temp;
    temp = v[k];
    v[k] = v[k+1];
    v[k+1] = temp;
}
// Function wo perform Selection Sort
void sort (int v[], int n)
{
    int i, j;
    for (i = 0; i < n; i += 1) {
        j=i-1 ;
        for (j ; j >= 0 && v[j] > v[j + 1]; j -= 1) {
            swap(v,j);
        }
    }
}

void print( int a[] , int *size) {
    int i=0; 
    for(i;i<*size;i++) {
        printf("%d ",a[i]) ;

    } 
    printf("\n") ; 

}  

int main(){  
    int a[MAX_SIZE]={0};
    int size=0 ;
    printf("Enter the array: ")  ;

    while(size<MAX_SIZE) {
        int d; 
        scanf("%d",&d) ;
        a[size]= d; 
        size++ ;
    }
    print(a,&size) ;
    sort(a,size) ;     
    print(a,&size) ;
    return 0 ;
} 
