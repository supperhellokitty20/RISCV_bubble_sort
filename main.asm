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
;;sort the array here 
addi a0,s0,0  
ld a1,SIZE(zero) 
jal ra,sort   
;;print the sorted array
addi a0,s0,0  
ld a1,SIZE(zero) 
jal ra,printArr ;; printArr 
addi t0,zero,s2 ;;load string s2 to the mem
ecall x1,t0,4   ;; print(s2)  


jal ra, main_end;; jump to infinite loop 

main_end: 
    jal ra,main_end 

;;______________________________________
;; SORTING FUNCTIONS 
;; void sort(int a[], int size) -> a0,a1  
sort:   sd ra,RETURN_ADD(zero) ;; store the return address from callee    
        addi sp,sp,-32 

        sd a4,0(sp)  ;; save a0 -> a4 
        sd a6,8(sp)  ;; save a1 -> a6  
        sd t0,16(sp) ;; save value  
        sd t1,24(sp) ;; save value  

        addi a4,a0,0 ;; coppy a0-> a4 -> &a[] 
        addi a6,a1,0 ;; coppy a1-> a6 -> size  
        addi t0,zero,0 ;; int i=0  
                    
sortLoop:   beq t0,a6,exitL1;; if i==n go to exit loop 
            addi t1,t0,-1   ;; j = i-1                       

sortLoop2:  blt t1,zero,exitL2  
            slli t3,t1,3 ;; j<<3                         
            add t3,t3,a4 ;; get &v[j] 
            ld t4,0(t3)  ;; *v[j]
            ld t5,8(t3) ;; *v[j+1]
            blt t4,t5,exitL2             
            beq t4,t5,exitL2 
            ;;swap                         
            addi a0,a4,0 
            addi a1,t1,0
            jal ra ,swap 
            ;;j-- 
            addi t1,t1,-1  
            jal ra,sortLoop2 

exitL2:     addi t0,t0,1 ;; i++  
            jal ra,sortLoop 
exitL1: 
    ;;Restore value of the regiser 
    ld a4,0(sp) 
    ld a6,8(sp) 
    ld t0,16(sp) 
    ld t1,24(sp) 
    addi sp,sp,32
    ;;load return address and jump back to callee
    ld ra,RETURN_ADD(zero) 
    jalr zero,0(ra) 

;; void swap(int v[] , int k) -> parameter is at a0 a1 
swap: 
    slli t2,a1,3  
    add t2,t2,a0 ;; &v[k] 
    ld t6,0(t2) ;; *v[k]
    ld s3,8(t2) ;; *v[k+1]

    sd s3,0(t2) ;; swap  
    sd t6,8(t2) ;;swap 
    jalr zero,0(ra)        


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

