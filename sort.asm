MAX_SIZE: DD 5 
s0: DC "End sort\0"  
RETURN_ADD: DD 1 

addi sp,sp,-40

addi t0,t0,5 
sd t0,0(sp)  

addi t1,t1,4 
sd t1,8(sp)  

addi t2,t2,3 
sd t2,16(sp)  

addi t3,t3,2 
sd t3,24(sp)  

addi t4,t4,1 
sd t4,32(sp)  

addi a0,sp,0 ;; get &arr[] 
ld  a1,MAX_SIZE(zero);; int size 
jal ra ,sort

jal ra, main_end;; jump to infinite loop 

main_end: 
    jal ra,main_end 


;;______________________________________
;; SORTING FUNCTIONS 
;; void sort(int a[], int size) -> a0,a1 -> Use a0 as the array pointer  

sort:   sd ra,RETURN_ADD(zero) ;; store the return address from callee    
        addi sp,sp,-16
        addi a4,zero,0 ;; int i=0  
        addi a6,a1,-1  ;;compute n-1  

sortLoop:   beq a4,a6,exitSort ;; if i==n go to exit loop 
                        

sortLoop2: 

exitL2: 


exitL1: 

swap: 


;;sort:   sd ra,RETURN_ADD(zero) ;; store the return address from callee    
;;        addi a4,zero,0 ;; int i=0  
;;        addi a6,a1,-1  ;;compute n-1  
;;
;;sortLoop:   beq a4,a6,exitSort ;; if i==n go to exit loop 
;;            addi a3,a4,0   ;; min_idx = i
;;            ;; t0 contain j   
;;            addi t0,a4,1  ;; j=i+1                          
;;
;;sortLoop2:  bge t2,t5,exitSort2 ;; if(arr[j]>=arr[min_idx]) continue the loop                        
;;            slli t1,t0,3  ;; shift j<<3 to get the byte address  
;;            add t1,t1,a0 ;; &arr[j] 
;;            ld  t2,0(t1) ;; *arr[j] 
;;            ;; a3 contain min_idx 
;;            slli t4,a3,3  ;;  min_idx<<3 to get byte adress 
;;            add t4,t4,a0 ;; get &arr[min_idx] 
;;            ld t5,0(t4)   ;; get *arr[min_idx] 
;;            ;;index swap  
;;            addi a3,a4,0 ;; min_idx= j
;;            jal sortLoop2  
;;exitSort2:
;;          ;; jump to swap to swap the element , need to pass in the parameter  
;;           addi a2,t4,0  ;; copy &arr[min_idx]            
;;           addi a3,t1,0  ;; copy &arr[j]  
;;           jal ra,swap  ;; call swap(int min_idx ,)  
;;           addi a5,a5,1 ;; i++              
;;           jal ra,sortLoop ;; jump back to sortLoop 
;;
;;           
;;;;Outer loop exit 
;;exitSort: 
;;    ld ra,RETURN_ADD(zero) 
;;    jarl  x0,0(ra);; jump back to calleee  
;;        
;;;; void swap (int *xp , int *yp) -> parameter is in a2 , a3  
;;swap: 
;;;; SWAP code goes below 
;;    slli t1,a2,3  ;; shift to the the offset  
;;    add a5,a0,t1 ;; get &xp 
;;    ld t7,0(a5)   ;; get temp =*xp  
;;
;;    slli t1,a3,3  ;; shift to get the offset 
;;    add a6,a0 ,t1 ;; get &yp 
;;    ld t4,0(a6)  ;; get *yp   
;;
;;    sd t7,0(t1)  
;;    sd t4,0(t5)  
;;    jalr zero,0(ra)  
;;    

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


