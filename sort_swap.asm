;;Usage:Take user input of an array size of 5 , sort the array and print out sorted value 
s0: DC "Enter the array: \0" 
MAX_SIZE: DD 5 

;;main()   
addi t0,zero,s0 
;;ask for user input 
ecall x0,t0,4   ;; print(s0)  

addi sp,sp,-56  ;; Make space for a[5](0-32) and size (40)  
sd zero,0(sp)   ;; Init arr to zero
sd zero,8(sp)   ;; Init arr to zero
sd zero,16(sp)  ;; Init arr to zero 
sd zero,24(sp)  ;; Init arr to zero 
sd zero,32(sp)  ;; Init arr to zero 
addi t1,zero,0         ;; size =0 
sd t1,40(sp)     ;; stack[40] = *size  
sd ra,48(sp)    ;; return address  store 48(sp)  
jal ra , L2            ;; jump to L2 ( take user input)   
;;printArr(&arr[0],int n)  
ld t2,40(sp)    ;; load size to t2 
add a4,zero,t1 ;; printArr(int a[],int size) 
addi t2,sp,0    ;; t2= &arr[0] 
add a5,zero,t2        ;; a5=t2  
;; jump and link to printArr

;;while() innter loop
L1: 

    ld t1,40(sp)     ;; load current size  
    slli t1,t1,3    ;; Mul by 8 to get bytes addr 
    ;;get *a[] to the first element in the array 
    ld t4,0(sp)     ;;load the first element  
    add t3,t1,t4        ;; t3 = &a[size]  
    ecall t2,x0,4      ;; int d= scanf("%d")   
    sd t2,0(t3)     ;; *t3= d      
    addi t1,t1,1         ;; size++ 
    sd t1,40(sp)    ;; store size++ to memory 

;;  while(size<=MAX_SIZE) 
L2: 
   ld t1,MAX_SIZE(zero)    ;; Load MAX_SIZE  to register    
   ld t2,40(sp)         ;; Load size to register  
   bge t2,t1,L1         ;; while(size<=MAX_SIZE) go to innter looop 
   jalr x0,0(ra)        ;; return to calle at line 17  

;; void printArr(int v[], int *  size) (a5 ,a4) 
printArr:    
   addi sp,sp,-8    ;;make room for int i at 48 
   sd zero,56(sp)   ;; Store *i=0 in register 
   jal ra,L3             ;; jump to for loop    
L3: 
  ld a3,56(sp)      ;; load current value of i      
  bge a4,a3,L4
  ;;Loop clean up 
  addi sp,sp,8     ;;pop int i off the stack 
  ld ra,48(sp)      ;; load the return address                
  jalr zero,0(ra)   ;; return to callee  
L4:        
   ld a3,56(sp)     ;;load the value of i 
   slli a3,a3,3    ;;i*8= mem_offset 
   add a6,a4,a3   ;;get &arr[i] 
   ld a6,0(a6)     ;; a6= *arr[i]
   ecall x1,a6,0   ;;printf("%d",*a6)    
   jal ra,L3  


;;Sort an array from min to max 




