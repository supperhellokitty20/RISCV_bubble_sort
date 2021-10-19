;; Ask user to input an array of 5 and store them in memory 
MAX_SIZE: DD 5  ;; define max_size of the array 
SIZE: DD 0     ;; define current_size of the array  
BREAKLINE: DC "\n\0" 

RETURN_ADD: DD 1 ;;define the memory location for the return add 
s1: DC "End\0" 
s2: DC "End Print\0" 

;;main
addi sp,sp,-40  ;; make space for arr[5] starting offset at 32->0 
addi s0,sp, 0   ;; contain the array arrdress 

whileL: ld t1,SIZE(zero)      ;;load current size  
        ld t2,MAX_SIZE(zero)  ;; load max size 
        beq t2,t1,exit        ;;Check break condition of the loop 
        ;;get arr[i]
        slli t3,t1,3          ;; shift current size to get addr offset  
        add t4,t3,s0          ;; get &arr[i]           
        ;;take user input 
        ecall t5,x0,5         ;;read int  
        sd t5,0(t4)            ;; d=*arr[i]
        addi t1,t1,1            ;; size++
        sd t1,SIZE(zero)    ;; store size to memory
        jal ra,whileL

exit:  addi t1,zero,s1              
       ecall x0,t1,4  
;;printArr(arr[],size) 
addi a0,s0,0  
ld a1,SIZE(zero) 
;;print the sorted array
jal ra,printArr ;; printArr 
addi t0,zero,s2 ;;load string s2 to the mem
ecall x1,t0,4   ;; print(s2)  

;;sort array here 

jal ra, main_end;; jump to infinite loop 

main_end: 
    jal ra,main_end 

;;______________________________________
;; SORTING FUNCTIONS 
;; void sort(int a[], int size) -> a0,a1  

;;---------------------------------
;; PRINTING ARRAY PART

;; void printArr(int a[], int size) assume paramenter is in a0->&a[] ,a1  
printArr:  
          addi a3,zero,0  ;; int i=0  
          sd ra,RETURN_ADD(zero) ;; store return address 
;; for(;;) 
loop1:   
        beq a3,a1,exit1  ;; if i==size go to exit 
        slli a5,a3,3 ;; i*8=addr offset       
        add a5,a5,a0 ;; &arr[i]= *(arr[0]+offset) 
        ld a4,0(a5)  ;; &arr[i] 
        ecall x0,a4,0 ;; print *arr[i]        
        addi a3,a3,1    ;; i++ 
        jal ra,loop1

exit1: 
    ld ra,RETURN_ADD(zero) 
    jalr x0,0(ra)

